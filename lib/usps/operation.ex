defmodule Usps.Operation do
  defstruct api: "",
            element: nil,
            parser: nil,
            configuration: nil

  def new(api, element, parser, configuration) do
    struct(
      __MODULE__,
      api: api,
      element: element,
      parser: parser,
      configuration: configuration
    )
  end
end
