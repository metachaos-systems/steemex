defmodule Steemex.MungedOps.Follow do
  @enforce_keys [:follower, :following, :what]
  defstruct [:follower, :following, :what]
end
