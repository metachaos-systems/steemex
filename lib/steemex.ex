defmodule Steemex do
  alias Poison, as: JSON
  @doc """
  Starts the WebSocket server for given ws URL. Received messages
  are forwarded to the sender pid
  """
  def start_link(sender) do
    :crypto.start
    :ssl.start
    steem_wss = Application.get_env(:steemex, :url) |> String.to_charlist
    {:ok, sock_pid} = :websocket_client.start_link(steem_wss, __MODULE__, [sender] )
    # websocket_client doesn't pass options to the gen_server, so registering manually
    Process.register(sock_pid, Steemex.WS)
    {:ok, Steemex.WS}
  end

  def init([sender], _conn_state \\ []) do
    {:once, %{sender: sender}}
  end

  def onconnect(_ws_req, state) do
    {:ok, state}
  end

  def ondisconnect({:remote, :closed}, state) do
    {:reconnect, state}
  end

  def call(sock_pid, params) do
     id = round(:rand.uniform * 1.0e16)
     send_event sock_pid, %{jsonrpc: "2.0", params: params, id: id, method: "call"}
     id
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
    send state.sender, JSON.decode!(msg)
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

  @doc """
  Sends an event to the WebSocket server
  """
  def send_event(server_pid, msg) do
    send server_pid, {:send, msg}
  end

  defp json!(map), do: JSON.encode!(map)
end
