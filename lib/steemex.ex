defmodule Steemex do
  alias Poison, as: JSON
  @temp_steem_wss 'wss://steemit.com/wstmp3'
  @doc """
  Starts the WebSocket server for given ws URL. Received Socket.Message's
  are forwarded to the sender pid
  """
  def start_link(sender) do
    :crypto.start
    :ssl.start
    :websocket_client.start_link(@temp_steem_wss, __MODULE__, [sender])
  end

  def init([sender], _conn_state \\ []) do
    {:once, %{sender: sender, id: 0}}
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
    send state.sender, JSON.decode!(msg, opcode: :text)
    {:ok, state}
  end

  @doc """
  Sends JSON encoded message to remote WS endpoint
  """
  def websocket_info({:send, msg}, _conn_state, state) do
    # msg = Map.put(msg, :id, to_string(state.id + 1))
    {:reply, {:text, json!(msg)}, state}
  end

  def websocket_info(:close, _conn_state, _state) do
    {:close, <<>>, "done"}
  end

  def websocket_terminate(_reason, _conn_state, _state) do
    :ok
  end

  @doc """
  Sends an event to the WebSocket server per the Message protocol
  """
  def send_event(server_pid, msg) do
    send server_pid, {:send, msg}
  end

  defp json!(map), do: JSON.encode!(map)
end
