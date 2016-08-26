# Steemex

Elixir websockets client for steemd. Provides an interface to Steem JSONRPC protocol. Steemex is a supervised application with two workers and a configurable handler for handling responses to JSONRPC calls response.  

Steemex is under active development. In the next versions I'll be adding `Steemex.call_sync` and `Steemex.get_content_sync` functions
that block the calling process until jsonrpc call response is available.

## Installation

  1. Add `steemex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:steemex, "~> 0.1.0"}]
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
Then, provide a handler module in the config file.

```elixir
config :steemex,
  url: "STEEM_URL",
  handler: SteemexHandlerModule
```

Example of SteemexHandlerModule. You need a handler module with a `handle_jsonrpc_call` callback. GenServer handler implementation is recommended as any advanced aggregation or analysis of blockchain data requires some state management.

```elixir
defmodule Steemex.Handler do
  use GenServer
  require Logger

  # API
  def start_link(_params \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_jsonrpc_call(id, call_params, data) do
    Logger.debug "Received jsonrpc call response"
    GenServer.cast(__MODULE__, {id, call_params, data} )
  end

  # SERVER
  def handle_cast({id, ["database_api", "get_dynamic_global_properties", []], data}, _) do
    Logger.debug inspect(data)
    {:noreply, []}
  end

  def handle_cast({id, ["database_api", "get_state", params], data}, _) do
    Logger.debug inspect(data)
    {:noreply, []}
  end

  def handle_cast({id, msg, data}, _) do
    Logger.debug("No known handler function for this message")
    Logger.debug inspect(msg)
    {:noreply, []}
  end

end
```

## Roadmap

* More utility functions
* JSONRPC calls that block a caller process and return response
* Investigate using GenStage
* Add types and structs
* More tests and docs
