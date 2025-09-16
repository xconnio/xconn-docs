# Use for Rust

WAMP client in Rust.

## Installation

To install `xconn-rust`, add the following to your `Cargo.toml` file:

```rust
[dependencies]
xconn = { git = "https://github.com/xconnio/xconn-rust", branch = "main" }
```

## Client

This library includes two implementations one is sync and the other async.

### Sync Client

```rust
use xconn::sync::client::connect_anonymous;

fn main() {
    let session = connect_anonymous("ws://localhost:8080", "realm1").unwrap_or_else(|e| panic!("{e}"));
}
```

Once the session is established, you can perform WAMP actions. Below are examples of all 4 WAMP operations:

#### Subscribe to a topic
```rust
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

#### Publish to a topic
```rust
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

#### Register a procedure
```rust
use xconn::sync::session::Session;
use xconn::sync::types::{Invocation, RegisterRequest, Yield};

fn example_register(session: Session){
    let register_request = RegisterRequest::new("io.xconn.echo", invocation_handler);
    match session.register(register_request) {
        Ok(response) => println!("{response:?}"),
        Err(e) => println!("{e}"),
    }
}

fn invocation_handler(inv: Invocation) -> Yield {
    println!(
        "Received args={:?}, kwargs={:?}, details={:?}",
        inv.args, inv.kwargs, inv.details
    );
    Yield::new(inv.args, inv.kwargs)
}
```

#### Call a procedure
```rust
use xconn::sync::session::Session;
use xconn::sync::types::CallRequest;

fn example_call(session: Session) {
    let call_request = CallRequest::new("io.xconn.echo").arg(1).arg(2).kwarg("key", "value");
    let response = session.call(call_request).unwrap();
    println!("Received: args={:?}, kwargs={:?}", response.args, response.kwargs);
}
```

#### Authentication
Authentication is straightforward.

##### Ticket Auth
```rust
use xconn::sync::client::connect_ticket;

let session = connect_ticket("ws://localhost:8080", "realm1", "authid", "ticket").unwrap_or_else(|e| panic!("{e}"));
```

##### Challenge Response Auth
```rust
use xconn::sync::client::connect_wampcra;

let session = connect_wampcra("ws://localhost:8080", "realm1", "authid", "secret").unwrap_or_else(|e| panic!("{e}"));
```

##### Cryptosign Auth
```rust
use xconn::sync::client::connect_cryptosign;

let session = connect_cryptosign("ws://localhost:8080", "realm1", "authid", "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13").unwrap_or_else(|e| panic!("{e}"));
```

### Async Client
```rust
use xconn::async_::client::connect_anonymous;

#[tokio::main]
async fn main() {
    let session = connect_anonymous("ws://localhost:8080/ws", "realm1")
        .await
        .unwrap_or_else(|e| panic!("{e}"));
}
```
Once the session is established, you can perform WAMP actions. Below are examples of all 4 WAMP
operations:

#### Subscribe to a topic
```rust
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

#### Publish to a topic
```rust
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

#### Register a procedure
```rust
use xconn::async_::session::Session;
use xconn::async_::types::{Invocation, RegisterRequest, Yield};

async fn example_register(session: Session) {
    let register_request = RegisterRequest::new("io.xconn.echo", invocation_handler);
    match session.register(register_request).await {
        Ok(response) => println!("{response:?}"),
        Err(e) => println!("{e}"),
    }
}

async fn invocation_handler(invocation: Invocation) -> Yield {
        println!(
            "Received args={:?}, kwargs={:?}, details={:?}",
            invocation.args, invocation.kwargs, invocation.details
        );
    Yield::new(invocation.args, invocation.kwargs)
}
```

#### Call a procedure
```rust
use xconn::async_::session::Session;
use xconn::async_::types::CallRequest;

async fn example_call(session: Session) {
    let call_request = CallRequest::new("io.xconn.example").arg(1).arg(2).kwarg("key", "value");

    let response = session.call(call_request).await.unwrap();
    println!("Received: args={:?}, kwargs={:?}", response.args, response.kwargs);
}
```

#### Authentication
Authentication is straightforward.

##### Ticket Auth
```rust
use xconn::async_::client::connect_ticket;

let session = connect_ticket("ws://localhost:8080/ws", "realm1", "authid", "ticket")
    .await
    .unwrap_or_else(|e| panic!("{e}"));
```

##### Challenge Response Auth
```rust
use xconn::async_::client::connect_wampcra;

let session = connect_wampcra("ws://localhost:8080/ws", "realm1", "authid", "secret")
    .await
    .unwrap_or_else(|e| panic!("{e}"));
```

##### Cryptosign Auth
```rust
use xconn::async_::client::connect_cryptosign;

let session = connect_cryptosign("ws://localhost:8080/ws", "realm1", "authid", "d850fff4ff199875c01d3e652e7205309dba2f053ae813c3d277609150adff13")
    .await
    .unwrap_or_else(|e| panic!("{e}"));
```

look at examples directory for more [examples](https://github.com/xconnio/xconn-rust/tree/main/examples)
