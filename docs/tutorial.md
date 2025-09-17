# Tutorial

This tutorial demonstrates how to use XConn across multiple programming languages.

## Installation

=== "Go"

    ``` go
    go get github.com/xconnio/xconn-go
    ```

=== "Python"

    ``` python
    uv pip install xconn
    ```

=== "Dart"

    Dart
    ``` dart
    dart pub add xconn
    ```

    Flutter
    ``` flutter
    flutter pub add xconn
    ```

=== "Swift"
    To install `xconn-swift`, add the following to your `Package.swift` file:

    Swift
    ``` swift
        let package = Package(
            dependencies: [
                .package(url: "https://github.com/xconnio/xconn-swift.git", branch: "main"),
            ],
            targets: [
                .executableTarget(name: "<executable-target-name>", dependencies: [
                    .product(name: "XConn", package: "xconn-swift"),
                ]),
            ]
        )
    ```

=== "Rust"
    To install `xconn-rust`, add the following to your `Cargo.toml` file:

    Rust
    ``` rust
    [dependencies]
    xconn = { git = "https://github.com/xconnio/xconn-rust", branch = "main" }
    ```

=== "Kotlin"
    To install `xconn-kotlin`, add the following in your `build.gradle` file:

    Kotlin
    ```kotlin
    dependencies {
        implementation("io.xconn:xconn:0.1.0-alpha.3")
    }
    ```

## Session Creation

=== "Go"

    ``` go
    package main

    import (
        "context"
        "log"
    
        "github.com/xconnio/xconn-go"
    )
    
    func main() {
        session, err := xconn.ConnectAnonymous(context.Background(), "ws://localhost:8080/ws", "realm1")
        if err != nil {
            log.Fatal(err)
        }
    }
    ```

=== "Python"
    Synchronous Session

    ``` python
    from xconn.session import Session
    from xconn.client import connect_anonymous
    
    session: Session = connect_anonymous("ws://localhost:8080/ws", "realm1")
    ```
    
    Asynchronous Session
    ``` python
    from xconn import run
    from xconn.async_session import AsyncSession
    from xconn.async_client import connect_anonymous
    
    async def main():
        session: AsyncSession = await connect_anonymous("ws://localhost:8080/ws", "realm1")
    
    if __name__ == "__main__":
        run(main())
    ```

=== "Dart"

    ``` dart
    import "package:xconn/xconn.dart";

    void main() async {
      var session = connectAnonymous("ws://localhost:8080/ws", "realm1");
    }
    ```

=== "Swift"

    ``` swift
    import XConn

    let client = Client()
    let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
    ```

=== "Rust"
    Synchronous Session

    ``` rust
    use xconn::sync::client::connect_anonymous;

    fn main() {
        let session = connect_anonymous("ws://localhost:8080", "realm1").unwrap_or_else(|e| panic!("{e}"));
    }
    ```

    Asynchronous Session
    ``` rust
    use xconn::async_::client::connect_anonymous;

    #[tokio::main]
    async fn main() {
        let session = connect_anonymous("ws://localhost:8080/ws", "realm1")
            .await
            .unwrap_or_else(|e| panic!("{e}"));
    }
    ```

=== "Kotlin"

    ```kotlin
    package io.xconn

    import io.xconn.xconn.connectAnonymous
    import kotlinx.coroutines.runBlocking

    fun main() =
        runBlocking {
            val session = connectAnonymous()
        }
    ```

## Subscribe to a topic

