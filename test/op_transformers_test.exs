defmodule Steemex.Ops.TransformersTest do
  use ExUnit.Case, async: true
  alias Steemex.Ops
  doctest Steemex

  test "transfer op cleaned correctly " do
    op = %Ops.Transfer{to: "bob", from: "alice", amount: "100 SBD", memo: "nice cypher you've got there"}
    prepared = Steemex.Ops.Transform.prepare_for_db(op)
    assert prepared == %{to: "bob", from: "alice", amount: 100.0, token: "SBD", memo: "nice cypher you've got there"}
  end


end
