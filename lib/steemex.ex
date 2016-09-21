defmodule Steemex do
  use Application
  alias Steemex.IdStore
  @db_api "database_api"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    url = Application.get_env(:steemex, :url)

    unless url, do: throw("Steemex WS url is NOT configured.")

    children = [
      worker(IdStore, []),
      worker(Steemex.WS, [url])
    ]
    opts = [strategy: :one_for_one, name: Steemex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def call(params) do
    id = gen_id()
    IdStore.put(id, {params, self()})

    send_jsonrpc_call(id, params)

    response = receive do
      {:ws_response, {id, params, response}} -> response
    end

    case response["error"] do
      nil -> {:ok, response["result"]}
      _ -> {:error, response["error"]}
    end
  end

  def call(params, stream_to: pid) do
    id = gen_id()
    IdStore.put(id, {params, pid})
    send_jsonrpc_call(id, params)
    id
  end

  def get_block(height) do
    Steemex.call [@db_api, "get_block", [height]]
  end

  def get_content(author, permlink) do
    Steemex.call [@db_api, "get_content", [author, permlink]]
  end

  def get_accounts(accounts) do
    accounts = List.wrap(accounts)
    call([@db_api, "get_accounts", [accounts]])
  end


  @doc """
  Sends an event to the WebSocket server
  """
  def send_event(server_pid, msg) do
    send server_pid, {:send, msg}
  end

  defp send_jsonrpc_call(id, params) do
    send_event Steemex.WS, %{jsonrpc: "2.0", id: id, params: params, method: "call"}
  end

  defp gen_id do
    round(:rand.uniform * 1.0e16)
  end

end
