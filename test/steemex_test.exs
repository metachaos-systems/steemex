defmodule SteemexTest do
  use ExUnit.Case
  doctest Steemex

  test "basic jsonrpc call" do
    {:ok, _} = Steemex.start_link( self() )
    send Steemex, {:send, %{jsonrpc: "2.0", params: ["database_api", "get_dynamic_global_properties", []], id: 1, method: "call"}}

    assert_receive %{"id" => _, "result" => %{"average_block_size" => _}}, 5_000
  end

  test "client jsonrpc call function" do
    {:ok, _} = Steemex.start_link( self() )
    id = Steemex.call(Steemex, ["database_api", "get_dynamic_global_properties", []])

    assert is_integer(id)
    assert_receive %{"id" => _, "result" => %{"average_block_size" => _}}, 5_000
  end


end
