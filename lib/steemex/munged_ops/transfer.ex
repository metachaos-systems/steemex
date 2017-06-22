defmodule Steemex.MungedOps.Transfer do
  @enforce_keys [:amount, :from, :to, :memo, :token]
  defstruct [:amount, :from, :to, :memo, :token]
end
