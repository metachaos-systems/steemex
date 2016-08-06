# Steemex

Elixir websockets client for steemd. Provides an interface to Steem JSONRPC protocol. Currently under development.

## Installation

  1. Add `steemex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:steemex, "~> 0.1.0"}]
    end
    ```

  2. Run `mix deps.get`

## Example

First, add a websockets url for the steemd instance, for example, `http://127.0.0.1:8090` to the config.

```elixir
config :steemex,
  url: "STEEM_URL"
```

Then, launch iex

```elixir
# Start Steemex server process which has a locally registered name Steemex.WS
Steemex.start_link( self() )
# Steemex.call returns id of your JSONRPC call if you need to reference it in the future
id = Steemex.call(Steemex.WS, ["database_api", "get_dynamic_global_properties", []])
# flush the process mailbox to log incoming message(es)
flush
```

## Roadmap

* Supervisor and option for a developer to provide handler process in the config
* Utility functions
* Add types and structs
* More tests and docs
