# Use for Swift

WAMP v2 Client for Swift with async/await support for iOS and macOS.

## Prerequisites
Before creating or running a client, you must have a WAMP router running. The client needs to connect to a router to send and receive messages, so this step is essential.

We recommend using the [NXT](https://xconn.dev/nxt/) router, a lightweight and high-performance WAMP router built for flexibility and speed.

## Installation

To install `xconn-swift`, add the following to your `Package.swift` file:

```swift
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

## Client

Creating a client:

```swift
import XConn

let client = Client()
let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
```

Once the session is established, you can perform WAMP actions. Below are examples of all 4 WAMP operations:

### Subscribe to a topic

```swift
func exampleSubscribe(_ session: Session) {
    try await session.subscribe(topic: "io.xconn.example", endpoint: eventHandler)
}

func eventHandler(_ event: Event) {
    print("Event received: args=\(event.args), kwargs=\(event.kwargs), details=\(event.details)")
}
```

### Publish to a topic

```swift
func examplePublish(_ session: Session) {
    try await session.publish(
        topic: "io.xconn.example",
        args: ["test"],
        kwargs: ["key": "value"],
    )
}
```

### Register a procedure

```swift
func exampleRegister(_ session: Session) {
    try await session.register(procedure: "io.xconn.example", endpoint: echoHandler)
}

func echoHandler(_ invocation: Invocation) -> Result {
    return Result(args: invocation.args, kwargs: invocation.kwargs)
}
```

### Call a procedure

```swift
func exampleCall(_ session: Session) {
    let result = try await session.call(
        procedure: "io.xconn.echo",
        args: ["Hello World!"],
        kwargs: ["key": "value"]
    )    
}
```

## Authentication

Authentication is straightforward. Simply create the desired authenticator and pass it to the client.

### Ticket Auth

```swift
let authenticator = TicketAuthenticator(authID: "authid", ticket: "ticket")
let client = Client(authenticator: authenticator)
let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
```

### Challenge Response Auth

```swift
let authenticator = CRAAuthenticator(authID: "authid", secret: "secret")
let client = Client(authenticator: authenticator)
let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
```

### Cryptosign Auth

```swift
let authenticator = try CryptoSignAuthenticator(authID: "authid", privateKey: "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13")
let client = Client(authenticator: authenticator)
let session = try await client.connect(uri: "ws://localhost:8080/ws", realm: "realm1")
```

For more detailed examples or usage, refer to the [examples](https://github.com/xconnio/xconn-swift/tree/main/examples) folder of the project.
