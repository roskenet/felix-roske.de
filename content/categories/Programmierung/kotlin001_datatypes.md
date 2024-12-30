Title: Kotlin 001 - Datentypen
Date: 2024-12-16
Tags: Kotlin, Datentypen
Summary: Die Datentypen in Kotlin im Überblick

## Alles ist ein Objekt

Kotlin stellt uns die "üblichen" Standard-Datentypen zur Verfügung:

```kotlin
    // Kotlin datatypes:
    val myByte: Byte = 42
    val myShort: Short = 42
    val myInt: Int = 42
    val myLong: Long = 42
    val myDouble: Double = 42.0
    val myFloat: Float = 42.0F
    val myChar: Char = '4'
    val myString: String = "The answer to the ultimate question of Life, the Universe and Everything is 42"
    val myBoolean: Boolean = true
```
Zu jedem ganzzahligen Typ gesellt sich noch das vorzeichenlose Pendant hinzu. (UByte, UShort, UInt, ULong)

Wichtig ist, dass es in Kotlin keine primitiven Datentypen gibt, 
sondern alle hier erzeugten Werte vollständige Objekte darstellen.

Außerdem kann keines dieser Werte hier `null` sein.
Folgender Code wird nicht compilieren: 

```kotlin
  var myString: String = null // Fehler!
```

`Null can not be a value of a non-null type String`.
(Zur eingebauten Nullsicherheit von Kotlin später mehr.)

Wir können also bei der Benutzung unserer oben erzeugten Werte immer sicher sein, 
mit einem technisch gültigen Objekt zu arbeiten. Ein Null-check ist nicht notwendig.