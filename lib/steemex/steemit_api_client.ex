defmodule Steemex.SteemitApiClient do
  alias JSONRPC2.Clients.HTTP

  @url Application.get_env(:steemex, :api_url) || "https://api.steemit.com"

  def call([api, method, args]) do
    api =
      case api do
        "database_api" -> "condenser_api"
        _ -> throw("This JSONRPC api is not supported")
      end

    response = HTTP.call(@url, "#{api}.#{method}", args)

    case response do
      {:error, reason} -> {:error, reason}
      {:ok, data} -> {:ok, data}
    end
  end
end
