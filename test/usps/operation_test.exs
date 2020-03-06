defmodule Usps.OperationTest do
  use ExUnit.Case, async: true
  alias Usps.Configuration
  alias Usps.Operation

  describe "new/4" do
    test "returns a Operation struct" do
      config = Configuration.new()
      parser = & &1
      op = Operation.new("Track", {}, parser, config)

      assert op.api == "Track"
      assert op.element == {}
      assert op.parser == parser
      assert op.configuration == config
    end
  end
end
