defmodule SteemexTest do
  use ExUnit.Case
  doctest Steemex
  @example_params ["database_api", "get_dynamic_global_properties", []]

  test "process streams jsonrpc msg response back to the process" do
    {:ok, _} = Steemex.start_link( self() )
    send Steemex.WS, {:send, %{jsonrpc: "2.0", params: @example_params, id: 1, method: "call"}}

    assert_receive %{"id" => _, "result" => %{"average_block_size" => _}}, 5_000
  end

  test "client call fn for sending a msg to WS process jsonrpc and receives an async msg response" do
    {:ok, _} = Steemex.start_link( self() )
    id = Steemex.call(Steemex.WS, @example_params)

    assert is_integer(id)
    assert_receive %{"id" => _, "result" => %{"average_block_size" => _}}, 5_000
  end


end
