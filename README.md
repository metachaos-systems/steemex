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

All database api functions have docs, typespecs and example API responses.

# GenStage

Steemex uses GenStage, [a new specification](http://elixir-lang.org/blog/2016/07/14/announcing-genstage/) for handling and exchanging events among Elixir/Erlang processes.

On module app startup two GenStage processes are started and registered:

* Steemex.Stage.Blocks.Producer which, perhaps unsurprisingly, is a new blocks producer
* Steemex.Stage.RawOps produces raw blockchain operations
* Steemex.Stage.MungedOps produces parsed, cleaned and transformed operations


## An example of GenStage consumer to handle stream of new operations

```
defmodule Steemex.Stage.ExampleConsumer do
  use GenStage
  alias Steemex.MungedOps
  require Logger

  def start_link(args, options \\ []) do
    GenStage.start_link(__MODULE__, args, options)
  end

  def init(state) do
    Logger.info("Example consumer is initializing...")
    {:consumer, state, subscribe_to: state[:subscribe_to]}
  end

  def handle_events(events, _from, state) do
    for op <- events do
      process_event(op)
    end
    {:noreply, [], state}
  end

  def process_event(%{data: %MungedOps.Reblog{} = data, metadata: %{height: h, timestamp: t} = metadata}) do
      Logger.info """
      New reblog:
      #{inspect data}
      with metadata
      #{inspect metadata}
      """
  end

  def process_event(%{data: data, metadata: %{block_height: h, timestamp: t} = metadata}) do
      Logger.info """
      New operation:
      #{inspect data}
      with metadata
      #{inspect metadata}
      """
  end

end
```

## Roadmap

Steemex is under active development.

* Add more utility functions
* Add more types and structs
* Add transaction broadcasting
