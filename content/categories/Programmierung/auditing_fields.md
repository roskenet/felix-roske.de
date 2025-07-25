Title: Auditing und Domain
Date: 2025-07-23 
Tags: JPA, Datenbanken, Auditing
Summary: Audit Fields sind keine Domain Fields: Warum Du technische und funktionale Timestamps trennen sollst.
Image: https://static.felix-roske.de/img/petunia_blue.jpg

## Spring Data JPA und Auditing

"Super! Wir haben ja schon ein createdAt und updatedAt Feld im Datenbank-Schema, das uns - Spring JPA Auditing sei Dank - 
immer gleich automatisch die richtigen Werte in die Entity prügelt.
Aber Moment mal – welches „created“ ist denn hier eigentlich gemeint? 
Hat der User gerade seine Bestellung ausgelöst? 
Oder hat der Systemprozess nachts um drei das Ding ins System gespült?

Und genau da liegt der Hase im Pfeffer: 
Technische Audit-Felder wie createdAt, updatedBy, deletedAt usw. 
gehören zur Infrastruktur – nicht zur Fachlichkeit. 
Sie sagen Dir, wann und von wem ein Datensatz verändert wurde. 
Das ist wichtig für Debugging, Logging und "Wer-war's?"-Blaming im Livebetrieb.

Aber sie haben rein garnichts mit der fachlichen Bedeutung eines Objekts zu tun. 
Ein invoice.createdAt ist eben nicht automatisch das Rechnungsdatum! 
Und order.updatedAt sagt Dir vielleicht, dass ein Admin mal kurz reingeguckt hat – aber nicht, 
dass sich was am Bestellstatus geändert hat.

Darum: Trenn das schön sauber!
Mach eine Spalte für das, was der Nutzer sieht („Bestellung ausgelöst am...“) und eine für das, 
was der Server protokolliert („Row inserted on...“).
Sonst kriegst Du irgendwann die Frage:

    „Warum wurde die Rechnung gestern erstellt, aber der Timestamp ist von letzter Woche?“

Tja. Weil's halt nicht das Gleiche ist.

Keep it clean!

Keep it getrennt!

Und hör auf, createdAt für alles zu benutzen!