=== "Go"

    ``` go
    func exampleSubscribe(session *xconn.Session) {
    subscribeResponse := session.Subscribe("io.xconn.example", eventHandler).Do()
    if subscribeResponse.Err != nil {
        log.Fatalf("Failed to subscribe: %v", subscribeResponse.Err)
    }
    log.Printf("Subscribed to topic io.xconn.example")
    }
    
    func eventHandler(evt *xconn.Event) {
        fmt.Printf("Event Received: args=%s, kwargs=%s, details=%s", evt.Args, evt.Kwargs, evt.Details)
    }
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.types import Event
    from xconn.session import Session
    
    def example_subscribe(session: Session):
        session.subscribe("io.xconn.example", event_handler)
        print("Subscribed to topic 'io.xconn.example'")
    
    
    def event_handler(event: Event):
        print(f"Event Received: args={event.args}, kwargs={event.kwargs}, details={event.details}")
    ```
    
    Asynchronous
    ``` python
    from xconn.types import Event
    from xconn.async_session import AsyncSession
    
    async def example_subscribe(session: AsyncSession):
        await session.subscribe("io.xconn.example", event_handler)
        print("Subscribed to topic 'io.xconn.example'")
    
    
    async def event_handler(event: Event):
        print(f"Event Received: args={event.args}, kwargs={event.kwargs}, details={event.details}")
    ```

=== "Dart"

    ``` dart
    void exampleSubscribe(Session session) async {
      var subscription = await session.subscribe("io.xconn.example", eventHandler);
      print("Subscribed to topic io.xconn.example");
    }
    
    void eventHandler(Event event) {
      print("Received Event: args=${event.args}, kwargs=${event.kwargs}, details=${event.details}");
    }
    ```

=== "Swift"

    ``` swift
    func exampleSubscribe(_ session: Session) {
        try await session.subscribe(topic: "io.xconn.example", endpoint: eventHandler)
        print("Subscribed to topic io.xconn.example")
    }

    func eventHandler(_ event: Event) {
        print("Event received: args=\(event.args), kwargs=\(event.kwargs), details=\(event.details)")
    }
    ```

=== "Rust"
    Synchronous

    ``` rust
    use xconn::sync::session::Session;
    use xconn::sync::types::{Event, SubscribeRequest};

    fn example_subscribe(session: Session){
        let subscribe_request = SubscribeRequest::new("io.xconn.example", event_handler);
        match session.subscribe(subscribe_request) {
            Ok(response) => println!("{response:?}"),
            Err(e) => println!("{e}"),
        }
        println!("Subscribed to topic 'io.xconn.example'")
    }

    fn event_handler(event: Event) {
        println!(
            "Event Received: args={:?}, kwargs={:?}, details={:?}",
            event.args, event.kwargs, event.details
        );
    }
    ```

    Asynchronous
    ``` rust
    use xconn::async_::session::Session;
    use xconn::async_::types::{Event, SubscribeRequest};

    async fn example_subscribe(session: Session) {
        let subscribe_request = SubscribeRequest::new("io.xconn.example", event_handler);
        match session.subscribe(subscribe_request).await {
            Ok(response) => println!("{response:?}"),
            Err(e) => println!("{e}"),
        }
        println!("Subscribed to topic 'io.xconn.example'")
    }

    async fn event_handler(event: Event) {
        println!(
            "Event Received: args={:?}, kwargs={:?}, details={:?}",
            event.args, event.kwargs, event.details
        );
    }
    ```

=== "Kotlin"

    ```kotlin
    suspend fun exampleSubscribe(session: Session) {
        session.subscribe("io.xconn.example", { event ->
            print("Event Received: args=${event.args}, kwargs=${event.kwargs}, details=${event.details}")
        }).await()
        print("Subscribed to topic 'io.xconn.example'")
    }
    ```

## Publish to a topic

=== "Go"

    ``` go
    func examplePublish(session *xconn.Session) {
    publishResponse := session.Publish("io.xconn.example").Arg("test").Kwarg("key", "value").Do()
    if publishResponse.Err != nil {
        log.Fatalf("Failed to publish: %v", publishResponse.Err)
    }
    log.Printf("Publsihed to topic io.xconn.example")
    }
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.session import Session

    def example_publish(session: Session):
        session.publish("io.xconn.example", ["test"], {"key": "value"})
        print("Published to topic io.xconn.example")
    ```
    
    Asynchronous
    ``` python
    from xconn.async_session import AsyncSession

    async def example_publish(session: AsyncSession):
        await session.publish("io.xconn.example", ["test"], {"key": "value"})
        print("Published to topic io.xconn.example")
    ```

