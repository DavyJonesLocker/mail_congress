class SearchController < InheritedResources::Base
  respond_to :html
  defaults :resource_class => Legislator, :collection_name => 'legislators', :instance_name => 'legislators'
  actions :show

  def show
    geoloc = GeoKit::Geocoders::GoogleGeocoder.geocode(params[:address])
    @letter = Letter.new(
      :street     => geoloc.street_address,
      :city       => geoloc.city,
      :state      => geoloc.state,
      :zip        => geoloc.zip,
      :recipients => Legislator.search(geoloc)
    )
  end
end
