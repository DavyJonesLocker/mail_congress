require 'spec_helper'

describe Legislator do

  context 'Searching by location' do
    before do
      @geoloc  = Geokit::GeoLoc.new(
        :lat => 123,
        :lng => 456,
        :city => 'Some City',
        :state => 'MA',
        :street => '123 Main St.'
      )
    end

    context 'successful search' do
      before do
        @geoloc.stubs(:success).returns(true)
        Geokit::Geocoders::GoogleGeocoder.stubs(:geocode).returns(@geoloc)
      end

      context 'all' do
        it 'queries' do
          sql = %{SELECT DISTINCT legislators.* FROM legislators, (SELECT district, level, type FROM districts WHERE ST_CONTAINS(the_geom, PointFromText('POINT(456 123)'))) AS districts WHERE ("legislators"."state" = 'MA' AND "legislators"."in_office" = 't') AND ("districts"."district" = "legislators"."district" AND "districts"."level" = "legislators"."level" AND "districts"."type" = "legislators"."type") ORDER BY "legislators"."level" ASC, "legislators"."type" DESC, "legislators"."senate_class" DESC}
          Legislator.search(@geoloc).to_sql.should == sql
        end
      end

      context 'federal' do
        context 'all' do
          it 'queries' do
          sql = %{SELECT DISTINCT legislators.* FROM legislators, (SELECT district, level, type FROM districts WHERE ST_CONTAINS(the_geom, PointFromText('POINT(456 123)'))) AS districts WHERE ("legislators"."level" = 'federal' AND "legislators"."state" = 'MA' AND "legislators"."in_office" = 't') AND ("districts"."district" = "legislators"."district" AND "districts"."level" = "legislators"."level" AND "districts"."type" = "legislators"."type") ORDER BY "legislators"."level" ASC, "legislators"."type" DESC, "legislators"."senate_class" DESC}
            Legislator.search(@geoloc, :level => 'federal').to_sql.should == sql
          end
        end

        context 'House' do
          it 'queries' do
          sql = %{SELECT DISTINCT legislators.* FROM legislators, (SELECT district, level, type FROM districts WHERE ST_CONTAINS(the_geom, PointFromText('POINT(456 123)'))) AS districts WHERE ("legislators"."level" = 'federal' AND "legislators"."type" = 'house' AND "legislators"."state" = 'MA' AND "legislators"."in_office" = 't') AND ("districts"."district" = "legislators"."district" AND "districts"."level" = "legislators"."level" AND "districts"."type" = "legislators"."type") ORDER BY "legislators"."level" ASC, "legislators"."type" DESC, "legislators"."senate_class" DESC}
            Legislator.search(@geoloc, :level => 'federal', :type => 'house').to_sql.should == sql
          end
        end

        context 'Senate' do
          it 'queries' do
          sql = %{SELECT DISTINCT legislators.* FROM legislators, (SELECT district, level, type FROM districts WHERE ST_CONTAINS(the_geom, PointFromText('POINT(456 123)'))) AS districts WHERE ("legislators"."level" = 'federal' AND "legislators"."type" = 'senate' AND "legislators"."state" = 'MA' AND "legislators"."in_office" = 't') AND ("districts"."district" = "legislators"."district" AND "districts"."level" = "legislators"."level" AND "districts"."type" = "legislators"."type") ORDER BY "legislators"."level" ASC, "legislators"."type" DESC, "legislators"."senate_class" DESC}
            Legislator.search(@geoloc, :level => 'federal', :type => 'senate').to_sql.should == sql
          end
        end
      end

      context 'state' do
        context 'all' do
          it 'queries' do
          sql = %{SELECT DISTINCT legislators.* FROM legislators, (SELECT district, level, type FROM districts WHERE ST_CONTAINS(the_geom, PointFromText('POINT(456 123)'))) AS districts WHERE ("legislators"."level" = 'state' AND "legislators"."state" = 'MA' AND "legislators"."in_office" = 't') AND ("districts"."district" = "legislators"."district" AND "districts"."level" = "legislators"."level" AND "districts"."type" = "legislators"."type") ORDER BY "legislators"."level" ASC, "legislators"."type" DESC, "legislators"."senate_class" DESC}
            Legislator.search(@geoloc, :level => 'state').to_sql.should == sql
          end
        end

        context 'House' do
          it 'queries' do
          sql = %{SELECT DISTINCT legislators.* FROM legislators, (SELECT district, level, type FROM districts WHERE ST_CONTAINS(the_geom, PointFromText('POINT(456 123)'))) AS districts WHERE ("legislators"."level" = 'state' AND "legislators"."type" = 'house' AND "legislators"."state" = 'MA' AND "legislators"."in_office" = 't') AND ("districts"."district" = "legislators"."district" AND "districts"."level" = "legislators"."level" AND "districts"."type" = "legislators"."type") ORDER BY "legislators"."level" ASC, "legislators"."type" DESC, "legislators"."senate_class" DESC}
            Legislator.search(@geoloc, :level => 'state', :type => 'house').to_sql.should == sql
          end
        end

        context 'Senate' do
          it 'queries' do
          sql = %{SELECT DISTINCT legislators.* FROM legislators, (SELECT district, level, type FROM districts WHERE ST_CONTAINS(the_geom, PointFromText('POINT(456 123)'))) AS districts WHERE ("legislators"."level" = 'state' AND "legislators"."type" = 'senate' AND "legislators"."state" = 'MA' AND "legislators"."in_office" = 't') AND ("districts"."district" = "legislators"."district" AND "districts"."level" = "legislators"."level" AND "districts"."type" = "legislators"."type") ORDER BY "legislators"."level" ASC, "legislators"."type" DESC, "legislators"."senate_class" DESC}
            Legislator.search(@geoloc, :level => 'state', :type => 'senate').to_sql.should == sql
          end
        end
      end

      context 'unseccessful search' do
        before do
          @geoloc.stubs(:success).returns(false)
          Geokit::Geocoders::GoogleGeocoder.stubs(:geocode).returns(@geoloc)
        end

        it 'returns false for default' do
          Legislator.search(@geoloc).should be_nil
        end

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

    context 'monkey' do
      before { @legislator.stubs(:level).returns('monkey') }
      it 'should give a relative path to public/images for the proper bioguide image' do
        @legislator.bioguide_image.should == 'bioguides/monkey/1234.jpg'
      end
    end

  end

  describe '#evelope_text' do
    before do
      @legislator = Legislator.new(
        :firstname       => 'John',
        :lastname        => 'Doe',
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

