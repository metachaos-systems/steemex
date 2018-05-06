defmodule Steemex do
  alias Steemex.DatabaseApi
  use Application
  require Logger
  @default_api :steemit_api

  defdelegate get_current_median_history_price(), to: DatabaseApi
  defdelegate get_feed_history(), to: DatabaseApi
  defdelegate get_chain_properties(), to: DatabaseApi
  defdelegate get_dynamic_global_properties(), to: DatabaseApi
  defdelegate get_block_header(height), to: DatabaseApi
  defdelegate get_accounts(accounts), to: DatabaseApi
  defdelegate get_content(author, permlink), to: DatabaseApi
  defdelegate get_witness_schedule(), to: DatabaseApi
  defdelegate get_config(), to: DatabaseApi
  defdelegate get_next_scheduled_hardfork(), to: DatabaseApi
  defdelegate get_hardfork_version(), to: DatabaseApi
  defdelegate get_account_count(), to: DatabaseApi
  defdelegate get_block(height), to: DatabaseApi
  defdelegate lookup_accounts(lower_bound_name, limit), to: DatabaseApi
  defdelegate lookup_account_names(account_names), to: DatabaseApi
  defdelegate get_account_history(name, from, limit), to: DatabaseApi
  defdelegate get_trending_tags(after_tag, limit), to: DatabaseApi
  defdelegate get_discussions_by(metric, query), to: DatabaseApi
  defdelegate get_categories(metric, after_category, query), to: DatabaseApi
  defdelegate get_state(path), to: DatabaseApi
  defdelegate get_content_replies(author, permlink), to: DatabaseApi

  defdelegate get_discussions_by_author_before_date(author, start_permlink, before_date, limit),
    to: DatabaseApi

  defdelegate get_owner_history(name), to: DatabaseApi
  defdelegate get_conversion_requests(), to: DatabaseApi
  defdelegate get_order_book(limit), to: DatabaseApi
  defdelegate get_open_orders(name), to: DatabaseApi
  defdelegate get_witnesses(names), to: DatabaseApi
  defdelegate get_witnesses_by_vote(from, limit), to: DatabaseApi
  defdelegate lookup_witness_accounts(lower_bound_name, limit), to: DatabaseApi
  defdelegate get_witness_count(), to: DatabaseApi
  defdelegate get_active_witnesses(), to: DatabaseApi
  defdelegate get_miner_queue(), to: DatabaseApi
  defdelegate get_account_votes(name), to: DatabaseApi
  defdelegate get_active_votes(author, permlink), to: DatabaseApi
  defdelegate get_followers(account, start_follower, follow_type, limit), to: DatabaseApi
  defdelegate get_following(account, start_following, follow_type, limit), to: DatabaseApi

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Steemex.Supervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 5)
  end

  def call(params, opts \\ [])

  def call(params, opts) do
    case Application.get_env(:steemex, :api) || @default_api do
      :steemit_api ->
        call_condenser(params, opts)

      :jsonrpc_wss_api ->
        call_ws(params, opts)
    end
  end

  def call_condenser(params, []) do
    {:ok, result} = Steemex.SteemitApiClient.call(params)
    AtomicMap.convert(result, safe: false, underscore: false)
  end

  def call_ws(params, []) do
    :ok = send({self(), params})

    response =
      receive do
        {:ws_response, {_, _, response}} -> response
      end

    err = response["err"]
    result = response["result"]

    case {err, result} do
      {_, nil} ->
        {:error, nil}

      {nil, _} ->
        {:ok, AtomicMap.convert(result, safe: false, underscore: false)}

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
    Steemex.WSNext.send({self(), params})
  end

  defp gen_id do
    round(:rand.uniform() * 1.0e16) |> Integer.to_string()
  end
end
