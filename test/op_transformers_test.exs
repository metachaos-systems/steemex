defmodule Steemex.Ops.TransformersTest do
  use ExUnit.Case, async: true
  alias Steemex.Ops
  doctest Steemex

  test "transfer op cleaned correctly " do
    op = %Ops.Transfer{to: "bob", from: "alice", amount: "100 SBD", memo: "nice cypher you've got there"}
    prepared = Ops.Transform.prepare_for_db(op)
    assert prepared == %{to: "bob", from: "alice", amount: 100.0, token: "SBD", memo: "nice cypher you've got there"}
  end

  test "comment op cleaned correctly " do
    op = %Ops.Comment{body: "body1", title: "", author: "alice", permlink: "permlink1", json_metadata: "{\"tags\":[\"tag1\"],\"app\":\"steemit/0.1\"}", parent_author: "parent_author1", parent_permlink: "parent_permlink1"}
    prepared = Ops.Transform.prepare_for_db(op)
    json_metadata = %{tags: ["tag1"], app: "steemit/0.1"}
    assert prepared == %{body: "body1", title: nil, author: "alice", permlink: "permlink1", tags: json_metadata.tags, app: json_metadata.app, json_metadata: json_metadata, parent_author: "parent_author1", parent_permlink: "parent_permlink1"}
  end

  test "comment with no parent_author op cleaned correctly " do
    op = %Ops.Comment{body: "body1", title: "", author: "alice", permlink: "permlink1", json_metadata: "{\"tags\":[\"tag1\"],\"app\":\"steemit/0.1\"}", parent_author: "", parent_permlink: "category"}
    prepared = Ops.Transform.prepare_for_db(op)
    json_metadata = %{tags: ["tag1"], app: "steemit/0.1"}
    assert prepared == %{body: "body1", title: nil, author: "alice", permlink: "permlink1", tags: json_metadata.tags, app: json_metadata.app, json_metadata: json_metadata, parent_author: nil, parent_permlink: "category"}
  end

  test "follow op cleaned and parsed correctly " do
    op = %Ops.CustomJson{id: "follow", json: "[\"follow\",{\"follower\":\"follower1\",\"following\":\"following1\",\"what\":[\"blog\"]}]", "required_auths": [], "required_posting_auths": ["follower1"]}
    prepared = Ops.Transform.prepare_for_db(op)
    assert prepared == %{follower: "follower1", following: "following1", what: ["blog"]}
  end

  test "reblog op cleaned and parsed correctly " do
    op = %Ops.CustomJson{id: "follow", json: "[\"reblog\",{\"account\":\"account1\",\"author\":\"author1\",\"permlink\":\"permlink1\"}]", "required_auths": [], "required_posting_auths": ["account1"]}
    prepared = Ops.Transform.prepare_for_db(op)
    assert prepared == %{account: "account1", author: "author1", permlink: "permlink1"}
  end

  test "transfer_to_vesting op cleaned and parsed correctly " do
    op = %Ops.TransferToVesting{"to": "account1", "from": "account2", "amount": "3.140 STEEM"}
    prepared = Ops.Transform.prepare_for_db(op)
    assert prepared == %{to: "account1", from: "author1", amount: 3.14, token: "STEEM"}
  end


end
