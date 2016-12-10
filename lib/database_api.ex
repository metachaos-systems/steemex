defmodule Steemex.DatabaseApi do

  def call(method, params) do
    Steemex.call(["database_api", method, params])
  end

  def get_block(height) do
    call("get_block", [height])
  end

  def get_content(author, permlink) do
    call("get_content", [author, permlink])
  end

  def get_accounts(accounts) do
    accounts = List.wrap(accounts)
    call("get_accounts", [accounts])
  end

  def get_block_header(height) do
    call("get_block_header", [height])
  end

  def get_dynamic_global_properties do
    call("get_dynamic_global_properties", [])
  end

  def get_chain_properties do
    call("get_chain_properties", [])
  end

  def get_feed_history do
    call("get_feed_history", [])
  end

  def get_current_median_history_price do
    call("get_current_median_history_price", [])
  end

  # ACCOUNTS
  def get_account_count() do
   call("get_account_count", [])
  end

  def lookup_accounts(lower_bound_name, limit) do
       call("lookup_accounts", [lower_bound_name,  limit])
    end

  # UTILITY
  defp call_db(method, params) do
    call( method, params)
  end
end
