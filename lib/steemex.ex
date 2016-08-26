defmodule Steemex do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    handler_mod = Application.get_env(:steemex, :handler)
    url = Application.get_env(:steemex, :url)

    unless is_function(&handler_mod.handle_jsonrpc_call/3), do: throw("Handler module handle_jsonrpc_call is NOT a function")
    unless handler_mod, do: throw("Steemex Handler module is NOT configured.")
    unless url, do: throw("Steemex WS url is NOT configured.")

    children = [
      worker(Steemex.IdAgent, []),
      worker(Steemex.WS, [&handler_mod.handle_jsonrpc_call/3, url])
    ]
    opts = [strategy: :one_for_one, name: Steemex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def call(params) do
     id = round(:rand.uniform * 1.0e16)
     Steemex.IdAgent.put(id, params)
     send_event Steemex.WS, %{jsonrpc: "2.0", params: params, id: id, method: "call"}
  end

  def call_sync(params) do
    # implementation for blocking call goes here, most probably simply by using receive
  end

  def get_block(height) do
    Steemex.call ["database_api", "get_block", [height]]
  end

  def get_content(author, permlink) do
    Steemex.call ["database_api", "get_content", [author, permlink]]
  end
  @doc """
  Sends an event to the WebSocket server
  """
  def send_event(server_pid, msg) do
    send server_pid, {:send, msg}
  end

end
