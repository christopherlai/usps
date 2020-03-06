defmodule Usps.Client.Hackney do
  @moduledoc """
  Default HTTP client using `hackeny`.
  """

  @behaviour Usps.Client

  def request(url) do
    url
    |> :hackney.request()
    |> handle_response()
  end

  defp handle_response({:ok, status, header, ref}) do
    case :hackney.body(ref) do
      {:ok, body} ->
        {:ok, %{status_code: status, header: header, body: body}}

      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  defp handle_response({:ok, _status, _header}) do
    {:error, %{reason: "No response body"}}
  end

  defp handle_response({:error, reason}) do
    {:error, %{reason: reason}}
  end
end
