defmodule Steemex.StructuredOps.Reblog do
  @enforce_keys [:account, :author, :permlink]
  defstruct [:account, :author, :permlink]
end
