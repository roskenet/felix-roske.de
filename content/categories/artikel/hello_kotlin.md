Title: Hello Kotlin!
Date: 2024-01-22 12:55
Tags: Kotlin, Programmierung, Software
Summary: Fünf Wege zum "Hello World" in Kotlin

For centuries programmers start with "Hello World!". Why shouldn't we?
## Run "Hello World!" online

https://play.kotlinlang.org/

## Run "Hello World!" with kotlin

```kotlin
/*
   HelloWorld.kt
   Welcome to Kotlin!
*/

fun main() {
   println("Hello World!")
}
```

Let's compile it to Java Bytecode:
```shell
kotlinc HelloWorld.kt
```

And run it with the `kotlin` command.
```shell
kotlin HelloWorldKt
```

## Run "Hello World!" as a jar

To enable running our app without an installed kotlin, we simply include the batteries:

```shell
kotlinc HelloWorld.kt -include-runtime -d HelloWorld.jar
```

And then run it as any other Java jar:
```shell
java -jar HelloWorld.jar
```

## Compile to machine code

Kotlin can be compiled directly to native machine code on many architectures:

```shell
kotlinc-native HelloWorld.kt -o HelloWorld
```

Inspect our output and run it:
```shell
ldd HelloWorld.kexe
```

```shell
./HelloWorld.kexe
```

## Run a command line script

You want a scripting laguage? Here we go:

```
kotlin HelloWorld.kts
```

## Use the REPL
(Read Evaluate Print Loop)

```shell
❯ kotlin
Welcome to Kotlin version 1.9.10 (JRE 21+35)
Type :help for help, :quit for quit
>>> println("Hello World!")
Hello World!
>>> :quit
```

