defmodule Steemex.Event do
  @moduledoc """
  A generic blockchain container
  """
  @enforce_keys [:data, :metadata]
  defstruct [:data, :metadata]
end
