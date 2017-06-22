defmodule Steemex.MungedOps.Comment do
  @enforce_keys [:author, :body, :json_metadata, :parent_author, :parent_permlink, :permlink, :title, :tags, :app ]
  defstruct [:author, :body, :json_metadata, :parent_author, :parent_permlink, :permlink, :title, :tags, :app ]
end
