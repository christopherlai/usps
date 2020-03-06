defmodule Usps.Operation do
  @moduledoc """
  Operation structs are used to construct a HTTP(S) request. Operations are made up of the following parts:
  * `api` - The USPS API being requested
  * `element` - The XML document for the request
  * `parser` - An anonymous function used to parse the response
  * `configuration` - A `Configuration` struct used to build the request
  """
  alias Usps.Configuration

  @type t :: %__MODULE__{
          api: nil | binary(),
          element: nil | term(),
          parser: nil | binary(),
          configuration: nil | Configuration.t()
        }

  defstruct api: "",
            element: nil,
            parser: nil,
            configuration: nil

  @doc """
  Returns a new `Operation` struct with the given arguments.
  """
  @spec new(
          api :: binary(),
          element :: term(),
          parser :: fun(),
          configuration :: Configuration.t()
        ) :: t()
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
