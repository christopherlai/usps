defmodule Usps do
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
