# Use for JavaScript

A TypeScript WAMP client library built for both browser and Node.js environments.

## Prerequisites
Before creating or running a client, you must have a WAMP router running. The client needs to connect to a router to send and receive messages, so this step is essential.

We recommend using a [Nxt](https://xconn.dev/nxt/) router, a lightweight and high-performance WAMP router built for flexibility and speed.

## Installation

To install `xconn`, add the following to your `package.json` file:

```typescript
"dependencies": {
    "xconn": "github:xconnio/xconn-ts#13fbafb2c8e1e30a1cf13803fd207f5705270e24"
}
```

## Client

Creating a client:

```typescript
import {connectAnonymous} from "xconn";


async function main() {
    const session = await connectAnonymous("ws://localhost:8080/ws", "realm1");
}
```

Once the session is established, you can perform WAMP actions. Below are examples of all 4 WAMP operations:

### Subscribe to a topic

```typescript
import {Event, Session} from "xconn";


async function exampleSubscribe(session: Session) {
    const onEvent = (event: Event) => {
        console.log(`Received Event: args=${event.args}, kwargs=${event.kwargs}, details=${event.details}`);
    };

    await session.subscribe("io.xconn.example", onEvent);
}
```

### Publish to a topic

```typescript
import {Session} from "xconn";


async function examplePublish(session: Session) {
    await session.publish("io.xconn.example", {args: ["test"], kwargs: {"key": "value"}});
}
```

### Register a procedure

```typescript
import {Session, Invocation, Result} from "xconn";


async function exampleRegister(session: Session) {
    const onEcho = (invocation: Invocation): Result => {
        return new Result(invocation.args, invocation.kwargs, invocation.details);
    };

    await session.register("io.xconn.echo", onEcho);
}
```

### Call a procedure

```typescript
import {Session} from "xconn";


async function exampleCall(session: Session) {
    await session.call("io.xconn.echo", {args: [1, 2], kwargs: {"key": "value"}});
}
```

## Authentication

Authentication is straightforward. Simply create the desired authenticator and pass it to the client.

### Ticket Auth

```typescript
import {connectTicket} from "xconn";


const session = await connectTicket("ws://localhost:8080/ws", "realm1", "authid", "ticket");
```

### Challenge Response Auth

```typescript
import {connectCRA} from "xconn";


const session = await connectCRA("ws://localhost:8080/ws", "realm1", "authid", "secret");
```

### Cryptosign Auth

```typescript
import {connectCryptosign} from "xconn";


const session = await connectCryptosign("ws://localhost:8080/ws", "realm1", "authid", "150085398329d255ad69e82bf47ced397bcec5b8fbeecd28a80edbbd85b49081");
```

For more detailed examples or usage, refer to the [examples](https://github.com/xconnio/xconn-typescript/tree/main/examples) folder of the project.
