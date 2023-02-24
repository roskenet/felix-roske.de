Title: Log oder Rethrow - niemals beides!
Date: 2023-01-26 19:22
Tags: Exception-Handling, Programmierung, Software
Summary: Warum man immer nur eins von beidem macht...

## Log and rethrow
Sehr häufig sieht man in Code folgende Konstruktion:

``` Java
try {
    doSomething(weirdObject);
} catch (Exception e) {
    log.error(e);
    throw e;
}
``` 

Die Intension ist gut gemeint: doSomething wirft irgendeine (checked oder unchecked) Exception, die ich zwar hier nicht behandeln kann aber ich möchte meinem zukünftigen ich oder dem Kollegen, der irgendwann einmal die Logdatei liest, einen Hinweis darauf geben, dass hier etwas passiert ist.

## throw early, catch late
Getrieben wird diese Konstruktion von dem Gedanken, dass die Exception "weg" sei, wenn ich sie hier nicht fange und auslogge. Aber ist das denn so? Die rhetorische Frage deutet es an: Natürlich nicht.

Erstmal ist es grundsätzlich so, dass ich eine Exception nur dann mit einem catch-Block fange, wenn ich sinnvoll darauf reagieren kann. Dazu fallen mir Dinge ein, wie ein Retry-Mechanismus nach einem erfolglosen http-call. Also warte ich einfach ein wenig (bis der Zug aus dem Tunnel gefahren ist) und probiere es einfach nochmal.
Ein anderes Beispiel könnte die Anzeige einer sinnvollen Fehlermeldung auf der Benutzeroberfläche sein, bei der zwar die momentane Operation abgebrochen wird, die Anwendung aber nicht komplett geschlossen werden soll. 

Aber wann tut man das? Nach dem Grundsatz "throw early, catch late" fange ich die Exception so spät, wie möglich.
Auch das ist auf den ersten Blick einsichtig: In der Webservice-Client-Schicht meiner Anwendung hat Code, der die Benutzeroberfläche steuert rein garnichts zu suchen. Also reiche ich die Exception einfach weiter an die darüberliegende Schicht, denn ich kann mir ihr hier einfach nichts anfangen.

## Der Stack-Trace
Nach dem Motto "irgendwer wird sich schon darum kümmern" lehne ich mich also faul zurück - und logge die Exception hier auch nicht aus. Und zwar genau *weil* sich irgendwer darum kümmern wird. Allerspätestens nämlich die JVM, die meine Anwendung beendet und den Stacktrace auf die Konsole schreibt. Und in diesem Stacktrace sehe ich die komplette Reise, die diese Exception auf dem Weg vom throw bis hier gemacht hat, also auch die Methode, die in unserem Beispiel doSomething aufgerufen hat. Diese Information ist also keinesfalls verloren. 

Stellen wir uns nun vor, wir würden in jeder aufrufenden Methode diese Konstruktion programmieren, dann würden wir in unserem Logfile die selbe Exception ebenso häufig sehen. Eine Albtraum bei der Fehlersuche, weil wir ständig schauen müssten, welche Exception nun eigentlich die gleichen sind.  

## Zusammenfassung

Exceptions werden so früh wie möglich geworfen und so spät wie möglich gefangen. Entweder logge ich die Exception aus und behandele sie dann, oder ich lasse sie weiter den caller-stack nach oben blubbern.


