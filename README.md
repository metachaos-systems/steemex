# Steemex

Elixir websocket client for Steemd. Provides an interface to Steem JSONRPC protocol.

Currently in development.

## Installation

  1. Add `steemex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:steemex, "~> 0.1.0"}]
    end
    ```

  2. Run `mix deps.get`

## Example

First, add preferred WS url in the config.

```elixir
config :steemex,
  url: "STEEM_URL"
```

Then, launch iex

```elixir
# Start Steemex WS server process which is registered with name Steemex.WS
Steemex.start_link( self() )
# Steemex.call returns id of your JSONRPC call if you need to track it
id = Steemex.call(Steemex.WS, ["database_api", "get_dynamic_global_properties", []])
# flush the mailbox to log incoming message to iex
flush
```

## Roadmap

* Supervisor and option for a developer to provide handler process in the config
* Utility functions
* Add types and structs
* More tests and docs
