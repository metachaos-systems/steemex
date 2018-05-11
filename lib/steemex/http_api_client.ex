defmodule Steemex.HttpClient do
  alias JSONRPC2.Clients.HTTP

  @url Application.get_env(:steemex, :api_url)

  def call([api, method, args]) do
    response = HTTP.call(@url, "#{api}.#{method}", args)
    {:ok, response}
  end
end