=== "Dart"

    ``` dart
    void examplePublish(Session session) async {
      await session.publish("io.xconn.example", args: ["test"], kwargs: {"key": "value"});
      print("Published to topic io.xconn.example");
    }
    ```

=== "Swift"

    ``` swift
    func examplePublish(_ session: Session) {
        try await session.publish(
            topic: "io.xconn.example",
            args: ["test"],
            kwargs: ["key": "value"],
        )
        print("Published to topic io.xconn.example")
    }
    ```

=== "Rust"
    Synchronous

    ``` rust
    use xconn::sync::session::Session;
    use xconn::sync::types::PublishRequest;

    fn example_publish(session: Session) {
        let publish_request = PublishRequest::new("io.xconn.example")
            .arg("test")
            .kwarg("key", "value");

        match session.publish(publish_request) {
            Ok(response) => println!("{response:?}"),
            Err(e) => println!("{e}"),
        }
        println!("Published to topic 'io.xconn.example'")
    }
    ```

    Asynchronous
    ``` rust
    use xconn::async_::session::Session;
    use xconn::async_::types::PublishRequest;

    async fn example_publish(session: Session) {
        let publish_request = PublishRequest::new("io.xconn.example")
            .arg("test")
            .kwarg("key", "value");

        match session.publish(publish_request).await {
            Ok(response) => println!("{response:?}"),
            Err(e) => println!("{e}"),
        }
        println!("Published to topic 'io.xconn.example'")
    }
    ```

=== "Kotlin"

    ```kotlin
    suspend fun examplePublish(session: Session) {
        session.publish("io.xconn.example", args = listOf("test"), kwargs = mapOf("key" to "value"))?.await()
        print("Published to topic 'io.xconn.example'")
    }
    ```

## Register a procedure

=== "Go"

    ``` go
    func exampleRegister(session *xconn.Session) {
    registerResponse := session.Register("io.xconn.echo", invocationHandler).Do()
    if registerResponse.Err != nil {
        log.Fatalf("Failed to register: %v", registerResponse.Err)
    }
    log.Printf("Registered procedure io.xconn.echo")
    }
    
    func invocationHandler(ctx context.Context, inv *xconn.Invocation) *xconn.InvocationResult {
        return xconn.NewInvocationResult()
    }
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.session import Session
    from xconn.types import Invocation
    
    def example_register(session: Session):
        session.register("io.xconn.echo", invocation_handler)
        print("Registered procedure io.xconn.echo")
    
    
    def invocation_handler(invocation: Invocation):
        print(f"Received args={invocation.args}, kwargs={invocation.kwargs}, details={invocation.details}")
    ```
    
    Asynchronous
    ``` python
    from xconn.types import Invocation
    from xconn.async_session import AsyncSession
    
    async def example_register(session: AsyncSession):
        await session.register("io.xconn.echo", invocation_handler)
        print("Registered procedure io.xconn.echo")
    
    
    async def invocation_handler(invocation: Invocation):
        print(f"Received args={invocation.args}, kwargs={invocation.kwargs}, details={invocation.details}")
    ```

=== "Dart"

    ``` dart
    void exampleRegister(Session session) async {
      var registration = await session.register("io.xconn.echo", invocationHandler);
      print("Registered procedure io.xconn.echo");
    }
    
    Result invocationHandler(Invocation invocation) {
      return Result(args: invocation.args, kwargs: invocation.kwargs, details: invocation.details);
    }
    ```

=== "Swift"

    ``` swift
    func exampleRegister(_ session: Session) {
        try await session.register(procedure: "io.xconn.echo", endpoint: echoHandler)
        print("Registered procedure io.xconn.echo")
    }

    func echoHandler(_ invocation: Invocation) -> Result {
        print("Received args=\(String(describing: invocation.args)), kwargs=\(String(describing: invocation.kwargs))")
        return Result(args: invocation.args, kwargs: invocation.kwargs)
    }
    ```

