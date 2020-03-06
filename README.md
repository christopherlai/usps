# USPS
A wrapper around the [USPS XML API](#)(https://www.usps.com/business/web-tools-apis/).

## Installation
The package can be installed by adding `usps` to your list of dependencies in `mix.exs` along with `hackney`.
```elixir
# mix.exs
defp deps do
  {:usps, "~> 0.1"},
  {:hackney, "~> 1.0"}
end
```

## Configuration
Configurations are managed through the project configs. `:url`, `:path`, and `:user_id` are required keys.

The`:url` and`:path` can be found in the [USPS documentation](https://www.usps.com/business/web-tools-apis/documentation-updates.htm). You must [register](https://registration.shippingapis.com/) for an account with with USPS to obtain a `:user_id`.
```elixir
# config.exs
import Config

config :usps,
  url: "https://secure.shippingapis.com",
  path: "/ShippingAPI.dll",
  user_id: "<YOUR-USER-ID>,
  client: MyApp.Client #optional
```

##  Testing
A combination of `mox` and `behaviours` are used for testing.
```elixir
# test_helper.exs
ExUnit.start()
Mox.defmock(MyApp.UspsTestClient, for: Usps.Client)

# my_app_test.exs
defmodule MyAppTest do
  use ExUnit.Case
  import Mox
  setup :verify_on_exit!

  test "test usps" do
   expect(MyApp.UspsTestClient, :request, fn _url ->
      {:ok, %{status_code: 200, headers: [], body:""}}
    end)

    assert {:ok, response} =
      "1234"
      |> Usps.Shipment.new()
      |> Usps.request()
  end
end
```

Please see [`mox`](https://hexdocs.pm/mox/Mox.html) for more information.

## Code Status

## License
The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
