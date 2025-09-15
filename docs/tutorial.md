# Tutorial

This tutorial demonstrates how to use XConn across multiple programming languages.

## Installation

=== "Go"

    ``` go
    go get github.com/xconnio/xconn-go
    ```

=== "Python"

    ``` python
    om26er@Home-PC:~$ uv venv
    om26er@Home-PC:~$ uv pip install xconn
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
