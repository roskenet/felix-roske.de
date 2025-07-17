Title: Let’s Encrypt mit cert-manager auf k3s
Date: 2025-07-14
Tags: Certificates, HTTPS, CertManager
Summary: Warum pathType: Exact dein HTTPS blockiert (und wie du es fixt)

## Frustration 

Schon häufiger habe ich Webservices mit Let's Encrypt und dem cert-manager abgesichert. Also ging ich davon aus, dass das auch mit meinem neuesten Testprojekt kein Hexenwerk sein sollte.

Pustekuchen! 

Ziel war es, auf einer k3s-Installation den nginx-ingress zu benutzen und mit dem cert-manager per let's encrypt Zertifikate anzufordern.
Die Installation des nginx (ohne den Standard traefik) und des cert-managers per helm Chart war noch einfach. 

Doch aus einem verflixten Grund konnte die http01 Challenge nicht erfolgreich ausgeführt werden.

```
admission webhook "validate.nginx.ingress.kubernetes.io" denied the request:
ingress contains invalid paths: path /.well-known/acme-challenge/... cannot be used with pathType Exact
```

## PathType: Exact

Hmm... ok. Nach ein wenig Suchen ist klar: Der Punkt in .well-known scheint das Problem zu sein und man muss dem Ingress beibringen nicht `Exact` zu matchen. Kann ja nicht so schwer sein.

Dazu muss man sich erstmal klarmachen, dass es sich nicht um das Routing für die Domain handelt, die wir gerade deployen wollen:

```
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - www.mydomain.de
    secretName: polonium-tls
  rules:
  - host: www.mydomain.de 
    http: 
      paths: 
      - path: / 
        pathType: Prefix 
```

Diese Konfiguration ist völlig korrekt und auch der pathType ist nicht auf `Exact` gesetzt. Hier sind wir also falsch.

Nach längerem Nachdenken wird dann klar, dass es sich um die Einstellung im cert-manager handelt.

Also probiert man Folgendes:

```
    solvers:
    - http01:
        ingress:
          ingressClassName: nginx
          podTemplate:
            metadata:
              annotations:
                nginx.ingress.kubernetes.io/enable-access-log: "false"
          serviceType: ClusterIP
          pathType: ImplementationSpecific
```

Dieses yaml deployed allerdings nicht, weil http01 diese Einstellung nicht kennt und man bekommt nach `kubectl apply` den Fehler:

```
strict decoding error: unknown field "spec.acme.solvers[0].http01.ingress.pathType"
```

Ok. Google und auch ChatGPT sind einigermaßen ratlos. 
Es heißt sogar in manchen Posts, dies sei bekannt und schon längst gefixt.

Bei mir - im cert-manager 1.18.2 und dem aktuellen nginx - ist es das aber nicht.

## Die Lösung ACMEHTTP01IngressPathTypeExact

Nochmal die Docu des cert-manager durchsucht und siehe da:
Sehr klein und versteckt:

https://artifacthub.io/packages/helm/cert-manager/cert-manager#controller

unter dem Eintrag config findet sich der Schalter:

```
    ACMEHTTP01IngressPathTypeExact: true # BETA - default=true
```

Am einfachsten setzt man diesen in einem values.yaml wenn man das helm Chart für den cert-manager anwendet.

Also:

```
config:
  featureGates:
    ACMEHTTP01IngressPathTypeExact: false
```

Nun mit diesen values neu deployen (am besten das helm chart vorher komplett entfernen und dann neu anwenden:

```
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --set installCRDs=false \
  -f values.yaml
```

(Wenn die k8s resource Definitionen schon - wie empfohlen - per Hand deployed wurden.)

Und das sollte es gewesen sein. Mir ist es passiert, dass sich bereits bestehende Challenges nicht löschen ließen. Hier hilft Google.

Ein neues deployment des ingress manifests sollte nun eine neue Challenge triggern.

Juhu.

## Fazit & Lessons Learned

* cert-manager ist mächtig, aber... ruppig
* Ingress-Bugs wie dieser sollten besser dokumentiert sein
* Eine eigene values.yaml ist dein bester Freund
* Und: Verliere nie die Nerven. Du bist nicht allein!

