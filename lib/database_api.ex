defmodule Steemex.DatabaseApi do

    def call(method, params) do
      Steemex.call(["database_api"], method, [params])
    end


end
