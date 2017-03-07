defmodule Steemex.Ops.Transfer do
  @enforce_keys [:amount, :from, :to, :memo]
  defstruct [:amount, :from, :to, :memo]
end