=== "Rust"
    Synchronous

    ``` rust
    use xconn::sync::session::Session;
    use xconn::sync::types::{Invocation, RegisterRequest, Yield};

    fn example_register(session: Session) {
        let register_request = RegisterRequest::new("io.xconn.echo", invocation_handler);
        match session.register(register_request) {
            Ok(response) => println!("{response:?}"),
            Err(e) => println!("{e}"),
        }
        println!("Registered procedure 'io.xconn.echo'")
    }

    fn invocation_handler(inv: Invocation) -> Yield {
        println!(
            "Received args={:?}, kwargs={:?}, details={:?}",
            inv.args, inv.kwargs, inv.details
        );
        Yield::new(inv.args, inv.kwargs)
    }
    ```

    Asynchronous
    ``` rust
    use xconn::async_::session::Session;
    use xconn::async_::types::{Invocation, RegisterRequest, Yield};

    async fn example_register(session: Session) {
        let register_request = RegisterRequest::new("io.xconn.echo", invocation_handler);
        match session.register(register_request).await {
            Ok(response) => println!("{response:?}"),
            Err(e) => println!("{e}"),
        }
        println!("Registered procedure 'io.xconn.echo'")
    }

    async fn invocation_handler(invocation: Invocation) -> Yield {
            println!(
                "Received args={:?}, kwargs={:?}, details={:?}",
                invocation.args, invocation.kwargs, invocation.details
            );
        Yield::new(invocation.args, invocation.kwargs)
    }
    ```

=== "Kotlin"

    ```kotlin
    suspend fun exampleRegister(session: Session) {
        session.register("io.xconn.echo", { invocation ->
            Result(args = invocation.args, kwargs = invocation.kwargs)
        }).await()
        print("Registered procedure 'io.xconn.echo'")
    }
    ```

## Call a procedure

=== "Go"

    ``` go
    func exampleCall(session *xconn.Session) {
    callResponse := session.Call("io.xconn.echo").Arg(1).Arg(2).Kwarg("key", "value").Do()
    if callResponse.Err != nil {
        log.Fatalf("Failed to call: %v", callResponse.Err)
    }
    log.Printf("Call result: args=%s, kwargs=%s, details=%s", callResponse.Args, callResponse.Kwargs, callResponse.Details)
    }
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.session import Session
    
    def example_call(session: Session):
        result = session.call("io.xconn.echo", [1, 2], {"key": "value"})
        print(f"Received args={result.args}, kwargs={result.kwargs}, details={result.details}")
    ```
    
    Asynchronous
    ``` python
    from xconn.async_session import AsyncSession

    async def example_call(session: AsyncSession):
        result = await session.call("io.xconn.echo", [1, 2], {"key": "value"})
        print(f"Received args={result.args}, kwargs={result.kwargs}, details={result.details}")
    ```

=== "Dart"

    ``` dart
    void exampleCall(Session session) async {
      var result = await session.call("io.xconn.echo", args: [1, 2], kwargs: {"key": "value"});
      print("Call result: args=${result.args}, kwargs=${result.kwargs}, details=${result.details}");
    }
    ```

=== "Swift"

    ``` swift
    func exampleCall(_ session: Session) {
        let result = try await session.call(
            procedure: "io.xconn.echo",
            args: [1, 2],
            kwargs: ["key": "value"]
        )

        print("Received args=\(String(describing: result.args)), kwargs=\(String(describing: result.kwargs))")
    }
    ```

=== "Rust"
    Synchronous

    ``` rust
    use xconn::sync::session::Session;
    use xconn::sync::types::CallRequest;

    fn example_call(session: Session) {
        let call_request = CallRequest::new("io.xconn.echo").arg(1).arg(2).kwarg("key", "value");
        let response = session.call(call_request).unwrap();
        println!("Received: args={:?}, kwargs={:?}", response.args, response.kwargs);
    }
    ```

    Asynchronous
    ``` rust
    use xconn::async_::session::Session;
    use xconn::async_::types::CallRequest;

    async fn example_call(session: Session) {
        let call_request = CallRequest::new("io.xconn.echo").arg(1).arg(2).kwarg("key", "value");

        let response = session.call(call_request).await.unwrap();
        println!("Received: args={:?}, kwargs={:?}", response.args, response.kwargs);
    }
    ```

