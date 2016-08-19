defmodule SteemexTest do
  use ExUnit.Case
  doctest Steemex


  test "client call fn for sending a msg to WS process jsonrpc and receives an async msg response" do
    Steemex.WS.start_link( self() )
    Steemex.IdAgent.start_link

    example_params = ["database_api", "get_dynamic_global_properties", []]
    Steemex.call(example_params)

    assert_receive {:"$gen_cast",
      {["database_api", "get_dynamic_global_properties", []], %{"id" => _, "result" => %{"average_block_size" => _}}}
    }, 5_000
  end




end
