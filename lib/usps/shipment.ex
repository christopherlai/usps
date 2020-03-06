defmodule Usps.Shipment do
  @moduledoc """
  Get tracking information about a shipment
  """
  import XmlBuilder, only: [element: 2, element: 3]
  import SweetXml
  alias Usps.Configuration
  alias Usps.Operation

  @type shipment :: %{
          number: nil | binary(),
          status: nil | binary(),
          category: nil | binary(),
          class: nil | binary(),
          destination_city: nil | binary(),
          origin_city: nil | binary(),
          origin_state: nil | binary(),
          origin_zip: nil | binary(),
          destination_state: nil | binary(),
          destination_zip: nil | binary(),
          on_time: nil | binary(),
          estimated_delivery_date: nil | binary(),
          summary: nil | binary(),
          events: [event()]
        }

  @type event :: %{
          name: nil | binary(),
          time: nil | binary(),
          date: nil | binary(),
          city: nil | binary(),
          state: nil | binary(),
          zip: nil | binary()
        }

  @doc """
  Get tracking information about a shipment using the tracking number.

  Pass a list of tracking numbers to track multiple shipments.
  """
  @spec track(number :: binary()) :: Operation.t()
  def track(number) when is_binary(number) do
    track([number])
  end

  @doc """
  Passing a list of tracking numbers to `track/1` to track multiple shipments.
  """
  @spec track(numbers :: [binary()]) :: Operation.t()
  def track(numbers) do
    configuration = Configuration.new()

    track_elements = track_id_element(numbers)
    revision = element(:Revision, 1)
    client_ip = element(:ClientIp, "174.65.133.202")
    source_id = element(:SourceId, "Sweet")

    elements = [
      revision,
      client_ip,
      source_id,
      track_elements
    ]

    element =
      element(
        :TrackFieldRequest,
        %{USERID: configuration.user_id},
        elements
      )

    Operation.new("TrackV2", element, &track_parser/1, configuration)
  end

  @spec track_id_element(list()) :: [tuple()]
  defp track_id_element([]), do: []

  defp track_id_element([head | tail]) do
    [element(:TrackID, %{ID: head}, "") | track_id_element(tail)]
  end

  @spec track_parser(element :: binary()) :: shipment()
  defp track_parser(element) do
    xpath(
      element,
      ~x"//TrackInfo"l,
      number: ~x"./@ID"s,
      status: ~x"./Status/text()"s,
      category: ~x"./StatusCategory/text()"s,
      class: transform_by(~x"./Class/text()"s, &HtmlSanitizeEx.strip_tags/1),
      destination_city: ~x"./DestinationCity/text()"s,
      origin_city: ~x"./OriginCity/text()"s,
      origin_state: ~x"./OriginState/text()"s,
      origin_zip: ~x"./OriginZip/text()"s,
      destination_state: ~x"./DestinationState/text()"s,
      destination_zip: ~x"./DestinationZip/text()"s,
      on_time: ~x"./OnTime/text()"o,
      estimated_delivery_date: ~x"./PredictedDeliveryDate/text()"s,
      summary: ~x"./StatusSummary/text()"s,
      events: [
        ~x"./TrackDetail"l,
        name: ~x"./Event/text()"s,
        time: ~x"./EventTime/text()"s,
        date: ~x"./EventDate/text()"s,
        city: ~x"./EventCity/text()"s,
        state: ~x"./EventState/text()"s,
        zip: ~x"./EventZIPCode/text()"s
      ]
    )
  end
end