=== "Kotlin"

    ```kotlin
    suspend fun exampleCall(session: Session) {
        val result = session.call(
            "io.xconn.echo",
            args = listOf(1, 2),
            kwargs = mapOf("key" to "value")
        ).await()
        print("Received: args=${result.args}, kwargs=${result.kwargs}, details=${result.details}");
    }
    ```

## Authentication

### Ticket Authentication

=== "Go"

    ``` go
    session, err := xconn.ConnectTicket(context.Background(), "ws://localhost:8080/ws", "realm1", "authid", "ticket")
    if err != nil {
        log.Fatalf("Failed to connect: %v", err)
    }
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.session import Session
    from xconn.client import connect_ticket
    
    session: Session = connect_ticket("ws://localhost:8080/ws", "realm1", "authid", "ticket")
    ```
    
    Asynchronous
    ``` python
    from xconn import run
    from xconn.async_session import AsyncSession
    from xconn.async_client import connect_ticket
    
    async def connect():
        session: AsyncSession = await connect_ticket("ws://localhost:8080/ws", "realm1", "authid", "ticket")
    
    if __name__ == "__main__":
        run(connect())
    ```


=== "Dart"

    ``` dart
    import "package:xconn/xconn.dart";

    void main() async {
      var session = connectTicket("ws://localhost:8080/ws", "realm1", "authid", "ticket");
    }
    ```

=== "Swift"

    ``` swift
    let authenticator = TicketAuthenticator(authID: "authid", ticket: "ticket")
    let client = Client(authenticator: authenticator)
    let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
    ```

=== "Rust"
    Synchronous

    ``` rust
    use xconn::sync::client::connect_ticket;

    let session = connect_ticket("ws://localhost:8080", "realm1", "authid", "ticket").unwrap_or_else(|e| panic!("{e}"));
    ```

    Asynchronous
    ``` rust
    use xconn::async_::client::connect_ticket;

    let session = connect_ticket("ws://localhost:8080/ws", "realm1", "authid", "ticket")
        .await
        .unwrap_or_else(|e| panic!("{e}"));
    ```

=== "Kotlin"

    ```kotlin
    import io.xconn.xconn.connectTicket


    val session = connectTicket("ws://localhost:8080/ws", "realm1", "authid", "ticket")
    ```


### Challenge Response Authentication

=== "Go"

    ``` go
    session, err := xconn.ConnectCRA(context.Background(), "ws://localhost:8080/ws", "realm1", "authid", "secret")
    if err != nil {
        log.Fatalf("Failed to connect: %v", err)
    }
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.session import Session
    from xconn.client import connect_wampcra
    
    session: Session = connect_wampcra("ws://localhost:8080/ws", "realm1", "authid", "secret")
    ```
    
    Asynchronous
    ``` python
    from xconn import run
    from xconn.async_session import AsyncSession
    from xconn.async_client import connect_wampcra
    
    async def connect():
        session: AsyncSession = await connect_wampcra("ws://localhost:8080/ws", "realm1", "authid", "secret")
    
    if __name__ == "__main__":
        run(connect())
    ```


=== "Dart"

    ``` dart
    import "package:xconn/xconn.dart";

    void main() async {
      var session = connectCRA("ws://localhost:8080/ws", "realm1", "authid", "secret");
    }
    ```

=== "Swift"

    ``` swift
    let authenticator = CRAAuthenticator(authID: "authid", secret: "secret")
    let client = Client(authenticator: authenticator)
    let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
    ```

