defmodule Steemex do

  def start_link do
    :crypto.start()
    :ssl.start()
    :websocket_client.start_link('wss://steemit.com/wstmp3', __MODULE__, name: Steemex)
  end

  def init(params) do
    {:once, []}
  end


  def onconnect(_ws_req, state) do
    {:ok, state}
  end

  def ondisconnect({:remote, :closed}, state) do
    {:reconnect, state}
  end

  def websocket_handle({:pong, _}, _conn_state, state) do
    IO.inspect("pong incoming")
    {:ok, state}
  end

  def websocket_handle({:text, msg}, _conn_state, state) do
    IO.puts "handling incoming msg"
    {:ok, state}
  end

  def websocket_info(:start, _conn_state, state) do
    {:reply, {:text, "erlang message received"}, state}
  end

  def websocket_terminate(reason, _conn_state, state) do
    IO.format("Websocket closed in state ~p wih reason ~p~n", [state, reason])
    :ok
  end

end
