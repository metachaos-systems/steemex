defmodule Steemex.WS do
  alias Poison, as: JSON
  @moduledoc """
  Starts the WebSocket server for given ws URL. Received messages
  are forwarded to the sender pid
  """

  def start_link(handler_pid \\ nil) do
    :crypto.start
    :ssl.start

    configured_handler = Application.get_env(:steemex, :handler)
    url = Application.get_env(:steemex, :url)

    unless configured_handler, do: throw("Steemex Handler module is NOT configured.")
    unless url, do: throw("Steemex WS url is NOT configured.")

    {:ok, handler_pid} = if handler_pid do
       {:ok, handler_pid}
     else
        @configured_handler.start_link
    end

    Process.register(handler_pid, Steemex.Handler)

    steem_wss = String.to_charlist(@url)

    {:ok, sock_pid} = :websocket_client.start_link(steem_wss, __MODULE__, [])
    # websocket_client doesn't pass options to the gen_server, so registering manually
    Process.register(sock_pid, Steemex.WS)
    {:ok, sock_pid}
  end


  def init([], _conn_state \\ []) do
    {:once, %{}}
  end

  def onconnect(_ws_req, state) do
    {:ok, state}
  end

  def ondisconnect({:remote, :closed}, state) do
    {:reconnect, state}
  end

  @doc """
  Closes the socket
  """
  def close(socket) do
    send(socket, :close)
  end

  @doc """
  Receives JSON encoded message from remote WS endpoint and
  forwards message to client sender process
  """
  def websocket_handle({:text, msg}, _conn_state, state) do
    data = JSON.decode!(msg)
    id = data["id"]
    params = Steemex.IdAgent.get(id)
    GenServer.cast(Steemex.Handler, {params, data})
    {:ok, state}
  end

  @doc """
  Sends JSON encoded message to remote WS endpoint
  """
  def websocket_info({:send, msg}, _conn_state, state) do
    {:reply, {:text, json!(msg)}, state}
  end

  def websocket_info(:close, _conn_state, _state) do
    {:close, <<>>, "done"}
  end

  def websocket_terminate(_reason, _conn_state, _state) do
    :ok
  end

  defp json!(map), do: JSON.encode!(map)
end
