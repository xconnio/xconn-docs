# Use for Go

WAMP v2 Router and Client for go.

## Prerequisites
Before creating or running a client, you must have a WAMP router running. The client needs to connect to a router to send and receive messages, so this step is essential.

We recommend using a [Nxt](https://xconn.dev/nxt/) router, a lightweight and high-performance WAMP router built for flexibility and speed.

## Installation

To install `xconn`, use the following command:

```shell
go get github.com/xconnio/xconn-go
```

## Client

Creating a client:

```go
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

Once the session is established, you can perform WAMP actions. Below are examples of all 4 WAMP
operations:

### Subscribe to a topic

```go
func exampleSubscribe(session *xconn.Session) {
    subscribeResponse := session.Subscribe("io.xconn.example", eventHandler).Do()
    if subscribeResponse.Err != nil {
        log.Fatalf("Failed to subscribe: %v", subscribeResponse.Err)
    }
}

func eventHandler(evt *xconn.Event) {
    fmt.Printf("Event Received: args=%s, kwargs=%s, details=%s", evt.Args, evt.Kwargs, evt.Details)
}
```

### Publish to a topic

```go
func examplePublish(session *xconn.Session) {
    publishResponse := session.Publish("io.xconn.example").Arg("test").Do()
    if publishResponse.Err != nil {
        log.Fatalf("Failed to publish: %v", publishResponse.Err)
    }
}
```

### Register a procedure

```go
func exampleRegister(session *xconn.Session) {
    registerResponse := session.Register("io.xconn.example", invocationHandler).Do()
    if registerResponse.Err != nil {
        log.Fatalf("Failed to register: %v", registerResponse.Err)
    }
}

func invocationHandler(ctx context.Context, inv *xconn.Invocation) *xconn.InvocationResult {
    return xconn.NewInvocationResult()
}
```

### Call a procedure

```go
func exampleCall(session *xconn.Session) {
    callResponse := session.Call("io.xconn.example").Arg("Hello World!").Do()
    if callResponse.Err != nil {
        log.Fatalf("Failed to call: %v", callResponse.Err)
    }
}
```

### Authentication

Authentication is straightforward. Simply create the desired authenticator and pass it
to the Client.

#### Ticket Auth

```go
session, err := xconn.ConnectTicket(context.Background(), "ws://localhost:8080/ws", "realm1", "authID", "ticket")
if err != nil {
    log.Fatalf("Failed to connect: %v", err)
}
```

#### Challenge Response Auth

```go
session, err := xconn.ConnectCRA(context.Background(), "ws://localhost:8080/ws", "realm1", "authID", "secret")
if err != nil {
	log.Fatalf("Failed to connect: %v", err)
}
```

#### Cryptosign Auth

```go
session, err := xconn.ConnectCryptosign(context.Background(), "ws://localhost:8080/ws", "realm1", "authID", "privateKey")
if err != nil {
    log.Fatalf("Failed to connect: %v", err)
}
```

For more detailed examples or usage, refer to the [examples](https://github.com/xconnio/xconn-go/tree/main/examples) folder of the project.
