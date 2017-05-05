# Steemex

Elixir websockets client for Steem JSONRPC interface. Steemex is a supervised application, so don't forget to add it to applications in mix.exs

## Installation

  1. Add `steemex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        {:steemex, ">= 0.0.0"}
      ]
    end
    ```

  2. Add 'steemex' to applications in `mix.exs`:
    ```elixir
    def application do
      [applications: [:logger, :steemex]]
    end
    ```

## Configuration

First, configure a websockets url for the steemd instance, for example, a public node `wss://steemd.steemit.com/` to the config.

```elixir
config :steemex,
  url: System.get_env("STEEM_URL"),
```

Steemex module includes structs for all operations types. Streamer module parses each operation and converts it to a corresponding struct.

# JSONRPC API

The main module function is `Steemex.call`. It will block the calling process and return a success tuple with a "result" data from the JSONRPC call response. JSONRPC call ids are handled automatically.

# Documentation

All database api functions have docs, typespecs and example API responses. Most example responses are from the Golos blockchain, their shape is identical to Steem counterparts.

# GenStage

ExGolos uses GenStage, [a new specification](http://elixir-lang.org/blog/2016/07/14/announcing-genstage/) for handling and exchanging events among Elixir/Erlang processes.

On module app startup two GenStage processes are started and registered:

* Golos.Stage.Blocks.Producer which, perhaps unsurprisingly, is a new blocks producer
* Golos.Stage.Ops.ProducerConsumer consumes blocks and produces operations


## An example of GenStage consumer to handle stream of new operations

```
defmodule Steemex.Stage.Ops.ExampleConsumer do
  use GenStage
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    {:consumer, state, subscribe_to: state.subscribe_to}
  end

  def handle_events(events, _from, state) do
    for op <- events do
      Logger.info """
      New operation:
      #{inspect op}
      """
    end
    {:noreply, [], state}
  end

end
```

## Roadmap

Steemex is under active development.

* ~~Investigate using GenStage~~
* Add more utility functions
* Add more types and structs
* Add transaction broadcasting
