# Steemex

Elixir websockets client for steemd. Provides an interface to Steem JSONRPC protocol. Steemex is a supervised application, so don't forget to add it to applications in mix.exs

## Installation

  1. Add `steemex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:steemex, "~> 0.6.0"}]
    end
    ```

  2. Add 'steemex' to applications in `mix.exs`:
    ```elixir
    def application do
      [applications: [:logger, :steemex]]
    end
    ```

## Example

First, configure a websockets url for the steemd instance, for example, `http://127.0.0.1:8090` to the config.

```elixir
config :steemex,
  url: "STEEM_URL"
```

The most imporant module function is `Steemex.call`. It will block the calling process and return a success tuple with a "result" data from the JSONRPC call response. JSONRPC call ids are handled automatically.

You can use a handler for async responses to JSONRPC calls by using `Steemex.call(params, stream_to: HandlerMod)`.  It returns JSONRPC call id and will send the msg to your handler module.

```elixir
defmodule Steemex.HandlerExample do
  use GenServer
  require Logger

  # API
  def start_link(_params \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # SERVER
  def handle_info({:ws_response, {id, ["database_api", "get_dynamic_global_properties", []], data}}, _) do
    Logger.debug inspect(data)
    {:noreply, []}
  end

  def handle_info({:ws_response, {id, ["database_api", "get_state", params], data}}, _) do
    Logger.debug inspect(data)
    {:noreply, []}
  end

  def handle_info({:ws_response, {id, msg, data}}, _) do
    Logger.debug("No known handler function for this message")
    Logger.debug inspect(msg)
    {:noreply, []}
  end

end
```

## Roadmap

Steemex is under active development.

* Investigate using GenStage
* Add more utility functions
* Add more types and structs
* Add more tests and docs
* Add transaction broadcast
