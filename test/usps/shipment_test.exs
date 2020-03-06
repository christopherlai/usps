defmodule Usps.ShipmentTest do
  use ExUnit.Case, async: true
  alias Usps.Shipment
  alias Usps.Support.Helpers

  setup do
    Helpers.put_all_env()

    :ok
  end

  describe "track/1" do
    test "returns a Operation struct" do
      op = Shipment.track("123456")

      assert op.api == "TrackV2"
    end
  end
end
