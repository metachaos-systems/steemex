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

  def call(params, opts \\ [])

  def call(params, []) do
    id = gen_id()
    IdStore.put(id, {self(), params})

    send_jsonrpc_call(id, params)

    response = receive do
      {:ws_response, {_, _, response}} -> response
    end

    case response["error"] do
      nil -> {:ok, response["result"]}
      _ -> {:error, response["error"]}
    end
  end


  def get_block(height) do
    call [@db_api, "get_block", [height]]
  end

  def get_content(author, permlink) do
    call [@db_api, "get_content", [author, permlink]]
  end

  def get_accounts(accounts) do
    accounts = List.wrap(accounts)
    call([@db_api, "get_accounts", [accounts]])
  end

  def get_block_header(height) do
    call([@db_api, "get_block_header", [height]])
  end

  def get_dynamic_global_properties do
    call([@db_api, "get_dynamic_global_properties", []])
  end

  def get_chain_properties do
    call([@db_api, "get_chain_properties", []])
  end

  def get_feed_history do
    call([@db_api, "get_feed_history", []])
  end

  def get_current_median_history_price do
    call([@db_api, "get_current_median_history_price", []])
  end

  defp call_db(method, params) do
    call([@db_api, method, params])
  end

  @doc """
  Sends an event to the WebSocket server
  """
  defp send_jsonrpc_call(id, params) do
    send Steemex.WS, {:send, %{jsonrpc: "2.0", id: id, params: params, method: "call"}}
  end

  defp gen_id do
    round(:rand.uniform * 1.0e16)
  end

end
