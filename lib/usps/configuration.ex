defmodule Usps.Configuration do
  @moduledoc """
  Configurations used to make HTTP(S) requests to the USPS API.

  Configurations can be set via the project configs, directly using the `Configuration.new/1` function, or some combination of the two.
  ```elixir
  # config.exs
  import Config

  config :usps,
  url: "secure.shippingapis.com",
  path: "/shippingapi.dll",
  user_id: "USER123"

  # direclty using new/1
  config = Configuration.new(url: "https://example.com")
  ```

  Configuration options passed as arguments to `new/1` will always override configurations in `config.exs`.
  """

  @type t :: %__MODULE__{
          url: nil | binary(),
          path: nil | binary(),
          user_id: nil | binary(),
          client: nil | module()
        }

  defstruct url: "",
            path: "",
            user_id: "",
            client: Usps.Client.Hackney

  @doc """
  Returns a new `Configuration` struct with the given overrides applied.
  """
  @spec new(overrides :: keyword()) :: t()
  def new(overrides \\ []) do
    fields =
      :usps
      |> Application.get_all_env()
      |> Keyword.merge(overrides)

    struct(__MODULE__, fields)
  end
end
