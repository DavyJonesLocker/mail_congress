class SearchController < ApplicationController

  def show
    if params[:geoloc]
      @geoloc = GeoKit::GeoLoc.new(params[:geoloc])
      @geoloc.success = true
    elsif params[:address].present?
      if bogus_address?(params[:address])
        invalid_address
        return
      end
      @geoloc = GeoKit::Geocoders::GoogleGeocoder.geocode(params[:address])
      unless @geoloc.success
        invalid_address
        return
      end
    else
      invalid_address
      return
    end

    @letter = Letter.new(
      :sender_attributes => {
        :street     => @geoloc.street_address,
        :city       => @geoloc.city,
        :state      => @geoloc.state,
        :zip        => @geoloc.zip
      }
    )

    if @letter.sender.street.blank?
      invalid_address
      return
    end

    @letter.build_recipients(@geoloc)
  end

  private

  def invalid_address
    @address_error = 'Valid home address is required'
    render :template => 'home/index'
  end

  # Lifted from: http://wikibin.org/articles/list-of-the-addresses-of-fictional-characters.html
  def bogus_address?(address)
    bogus_addresses = [
      '1640 Riverside Drive Hill Valley, CA',
      '742 Evergreen Terrace Springfield, IM',
      '344 Washington St. Boston, MA',
      '185 West 74th Street, New York, NY',
      '711 Calhoun Street, Chicago, IL',
      '1060 West Addison Street, Chicago, IL',
      '4222 Clinton Way, Los Angeles, CA',
      '9764 Jeopardy Lane, Chicago, IL',
      '1000 Mammon Lane, Springfield, IM',
      '112 1/2 Beacon Street, Boston, MA',
      '420 Paper St. Wilmington, DE',
      '31 Spooner Street, Quahog, RI',
      '11435 18th Avenue, Oahu, HI',
      '2630 Hegal Place, Apt. 42, Alexandria, VA',
      '129 West 81st Street Apt 5E New York, NY',
      '88 Edgemont Drive, Palisades, CA',
      '633 Stag Trail Road North Caldwell, NJ',
      '1630 Revello Drive, Sunnydale, CA',
      '111 Archer Avenue, New York City, NY'
    ].include?(address)
  end

end
