defmodule UspsTest do
  use ExUnit.Case
  doctest Usps

  test "greets the world" do
    assert Usps.hello() == :world
  end
end
