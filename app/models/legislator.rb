class Legislator < ActiveRecord::Base
  set_primary_key :bioguide_id

  def self.search(geoloc)
    if geoloc.success
      Legislator.find_by_sql(<<-SQL)
select legislators.*
from legislators
where legislators.state = '#{geoloc.state}' and ((legislators.title != 'Sen' and (legislators.district = '0' or cast(legislators.district as integer) = cast((select cd from cd99_110 where ST_CONTAINS(the_geom, PointFromText('POINT(#{geoloc.lng} #{geoloc.lat})'))) as integer))) or (legislators.title = 'Sen'))
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
    "bioguides/#{bioguide_id}.jpg"
  end

  def envelope_text
    "#{name}\n#{congress_office}\nWashington, DC #{zip}"
  end

  def zip
    if title == 'Sen'
      '20510'
    else
      '20515'
    end
  end

end

