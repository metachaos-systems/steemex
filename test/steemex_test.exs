defmodule SteemexTest do
  use ExUnit.Case
  doctest Steemex


  test "get_dynamic_global_properties call succeeds" do
    test_pid = self()
    handler_fn = fn id, call_params, data  ->
      send(test_pid, {id, call_params, data})
    end
    Steemex.IdAgent.start_link
    Steemex.WS.start_link(handler_fn, System.get_env("STEEM_URL"))
    example_params = ["database_api", "get_dynamic_global_properties", []]

    Steemex.call(example_params)

    assert_receive {_, ["database_api", "get_dynamic_global_properties", []], %{"id" => _, "result" => _}}, 5_000
  end




end
