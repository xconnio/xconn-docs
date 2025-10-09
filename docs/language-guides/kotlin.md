# xconn-kotlin
WAMP v2 Client for kotlin

## Prerequisites
Before creating or running a client, you must have a WAMP router running. The client needs to connect to a router to send and receive messages, so this step is essential.

We recommend using the [NXT](https://xconn.dev/nxt/) router, a lightweight and high-performance WAMP router built for flexibility and speed.

## Installation

To install `xconn-kotlin`, add the following in your `build.gradle` file:

### Install from maven central

```kotlin
dependencies {
    implementation("io.xconn:xconn:0.1.0-alpha.3")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.10.2")
}
```

### Install from github

```kotlin
dependencies {
    implementation("com.github.xconnio.xconn-kotlin:xconn:340feea4fb")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.10.2")
}
```

## Client

Creating a client:

```kotlin
package io.xconn

import io.xconn.xconn.connectAnonymous

suspend fun main() {
    val session = connectAnonymous("ws://localhost:8080/ws", "realm1")
}
```

Once the session is established, you can perform WAMP actions. Below are examples of all 4 WAMP
operations:

### Subscribe to a topic

```kotlin
suspend fun exampleSubscribe(session: Session) {
    session.subscribe("io.xconn.example", { event ->
        print("Received Event: args=${event.args}, kwargs=${event.kwargs}, details=${event.details}")
    }).await()
}
```

### Publish to a topic

```kotlin
suspend fun examplePublish(session: Session) {
    session.publish("io.xconn.example", args = listOf("test"), kwargs = mapOf("key" to "value"))?.await()
}
```

### Register a procedure

```kotlin
suspend fun exampleRegister(session: Session) {
    session.register("io.xconn.echo", { invocation ->
        Result(args = invocation.args, kwargs = invocation.kwargs)
    }).await()
}
```

### Call a procedure

```kotlin
suspend fun exampleCall(session: Session) {
    val result = session.call(
        "io.xconn.echo",
        args = listOf(1, 2),
        kwargs = mapOf("key" to "value")
    ).await()
}
```

## Authentication

Authentication is straightforward.

### Ticket Auth

```kotlin
val session = connectTicket("ws://localhost:8080/ws", "realm1", "authid", "ticket")
```

### Challenge Response Auth

```kotlin
val session = connectCRA("ws://localhost:8080/ws", "realm1", "authid", "secret")
```

### Cryptosign Auth

```kotlin
val session = connectCryptosign("ws://localhost:8080/ws", "realm1", "authid", "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13")
```

For more detailed examples or usage, refer to the sample [example](https://github.com/xconnio/xconn-kotlin/tree/main/example/src/main/kotlin) of the project.
