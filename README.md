# Steemex

Elixir websockets client for steemd. Provides an interface to Steem JSONRPC protocol. Steemex is a supervised application, so don't forget to add it to applications in mix.exs

## Installation

  1. Add `steemex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:steemex, "~> 0.9.0"}]
    end
    ```

  2. Add 'steemex' to applications in `mix.exs`:
    ```elixir
    def application do
      [applications: [:logger, :steemex]]
    end
    ```

## Configuration

First, configure a websockets url for the steemd instance, for example, a public node `wss://steemd.steemit.com/` to the config. If you'd like to use a Streamer module, add a `stream_to` option.

```elixir
config :steemex,
  url: System.get_env("STEEM_URL"),
  stream_to: YourOpHandlerModule
```

Warning: `Steemex.Streamer` GenServer is started by the Steemex app if `stream_to` key is present in the config. Name of the `YourOpHandlerModule` GenServer module should be registered and the streaming recipient process should be alive.

Alternatively, you can launch streamer module manually, like this: `Steemex.Streamer.start_link(%{stream_to: YourOpHandlerModule})`

Steemex module contains structs for all operations types. Streamer module parses each operation and converts it to a correspondning. struct.

# JSONRPC API

The most imporant module function is `Steemex.call`. It will block the calling process and return a success tuple with a "result" data from the JSONRPC call response. JSONRPC call ids are handled automatically.

# Documentation

All database api functions have docs, typespecs and example API responses. Most example responses are from the Golos blockchain, their shape is identical to Steem counterparts.

# Example of an operation stream handler module

```
defmodule Steemex.OpsHandlerExample do
  use GenServer
  require Logger

  @doc"""
  Starts the handler module
  """
  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(config \\ %{}) do
    {:ok, config}
  end

  def handle_info({:comment, data}, state) do
    Logger.info("New post or comment:  #{inspect(data)}" )
    {:noreply, state}
  end

  def handle_info({:vote, data}, state) do
    Logger.info("New vote:  #{inspect(data)}" )
    {:noreply, state}
  end


  def handle_info({op_type, op_data}, state) do
    Logger.info("Новая операция #{op_type}:  #{inspect(op_data)}" )
    {:noreply, state}
  end


end
```

## Roadmap

Steemex is under active development.

* Implement subscriptions
* Investigate using GenStage
* Add more utility functions
* Add more types and structs
* Add transaction broadcast
