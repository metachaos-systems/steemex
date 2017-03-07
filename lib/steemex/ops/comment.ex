defmodule Steemex.Ops.Comment do
  @enforce_keys [:author, :body, :json_metadata, :parent_author, :parent_permlink, :permlink, :title ]
  defstruct [:author, :body, :json_metadata, :parent_author, :parent_permlink, :permlink, :title ]
end
