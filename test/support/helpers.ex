defmodule Usps.Support.Helpers do
  @moduledoc """
  Helper functions for testing.
  """

  @default [url: "http://example.com", path: "/endpoint", user_id: "userid"]

  def put_all_env(overrides \\ []) do
    env = Keyword.merge(@default, overrides)

    Application.put_all_env(usps: env)
  end

  def put_env(key, value) do
    Application.put_env(:usps, key, value)
  end
end
