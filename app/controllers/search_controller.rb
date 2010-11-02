class SearchController < ApplicationController

  def show
    if params[:geoloc]
      geoloc = GeoKit::GeoLoc.new(params[:geoloc])
      geoloc.success = true
    else
      geoloc = GeoKit::Geocoders::GoogleGeocoder.geocode(params[:address])
    end

    @letter = Letter.new(
      :street     => geoloc.street_address,
      :city       => geoloc.city,
      :state      => geoloc.state,
      :zip        => geoloc.zip,
      :recipients => Legislator.search(geoloc).map { |legislator| Recipient.new(:legislator => legislator) }
    )
  end

end
