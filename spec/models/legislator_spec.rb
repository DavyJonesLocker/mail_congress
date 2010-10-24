require 'spec_helper'

describe Legislator do
  context 'Searching by location' do
    before do
      @geoloc  = Geokit::GeoLoc.new(
        :lat => 123,
        :lng => 456,
        :city => 'Some City',
        :state => 'AA',
        :street => '123 Main St.'
      )
    end

    context 'successful search' do
      before do
        @geoloc.stubs(:success).returns(true)
        Geokit::Geocoders::GoogleGeocoder.stubs(:geocode).returns(@geoloc)
        Legislator.stubs(:find_by_sql)
        Legislator.search(@geoloc)
      end

      it 'should find legislators by complex SQL query' do
        sql = <<-SQL
select legislators.*
from (select * from cd99_110 where ST_CONTAINS(the_geom, PointFromText('POINT(456 123)'))) as congress
join states on (cast(congress.state as integer) = states.fips)
join legislators on (legislators.state = states.code)
where ((legislators.title != 'Sen' and (legislators.district = '0' or cast(legislators.district as integer) = cast(congress.cd as integer))) or (legislators.title = 'Sen'))
and legislators.in_office is true
order by legislators.district DESC
        SQL

        Legislator.should have_received(:find_by_sql).with(sql)
      end
    end

    context 'unseccessful search' do
      before do
        @geoloc.stubs(:success).returns(false)
        Geokit::Geocoders::GoogleGeocoder.stubs(:geocode).returns(@geoloc)
      end

      it 'should return false' do
        Legislator.search(@geoloc).should be_false
      end
      
    end
  end

  describe 'name' do
    before do
      @legislator = Legislator.new(:title => 'Sen', :firstname => 'John', :lastname => 'Adams')
    end

    it 'should have the name of "Sen. John Adams"' do
      @legislator.name.should == 'Sen. John Adams'
    end
  end

  describe 'image' do
    before do
      @legislator = Legislator.new
      @legislator.stubs(:bioguide_id).returns(1234)
    end

    it 'should give a relative path to public/images for the proper bioguide image' do
      @legislator.bioguide_image.should == 'bioguide/1234.jpg'
    end
  end

end

