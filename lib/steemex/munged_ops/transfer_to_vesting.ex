defmodule Steemex.MungedOps.TransferToVesting do
  @enforce_keys [:to, :from, :amount, :token]
  defstruct [:to, :from, :amount, :token]
end
