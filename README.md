# Steemex

Elixir websockets client for steemd. Provides an interface to Steem JSONRPC protocol. Steemex is a supervised application, so don't forget to add it to applications in mix.exs

## Installation

  1. Add `steemex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:steemex, "~> 0.8.0"}]
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


## Roadmap

Steemex is under active development.

* Implement subscriptions
* Investigate using GenStage
* Add more utility functions
* Add more types and structs
* Add transaction broadcast