=== "Rust"
    Synchronous

    ``` rust
    use xconn::sync::client::connect_wampcra;

    let session = connect_wampcra("ws://localhost:8080", "realm1", "authid", "secret").unwrap_or_else(|e| panic!("{e}"));
    ```

    Asynchronous
    ``` rust
    use xconn::async_::client::connect_wampcra;

    let session = connect_wampcra("ws://localhost:8080/ws", "realm1", "authid", "secret")
        .await
        .unwrap_or_else(|e| panic!("{e}"));
    ```

=== "Kotlin"

    ```kotlin
    import io.xconn.xconn.connectCRA


    val session = connectCRA("ws://localhost:8080/ws", "realm1", "authid", "secret")
    ```

### Cryptosign Authentication

=== "Go"

    ``` go
    session, err := xconn.ConnectCryptosign(context.Background(), "ws://localhost:8080/ws", "realm1", "authid", "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13")
    if err != nil {
        log.Fatalf("Failed to connect: %v", err)
    }
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.session import Session
    from xconn.client import connect_cryptosign
    
    session: Session = connect_cryptosign("ws://localhost:8080/ws", "realm1", "authid", "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13")
    ```

    Asynchronous
    ``` python
    from xconn import run
    from xconn.async_session import AsyncSession
    from xconn.async_client import connect_cryptosign
    
    async def connect():
        session: AsyncSession = await connect_cryptosign("ws://localhost:8080/ws", "realm1", "authid", "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13")
    
    if __name__ == "__main__":
        run(connect())
    ```

=== "Dart"

    ``` dart
    import "package:xconn/xconn.dart";

    void main() async {
      var session = connectCryptosign("ws://localhost:8080/ws", "realm1", "authid", "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13");
    }
    ```

=== "Swift"

    ``` swift
    let authenticator = try CryptoSignAuthenticator(authID: "authid", privateKey: "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13")
    let client = Client(authenticator: authenticator)
    let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
    ```

=== "Rust"
    Synchronous

    ``` rust
    use xconn::sync::client::connect_cryptosign;

    let session = connect_cryptosign("ws://localhost:8080", "realm1", "authid", "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13").unwrap_or_else(|e| panic!("{e}"));
    ```

    Asynchronous
    ``` rust
    use xconn::async_::client::connect_cryptosign;

    let session = connect_cryptosign("ws://localhost:8080/ws", "realm1", "authid", "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13")
        .await
        .unwrap_or_else(|e| panic!("{e}"));
    ```

=== "Kotlin"

    ```kotlin
    import io.xconn.xconn.connectCryptosign


    val session = connectCryptosign("ws://localhost:8080/ws", "realm1", "authid", "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13")
    ```


## Serializers
The library supports multiple serializers for data serialization. You can choose the one that best fits your needs. Here are a few examples

### JSON Serializer
=== "Go"

    ``` go
    client := xconn.Client{SerializerSpec: xconn.JSONSerializerSpec}
	session, err := client.Connect(context.Background(), "ws://localhost:8080/ws", "realm1")
	if err != nil {
		log.Fatalf("Failed to connect: %v", err)
	}
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.session import Session
    from xconn import Client, JSONSerializer


    client = Client(serializer=JSONSerializer())
    session: Session = client.connect("ws://localhost:8080/ws", "realm1")
    ```

    Asynchronous
    ``` python
    from xconn.async_session import AsyncSession
    from xconn import AsyncClient, JSONSerializer, run
    
    
    async def main():
        client = AsyncClient(serializer=JSONSerializer())
        session: AsyncSession = await client.connect("ws://localhost:8080/ws", "realm1")
    
    
    if __name__ == "__main__":
        run(main())
    ```

=== "Dart"

    ``` dart
    import "package:xconn/xconn.dart";

    void main() async {
      var client = Client(config: ClientConfig(serializer: JSONSerializer()));
      var session = client.connect("ws://localhost:8080/ws", "realm1");
    }
    ```

=== "Swift"

    ``` swift
    let client = Client(serializer: JSONSerializer())
    let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
    ```

