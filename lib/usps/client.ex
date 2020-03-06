defmodule Usps.Client do
  @moduledoc """
  Behaviour for HTTP clients.

  The default `Usps.Client.Hackney` client  can be replaced by defining a module that implements the callbacks defined in this module.
  """

  @type success :: {:ok, %{status_code: integer(), headers: keyword(), body: any()}}
  @type error :: {:error, %{reason: any()}}

  @doc """
  Makes a `GET` request to the given url.
  """
  @callback request(url :: binary()) :: success() | error()
end
