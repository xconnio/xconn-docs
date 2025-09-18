# Nxt Router

A next-generation WAMP router for modern real-time apps.

## Installation

### Install from snap

```shell
sudo snap install nxt-router --edge
```

### Build from source

```shell
git clone git@github.com:xconnio/nxt
cd nxt
go build ./cmd/nxt
```

## Usage

### Initialize

First, we have to initialize the config file.
```shell
nxt init
```

This creates a config file at `.nxt/config.yaml`

### Start Router

```shell
nxt start
```
That should show below logs:

```shell
$ nxt start
listening websocket on ws://localhost:8080
listening rawsocket on rs:///tmp/nxt.sock
```

This starts two instances of router:  

1. Websocket Transport which listens at: `ws://localhost:8080`
2. Rawsocket Transport which listens at: `rs:///tmp/nxt.sock`

Now just write a component in any programming langauge that has a WAMP client.