=== "Rust"
    Synchronous

    ``` rust
    use wampproto::authenticators::anonymous::AnonymousAuthenticator;

    use xconn::sync::client::Client;
    use xconn::sync::types::JSONSerializerSpec;

    fn main() {
        let serializer = Box::new(JSONSerializerSpec {});
        let authenticator = Box::new(AnonymousAuthenticator::new("", Default::default()));
        let client = Client::new(serializer, authenticator);
        let session = client
            .connect("ws://localhost:8080/ws", "realm1")
            .unwrap_or_else(|e| panic!("{e}"));
    }
    ```

    Asynchronous
    ``` rust
    use wampproto::authenticators::anonymous::AnonymousAuthenticator;

    use xconn::async_::client::Client;
    use xconn::async_::types::JSONSerializerSpec;

    #[tokio::main]
    async fn main() {
        let serializer = Box::new(JSONSerializerSpec {});
        let authenticator = Box::new(AnonymousAuthenticator::new("", Default::default()));
        let client = Client::new(serializer, authenticator);
        let session = client
            .connect("ws://localhost:8080/ws", "realm1")
            .await
            .unwrap_or_else(|e| panic!("{e}"));
    }
    ```

=== "Kotlin"

    ``` kotlin
    import io.xconn.wampproto.serializers.JSONSerializer
    import io.xconn.xconn.Client


    val client = Client(serializer = JSONSerializer())
    val session = client.connect("ws://localhost:8080/ws", "realm1")
    ```

### CBOR Serializer
=== "Go"

    ``` go
    client := xconn.Client{SerializerSpec: xconn.CBORSerializerSpec}
	session, err := client.Connect(context.Background(), "ws://localhost:8080/ws", "realm1")
	if err != nil {
		log.Fatalf("Failed to connect: %v", err)
	}
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.session import Session
    from xconn import Client, CBORSerializer

    
    client = Client(serializer=CBORSerializer())
    session: Session = client.connect("ws://localhost:8080/ws", "realm1")
    ```

    Asynchronous
    ``` python
    from xconn.async_session import AsyncSession
    from xconn import AsyncClient, CBORSerializer, run
    
    
    async def main():
        client = AsyncClient(serializer=CBORSerializer())
        session: AsyncSession = await client.connect("ws://localhost:8080/ws", "realm1")
    
    
    if __name__ == "__main__":
        run(main())
    ```

=== "Dart"

    ``` dart
    import "package:xconn/xconn.dart";

    void main() async {
      var client = Client(config: ClientConfig(serializer: CBORSerializer()));
      var session = client.connect("ws://localhost:8080/ws", "realm1");
    }
    ```

=== "Swift"

    ``` swift
    let client = Client(serializer: CBORSerializer())
    let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
    ```

=== "Rust"
    Synchronous

    ``` rust
    use wampproto::authenticators::anonymous::AnonymousAuthenticator;

    use xconn::sync::client::Client;
    use xconn::sync::types::CBORSerializerSpec;

    fn main() {
        let serializer = Box::new(CBORSerializerSpec {});
        let authenticator = Box::new(AnonymousAuthenticator::new("", Default::default()));
        let client = Client::new(serializer, authenticator);
        let session = client
            .connect("ws://localhost:8080/ws", "realm1")
            .unwrap_or_else(|e| panic!("{e}"));
    }
    ```

    Asynchronous
    ``` rust
    use wampproto::authenticators::anonymous::AnonymousAuthenticator;

    use xconn::async_::client::Client;
    use xconn::async_::types::CBORSerializerSpec;

    #[tokio::main]
    async fn main() {
        let serializer = Box::new(CBORSerializerSpec {});
        let authenticator = Box::new(AnonymousAuthenticator::new("", Default::default()));
        let client = Client::new(serializer, authenticator);
        let session = client
            .connect("ws://localhost:8080/ws", "realm1")
            .await
            .unwrap_or_else(|e| panic!("{e}"));
    }
    ```

