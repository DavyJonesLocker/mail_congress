class Legislator < ActiveRecord::Base
  set_primary_key :bioguide_id

  def self.search(geoloc)
    if geoloc.success
      Legislator.find_by_sql(<<-SQL)
select legislators.*
from (select * from cd99_110 where ST_CONTAINS(the_geom, PointFromText('POINT(#{geoloc.lng} #{geoloc.lat})'))) as congress
join states on (cast(congress.state as integer) = states.fips)
join legislators on (legislators.state = states.code)
where ((legislators.title != 'Sen' and (legislators.district = '0' or cast(legislators.district as integer) = cast(congress.cd as integer))) or (legislators.title = 'Sen'))
and legislators.in_office is true
order by legislators.district DESC
      SQL
    else
      false
    end
  end

  def name
    "#{title}. #{firstname} #{lastname}"
  end

  def bioguide_image
    "bioguide/#{bioguide_id}.jpg"
  end

end

