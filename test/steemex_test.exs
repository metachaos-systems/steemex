defmodule SteemexTest do
  use ExUnit.Case
  doctest Steemex

  test "basic jsonrpc call" do
    {:ok, sock} = Steemex.start_link( self() )
    send sock, {:send, %{jsonrpc: "2.0", params: ["database_api", "get_dynamic_global_properties", []], id: 1, method: "call"}}
    assert_receive %{"id" => _, "result" => %{"average_block_size" => _}}, 5_000
  end

  test "Client jsonrpc call function abstraction" do
    {:ok, sock} = Steemex.start_link( self() )
    Steemex.call(sock, ["database_api", "get_dynamic_global_properties", []])
    assert_receive %{"id" => _, "result" => %{"average_block_size" => _}}, 5_000
  end

end