=== "Kotlin"

    ``` kotlin
    import io.xconn.wampproto.serializers.CBORSerializer
    import io.xconn.xconn.Client


    val client = Client(serializer = CBORSerializer())
    val session = client.connect("ws://localhost:8080/ws", "realm1")
    ```

### MsgPack Serializer
=== "Go"

    ``` go
    client := xconn.Client{SerializerSpec: xconn.MsgPackSerializerSpec}
	session, err := client.Connect(context.Background(), "ws://localhost:8080", "realm1")
	if err != nil {
		log.Fatalf("Failed to connect: %v", err)
	}
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.session import Session
    from xconn import Client, MsgPackSerializer

    
    client = Client(serializer=MsgPackSerializer())
    session: Session = client.connect("ws://localhost:8080/ws", "realm1")
    ```

    Asynchronous
    ``` python
    from xconn.async_session import AsyncSession
    from xconn import AsyncClient, MsgPackSerializer, run
    
    
    async def main():
        client = AsyncClient(serializer=MsgPackSerializer())
        session: AsyncSession = await client.connect("ws://localhost:8080/ws", "realm1")
    
    
    if __name__ == "__main__":
        run(main())
    ```

=== "Dart"

    ``` dart
    import "package:xconn/xconn.dart";

    void main() async {
      var client = Client(config: ClientConfig(serializer: MsgPackSerializer()));
      var session = client.connect("ws://localhost:8080/ws", "realm1");
    }
    ```

=== "Swift"

    ``` swift
    let client = Client(serializer: MsgPackSerializer())
    let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
    ```

=== "Rust"
    Synchronous

    ``` rust
    use wampproto::authenticators::anonymous::AnonymousAuthenticator;

    use xconn::sync::client::Client;
    use xconn::sync::types::MsgPackSerializerSpec;

    fn main() {
        let serializer = Box::new(MsgPackSerializerSpec {});
        let authenticator = Box::new(AnonymousAuthenticator::new("", Default::default()));
        let client = Client::new(serializer, authenticator);
        let session = client
            .connect("ws://localhost:8080/ws", "realm1")
            .unwrap_or_else(|e| panic!("{e}"));
    }
    ```

    Asynchronous
    ``` rust
    use wampproto::authenticators::anonymous::AnonymousAuthenticator;

    use xconn::async_::client::Client;
    use xconn::async_::types::MsgPackSerializerSpec;

    #[tokio::main]
    async fn main() {
        let serializer = Box::new(MsgPackSerializerSpec {});
        let authenticator = Box::new(AnonymousAuthenticator::new("", Default::default()));
        let client = Client::new(serializer, authenticator);
        let session = client
            .connect("ws://localhost:8080/ws", "realm1")
            .await
            .unwrap_or_else(|e| panic!("{e}"));
    }
    ```

=== "Kotlin"

    ``` kotlin
    import io.xconn.wampproto.serializers.MsgPackSerializer
    import io.xconn.xconn.Client


    val client = Client(serializer = MsgPackSerializer())
    val session = client.connect("ws://localhost:8080/ws", "realm1")
    ```

### Cap'n Proto Serializer
=== "Go"

    ``` go
    client := xconn.Client{SerializerSpec: xconn.CapnprotoSplitSerializerSpec}
	session, err := client.Connect(context.Background(), "ws://localhost:8080", "realm1")
	if err != nil {
		log.Fatalf("Failed to connect: %v", err)
	}
    ```

=== "Python"
    Synchronous

    ``` python
    from xconn.session import Session
    from xconn import Client, CapnProtoSerializer

    
    client = Client(serializer=CapnProtoSerializer())
    session: Session = client.connect("ws://localhost:8080/ws", "realm1")
    ```

    Asynchronous
    ``` python
    from xconn.async_session import AsyncSession
    from xconn import AsyncClient, CapnProtoSerializer, run
    
    
    async def main():
        client = AsyncClient(serializer=CapnProtoSerializer())
        session: AsyncSession = await client.connect("ws://localhost:8080/ws", "realm1")
    
    
    if __name__ == "__main__":
        run(main())
    ```
