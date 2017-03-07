defmodule Steemex.Ops.TransferToVesting do
  @enforce_keys [:from, :to, :amount]
  defstruct [:from, :to, :amount]
end
