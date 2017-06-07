defmodule Steemex.Ops.TransformersTest do
  use ExUnit.Case, async: true
  alias Steemex.Ops
  doctest Steemex

  test "transfer op cleaned correctly " do
    op = %Ops.Transfer{to: "bob", from: "alice", amount: "100 SBD", memo: "nice cypher you've got there"}
    prepared = Steemex.Ops.Transform.prepare_for_db(op)
    assert prepared == %{to: "bob", from: "alice", amount: 100.0, token: "SBD", memo: "nice cypher you've got there"}
  end

  test "comment op cleaned correctly " do
    op = %{body: "body1", title: "", author: "alice", permlink: "permlink1", json_metadata: "{\"tags\":[\"tag1\"],\"app\":\"steemit/0.1\"}", parent_author: "parent_author1", parent_permlink: "parent_permlink1"}
    prepared = Steemex.Ops.Transform.prepare_for_db(op)
    json_metadata = %{tags: ["tag1"], app: "steemit/0.1"}
    assert prepared == %{body: "body1", title: nil, author: "alice", permlink: "permlink1", tags: json_metadata.tags, app: json_metadata.app, json_metadata: json_metadata, parent_author: "parent_author1", parent_permlink: "parent_permlink1"}
  end

end
