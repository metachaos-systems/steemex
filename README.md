# Steemex

Elixir websockets client for steemd. Provides an interface to Steem JSONRPC protocol. Steemex is now a supervised application with two workers and a configurable handler for responses to JSONRPC calls.  

Steemex is under active development.

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

Example of SteemexHandlerModule. Why GenServer? Any advanced aggregation or analysis of blockchain data requires
at least some state management.

```elixir
defmodule SteemexHandler do
  use GenServer
  require Logger

  def start_link(_params \\ []) do
    GenServer.start_link(__MODULE__, [])
  end

  def handle_cast({["database_api", "get_dynamic_global_properties", []], data}, _) do
    Logger.debug inspect(data)
    {:noreply, []}
  end

  def handle_cast({msg_name, _}, _) do
    Logger.debug("No known handler function for this message #{msg_name}")
    {:noreply, []}
  end

end
```

## Roadmap

* ~~Supervisor and option for a developer to provide handler process in the config~~
* Utility functions
* Add types and structs
* More tests and docs
