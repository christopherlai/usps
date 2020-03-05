defmodule Usps.Shipment do
  import XmlBuilder, only: [element: 2, element: 3]
  import SweetXml
  alias Usps.Operation
  alias Usps.Configuration

  def track(number) when is_binary(number) do
    track([number])
  end

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

  defp track_id_element([]), do: []

  defp track_id_element([head | tail]) do
    [element(:TrackID, %{ID: head}, "") | track_id_element(tail)]
  end

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
