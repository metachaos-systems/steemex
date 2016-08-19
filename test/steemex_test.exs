defmodule SteemexTest do
  use ExUnit.Case
  doctest Steemex


  test "client call fn for sending a msg to WS process jsonrpc and receives an async msg response" do
    test_pid = self()
    handler_fn = fn data ->
      send(test_pid, data)
    end

    Steemex.IdAgent.start_link
    Steemex.WS.start_link(handler_fn, System.get_env("STEEM_URL"))

    example_params = ["database_api", "get_dynamic_global_properties", []]

    Steemex.call(example_params)

    assert_receive {["database_api", "get_dynamic_global_properties", []], %{"id" => _, "result" => _}}, 5_000
  end




end
