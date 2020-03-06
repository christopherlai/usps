defmodule Usps do
  @moduledoc """
  Light API wrapper around the XML based API for USPS.

  API requests are broken down into two steps.
  1. Create a `Operation` struct
  2. Pass the `Operation` struct into `request/1`
  """

  alias Usps.Client
  alias Usps.Operation

  @doc """
  Execute a request to the USPS API using the given operation.
  """
  @spec request(operation :: Operation.t()) :: Client.success() | Client.error()
  def request(operation) do
    configuration = operation.configuration

    encoded_xml =
      operation.element
      |> XmlBuilder.generate()
      |> URI.encode()

    url = "#{configuration.url}/#{configuration.path}?API=#{operation.api}&XML=#{encoded_xml}"

    case configuration.client.request(url) do
      {:ok, %{status_code: status, body: body}} when status in 200..299 ->
        {:ok, operation.parser.(body)}

      {:ok, %{status_code: status, body: body}} ->
        {:error, "Returns status code: #{status}. Body: #{inspect(body)}"}

      {:error, %{reason: reason}} ->
        {:error, "Unable to complete request. Reason: #{inspect(reason)}"}
    end
  end
end
