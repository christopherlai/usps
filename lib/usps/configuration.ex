defmodule Usps.Configuration do
  defstruct url: "",
            path: "",
            user_id: "",
            client: Usps.Client.Hackney

  def new(overrides \\ []) do
    fields =
      :usps
      |> Application.get_all_env()
      |> Keyword.merge(overrides)

    struct(__MODULE__, fields)
  end
end
