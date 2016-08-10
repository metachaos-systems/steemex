defmodule SteemexTest do
  use ExUnit.Case
  doctest Steemex
  @example_params ["database_api", "get_dynamic_global_properties", []]

  test "client call fn for sending a msg to WS process jsonrpc and receives an async msg response" do
    {:ok, _} = Steemex.IdAgent.start_link
    Steemex.WS.start_link(self())

    Steemex.call(@example_params)

    assert_receive {["database_api", "get_dynamic_global_properties", []],%{"id" => _, "result" => %{"average_block_size" => _}}}, 5_000
  end


end
