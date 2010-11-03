class SearchController < ApplicationController

  def show
    if params[:geoloc]
      @geoloc = GeoKit::GeoLoc.new(params[:geoloc])
      @geoloc.success = true
    elsif params[:address].present?
      @geoloc = GeoKit::Geocoders::GoogleGeocoder.geocode(params[:address])
    else
      redirect_to root_path, :notice => 'Home address is required.'
      return
    end

    @letter = Letter.new(
      :street     => @geoloc.street_address,
      :city       => @geoloc.city,
      :state      => @geoloc.state,
      :zip        => @geoloc.zip,
      :recipients => Legislator.search(@geoloc).map { |legislator| Recipient.new(:legislator => legislator) }
    )
  end

end
