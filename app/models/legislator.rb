class Legislator < ActiveRecord::Base

  def self.search(address)
    geoloc = GeoKit::Geocoders::GoogleGeocoder.geocode(address)
    Legislator.find_by_sql(<<-SQL)
select legislators.*
from (select * from cd99_110 where ST_CONTAINS(the_geom, PointFromText('POINT(#{geoloc.lng} #{geoloc.lat})'))) as congress
join states on (cast(congress.state as integer) = states.fips)
join legislators on (legislators.state = states.code)
where ((legislators.title = 'Rep' and cast(legislators.district as integer) = cast(congress.cd as integer)) or (legislators.title = 'Sen'))
and legislators.in_office is true
    SQL
  end
end
