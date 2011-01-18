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
      end

      context 'default' do
        before do
          Legislator.stubs(:find_by_sql)
          Legislator.search(@geoloc)
        end

        it 'finds legislators by complex SQL query' do
          sql = <<-SQL
select legislators.*
from legislators
where legislators.state = 'AA' and ((legislators.title != 'Sen' and (legislators.district = '0' or cast(legislators.district as integer) = cast((select cd from federal_rep_districts where ST_CONTAINS(the_geom, PointFromText('POINT(456 123)'))) as integer))) or (legislators.title = 'Sen'))
and legislators.in_office is true
order by legislators.district DESC
          SQL

          Legislator.should have_received(:find_by_sql).with(sql)
        end
      end

      context 'for senators' do
        before do
          Legislator.stubs(:find_senators)
          Legislator.search_senators(@geoloc)
        end

        it 'finds senators in the given state' do
          Legislator.should have_received(:find_senators).with(@geoloc)
        end
      end

      context 'for representatives' do
        before do
          Legislator.stubs(:find_by_sql)
          Legislator.search_representatives(@geoloc)
        end

        it 'finds representatives in the given state' do
          sql = <<-SQL
select legislators.*
from legislators
where legislators.state = 'AA' and ((legislators.title != 'Sen' and (legislators.district = '0' or cast(legislators.district as integer) = cast((select cd from federal_rep_districts where ST_CONTAINS(the_geom, PointFromText('POINT(456 123)'))) as integer))))
and legislators.in_office is true
order by legislators.district DESC
          SQL
          Legislator.should have_received(:find_by_sql).with(sql)
        end
      end
    end

    context 'unseccessful search' do
      before do
        @geoloc.stubs(:success).returns(false)
        Geokit::Geocoders::GoogleGeocoder.stubs(:geocode).returns(@geoloc)
      end

      it 'returns false for default' do
        Legislator.search(@geoloc).should be_false
      end

      it 'returns false for senators' do
        Legislator.search_senators(@geoloc).should be_false
      end

      it 'returns false for representatives' do
        Legislator.search_representatives(@geoloc).should be_false
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
      @legislator.bioguide_image.should == 'bioguides/1234.jpg'
    end
  end

  describe '#evelope_text' do
    before do
      @legislator = Legislator.new(
        :firstname      => 'John',
        :lastname       => 'Doe',
        :congress_office => '2243 Rayburn House Office Building',
        :title           => 'Rep'
      )
    end

    it 'formats the address information for printing on the evelope' do
      @legislator.envelope_text.should == "Rep. John Doe\n2243 Rayburn House Office Building\nWashington, DC 20515"
    end
  end

  describe '#zip' do
    context 'Senators' do
      it { Legislator.new(:title => 'Sen').zip.should == '20510' }
    end
    context 'Represenatives' do
      it { Legislator.new(:title => 'Rep').zip.should == '20515' }
    end
    context 'Delegates' do
      it { Legislator.new(:title => 'Del').zip.should == '20515' }
    end
    context 'Resident Commissioner' do
      it { Legislator.new(:title => 'Com').zip.should == '20515' }
    end
  end
end

