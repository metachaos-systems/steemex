defmodule Steemex.StructuredOps.FeedPublish do
  @enforce_keys [:publisher, :base_token, :base_amount, :quote_token, :quote_amount]
  defstruct [:publisher, :base_token, :base_amount, :quote_token, :quote_amount]
end
