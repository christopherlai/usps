defmodule Usps.ConfigurationTest do
  use ExUnit.Case, async: true
  alias Usps.Configuration
  alias Usps.Support.Helpers

  setup do
    Helpers.put_all_env()

    :ok
  end

  describe "new/1" do
    test "returns a Configuration struct" do
      config = Configuration.new()

      assert config.url == "http://example.com"
      assert config.path == "/endpoint"
      assert config.user_id == "userid"
    end

    test "overrides configuations from env" do
      config = Configuration.new(path: "/override")

      assert config.url == "http://example.com"
      assert config.path == "/override"
      assert config.user_id == "userid"
    end
  end
end
