defmodule Steemex do
  use Application
  alias Steemex.IdStore

  defdelegate get_current_median_history_price(), to: Steemex.DatabaseApi
  defdelegate get_feed_history(), to: Steemex.DatabaseApi
  defdelegate get_chain_properties(), to: Steemex.DatabaseApi
  defdelegate get_dynamic_global_properties(), to: Steemex.DatabaseApi
  defdelegate get_block_header(height), to: Steemex.DatabaseApi
  defdelegate get_accounts(accounts), to: Steemex.DatabaseApi
  defdelegate get_content(author, permlink), to: Steemex.DatabaseApi
  defdelegate get_witness_schedule(), to: Steemex.DatabaseApi
  defdelegate get_config(), to: Steemex.DatabaseApi
  defdelegate get_next_scheduled_hardfork(), to: Steemex.DatabaseApi
  defdelegate get_hardfork_version(), to: Steemex.DatabaseApi
  defdelegate get_account_count(), to: Steemex.DatabaseApi
  defdelegate get_block(height), to: Steemex.DatabaseApi
  defdelegate lookup_accounts(lower_bound_name, limit), to: Steemex.DatabaseApi
  defdelegate lookup_account_names(account_names), to: Steemex.DatabaseApi
  defdelegate get_account_history(name, from, limit), to: Steemex.DatabaseApi

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
