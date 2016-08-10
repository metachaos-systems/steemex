defmodule Steemex do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Steemex.IdAgent, []),
      worker(Steemex.WS, [])
    ]
    opts = [strategy: :one_for_one, name: CyberpunkVentures.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def call(params) do
     id = round(:rand.uniform * 1.0e16)
     Steemex.IdAgent.put(id, params)
     send_event Steemex.WS, %{jsonrpc: "2.0", params: params, id: id, method: "call"}
  end

  @doc """
  Sends an event to the WebSocket server
  """
  def send_event(server_pid, msg) do
    send server_pid, {:send, msg}
  end

end
