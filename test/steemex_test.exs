defmodule SteemexTest do
  use ExUnit.Case, async: true
  doctest Steemex
  @db_api "database_api"

  setup_all context do

    url = Application.get_env(:steemex, :url)

    Steemex.IdStore.start_link
    Steemex.WS.start_link(url)

    %{
      params:
      %{
        glob_dyn_prop: [@db_api, "get_dynamic_global_properties", []],
        get_block: [@db_api, "get_block", [3_141_592]]
      }
    }
  end

  test "get_dynamic_global_properties call succeeds", context do
    params = context.params.glob_dyn_prop
    {:ok, result} = Steemex.call(params)

    assert %{"head_block_id" => _} = result
  end

  test "get_content" do
    {:ok, data} = Steemex.get_content("xeroc", "piston-web-first-open-source-steem-gui---searching-for-alpha-testers")

    assert %{"author" => _, "permlink" => _} = data
  end

  test "get_block" do
    {:ok, data} = Steemex.get_block(3_141_592)

    assert %{"previous" => _, "transactions" => _} = data
  end

  test "get_accounts with multiple args" do
    {:ok, data} = Steemex.get_accounts(["dan", "ned"])
    assert %{"name" => _, "id" => _} = hd(data)
  end

  test "get_block_header" do
    {:ok, data} = Steemex.get_block_header(1)
    assert %{"timestamp" => "2016-03-24T16:05:00"} = data
  end

  test "get_dynamic_global_properties" do
    {:ok, data} = Steemex.get_dynamic_global_properties()
    IO.inspect data 
    assert %{"average_block_size" => _,"confidential_sbd_supply" => _} = data
  end

  test "get_chain_properties" do
    {:ok, data} = Steemex.get_chain_properties()
    assert %{"account_creation_fee" => _, "maximum_block_size" => _} = data
  end

  test "get_feed_history" do
    {:ok, data} = Steemex.get_feed_history()
    assert %{"current_median_history" => %{"base" => _}} = data
  end

  test "get_current_median_history_price" do
    {:ok, data} = Steemex.get_feed_history()
    assert %{"current_median_history" => %{"base" => _}} = data
  end

  test "get_account_count" do
    {:ok, data} = Steemex.get_account_count()
    assert 31415 < data
  end

  test "lookup_accounts" do
    {:ok, data} =  Steemex.lookup_accounts("steempunks", 10)
    assert is_list(data)
    assert is_bitstring(hd data)
  end

  test "lookup_account_names" do
    {:ok, data} = Steemex.lookup_account_names(["ontofractal"])
    assert %{"name" =>  "ontofractal"} = hd(data)
  end

  test "get_account_history" do
    {:ok, data} = Steemex.get_account_history("ontofractal", -1, 10)
    assert [_, %{"block" => _}] = hd(data)
  end
end
