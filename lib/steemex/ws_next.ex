defmodule Steemex.WSNext do
  use WebSockex
  require Logger

  def start_link(url, opts \\ []) do
    uri = URI.parse(url)
    opts = Keyword.merge(opts, [name: :steemex_ws])
    WebSockex.start_link(url, __MODULE__, %{}, opts)
  end


  def handle_connect(_conn, state) do
    Logger.info("Steem websocket is connected!")
    {:ok, state}
  end

  def handle_frame({:text, msg}, state) do
    data = Poison.decode!(msg)
    id = data["id"]
    {from, params} = Steemex.IdStore.get(id)
    send(from, {:ws_response, {id, params, data}})
    {:ok, state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.info("Local close with reason: #{inspect reason}")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end

end
