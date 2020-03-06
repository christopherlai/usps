defmodule UspsTest do
  use ExUnit.Case
  import Mox
  alias Usps.Shipment
  alias Usps.Support.Helpers

  setup :verify_on_exit!

  setup do
    Helpers.put_env(:client, Usps.Client.Test)
  end

  describe "request/1" do
    test "successful API request" do
      response =
        ~s(<?xml version="1.0" encoding="UTF-8"?>
<TrackResponse><TrackInfo ID="123456"><Class>Priority Mail&lt;SUP>&amp;reg;&lt;/SUP></Class><ClassOfMailCode>PM</ClassOfMailCode><DestinationCity>SAN DIEGO</DestinationCity><DestinationState>CA</DestinationState><DestinationZip>92101</DestinationZip><EmailEnabled>true</EmailEnabled><ExpectedDeliveryDate>March 9, 2020</ExpectedDeliveryDate><KahalaIndicator>false</KahalaIndicator><MailTypeCode>DM</MailTypeCode><MPDATE>2020-03-05 20:07:26.000000</MPDATE><MPSUFFIX>492198736</MPSUFFIX><OnTime>false</OnTime><OriginCity>SAN DIEGO</OriginCity><OriginState>CA</OriginState><OriginZip>92101</OriginZip><PodEnabled>false</PodEnabled><TPodEnabled>false</TPodEnabled><RestoreEnabled>false</RestoreEnabled><RramEnabled>false</RramEnabled><RreEnabled>false</RreEnabled><Service>USPS Tracking&lt;SUP>&amp;#174;&lt;/SUP></Service><Service>Up to $50 insurance included</Service><ServiceTypeCode>055</ServiceTypeCode><Status>Arrived at USPS Regional Origin Facility</Status><StatusCategory>In Transit</StatusCategory><StatusSummary>Your item arrived at our SAN DIEGO CA NETWORK DISTRIBUTION CENTER origin facility on March 6, 2020 at 2:19 am. The item is currently in transit to the destination.</StatusSummary><TABLECODE>T</TABLECODE><TrackSummary><EventTime>2:19 am</EventTime><EventDate>March 6, 2020</EventDate><Event>Arrived at USPS Regional Origin Facility</Event><EventCity>SAN DIEGO CA NETWORK DISTRIBUTION CENTER</EventCity><EventState/><EventZIPCode/><EventCountry/><FirmName/><Name/><AuthorizedAgent>false</AuthorizedAgent><EventCode>10</EventCode></TrackSummary><TrackDetail><EventTime>1:19 am</EventTime><EventDate>March 6, 2020</EventDate><Event>Accepted at USPS Regional Facility</Event><EventCity>SAN DIEGO CA NETWORK DISTRIBUTION CENTER</EventCity><EventState/><EventZIPCode/><EventCountry/><FirmName/><Name/><AuthorizedAgent>false</AuthorizedAgent><EventCode>UA</EventCode></TrackDetail><TrackDetail><EventTime>11:50 pm</EventTime><EventDate>March 5, 2020</EventDate><Event>Shipping Label Created, USPS Awaiting Item</Event><EventCity>SAN DIEGO</EventCity><EventState>CA</EventState><EventZIPCode>92101</EventZIPCode><EventCountry/><FirmName/><Name/><AuthorizedAgent>false</AuthorizedAgent><EventCode>GX</EventCode><DeliveryAttributeCode>33</DeliveryAttributeCode></TrackDetail></TrackInfo></TrackResponse>)

      op = Shipment.track("123456")
      configuration = op.configuration

      encoded_xml =
        op.element
        |> XmlBuilder.generate()
        |> URI.encode()

      url = "#{configuration.url}/#{configuration.path}?API=#{op.api}&XML=#{encoded_xml}"

      expect(Usps.Client.Test, :request, fn ^url ->
        {:ok, %{status_code: 200, headers: [], body: response}}
      end)

      assert {:ok, [shipment]} = Usps.request(op)
      assert shipment.number == "123456"
    end
  end
end
