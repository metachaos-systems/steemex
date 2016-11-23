defmodule SteemexTest do
  use ExUnit.Case, async: true
  doctest Steemex
  @db_api "database_api"

  setup_all context do
    Steemex.IdStore.start_link
    url = Application.get_env(:steemex, :url)
    Steemex.WS.start_link(url)
    Steemex.Handler.start_link
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

  test "get_dynamic_global_properties handler call succeeds", context do
    params = context.params.glob_dyn_prop
    Steemex.call(params, stream_to: self())

    assert_receive {:ws_response, {_, ^params, %{"result" => %{"head_block_id" => _}}} }, 1_000
  end

  test "get_content" do
    {:ok, data} = Steemex.get_content("xeroc", "piston-web-first-open-source-steem-gui---searching-for-alpha-testers")

    assert %{"author" => _, "permlink" => _} = data
  end

  test "get_block" do
    {:ok, data} = Steemex.get_block(3_141_592)

    assert %{"previous" => _, "transactions" => _} = data
  end

  test "get_block handler" do
    id = Steemex.get_block(3_141_592, stream_to: self())

    assert_receive {:ws_response, {_, _, %{"result" => %{"previous" => _, "transactions" => _}}}}, 1_000
  end

  test "get_accounts with multiple args" do
    {:ok, data} = Steemex.get_accounts(["dan", "ned"])
    assert %{"name" => _, "id" => _} = hd(data)
  end

  test "get_block_header with multiple args" do
    {:ok, data} = Steemex.get_block_header(1)
    assert %{"timestamp" => "2016-03-24T16:05:00"} = data
  end

end
