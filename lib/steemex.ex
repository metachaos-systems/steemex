defmodule Steemex do
  use Application
  alias Steemex.IdStore
  require Logger


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
  defdelegate get_trending_tags(after_tag, limit), to: Steemex.DatabaseApi
  defdelegate get_discussions_by(metric, query), to: Steemex.DatabaseApi
  defdelegate get_categories(metric, after_category, query), to: Steemex.DatabaseApi
  defdelegate get_state(path), to: Steemex.DatabaseApi
  defdelegate get_content_replies(author,permlink), to: Steemex.DatabaseApi
  defdelegate get_discussions_by_author_before_date(author, start_permlink, before_date, limit), to: Steemex.DatabaseApi
  defdelegate get_replies_by_last_update(author, start_permlink, before_date, limit), to: Steemex.DatabaseApi

  defdelegate get_owner_history(name), to: Steemex.DatabaseApi
  defdelegate get_conversion_requests(), to: Steemex.DatabaseApi
  defdelegate get_order_book(limit), to: Steemex.DatabaseApi
  defdelegate get_open_orders(name), to: Steemex.DatabaseApi
  defdelegate get_witnesses(names), to: Steemex.DatabaseApi
  defdelegate get_witnesses_by_vote(from, limit), to: Steemex.DatabaseApi
  defdelegate lookup_witness_accounts(lower_bound_name, limit), to: Steemex.DatabaseApi
  defdelegate get_witness_count(), to: Steemex.DatabaseApi
  defdelegate get_active_witnesses(), to: Steemex.DatabaseApi
  defdelegate get_miner_queue(), to: Steemex.DatabaseApi
  defdelegate get_account_votes(name), to: Steemex.DatabaseApi
  defdelegate get_active_votes(author, permlink), to: Steemex.DatabaseApi
  defdelegate get_followers(account, start_follower, follow_type, limit), to: Steemex.DatabaseApi
  defdelegate get_following(account, start_following, follow_type, limit), to: Steemex.DatabaseApi

  @db_api "database_api"

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      supervisor(Steemex.Supervisor, [])
    ]
    Supervisor.start_link(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 5)
  end

  def call(params, opts \\ [])

  def call(params, []) do
    :ok = send({self, params})

    response = receive do
      {:ws_response, {_, _, response}} -> response
    end

    err = response["err"]
    result = response["result"]
    case {err, result} do
      {_, nil} -> {:error, nil}
      {nil, _} -> {:ok, AtomicMap.convert(result, safe: false, underscore: false)}
      _ ->
        {:error, err}
    end
  end

  def send({from, params}) do
    # TODO: perhaps implement registry for a id => pid mapping?
    id = gen_id()
    message = %{jsonrpc: "2.0", id: id, params: params, method: "call"}
    :ok = Steemex.IdStore.put(id, {from, params})
    WebSockex.send_frame(:steemex_ws, {:text, Poison.encode!(message)})
  end

  @doc """
  Sends an event to the WebSocket server
  """
  defp send_jsonrpc_call(params) do
    Steemex.WSNext.send({self, params})
  end

  defp gen_id do
    round(:rand.uniform * 1.0e16) |> Integer.to_string
  end

end
