# Steemex

Elixir websocket client for Steemd. Provides an interface to Steem JSONRPC protocol.

Currently in development

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `steemex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:steemex, "~> 0.1.0"}]
    end
    ```

## Example

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
* Add more types and structs
* More tests and docs
