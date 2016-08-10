defmodule Steemex do
  use Application

  def start_link do
    import Supervisor.Spec, warn: false
    handler = Application.get_env(:steemex, :handler)
    {:ok, handler_pid} = handler.start_link
    children = [
      handler_pid,
      worker(Steemex.IdAgent, [])
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
