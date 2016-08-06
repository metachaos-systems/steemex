defmodule SteemexTest do
  use ExUnit.Case
  doctest Steemex

  test "the truth" do
    {:ok, sock} = Steemex.start_link( self() )
    send sock, {:send, %{jsonrpc: "2.0", params: ["database_api", "get_dynamic_global_properties", []], id: 1, method: "call"}}
    assert_receive %{"id" => _, "result" => %{"average_block_size" => _}}, 10_000
  end

end
