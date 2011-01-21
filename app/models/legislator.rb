class Legislator < ActiveRecord::Base
  self.inheritance_column = 'other_type'

  def self.search(geoloc, options = {})
    if geoloc.success
      select('DISTINCT legislators.*').
      from("legislators, (SELECT district, level, type FROM districts WHERE ST_CONTAINS(the_geom, PointFromText('POINT(#{geoloc.lng} #{geoloc.lat})'))) AS districts").
      where(conditions(geoloc, options) &
        {:districts => [
           :district => arel_table[:district],
           :level    => arel_table[:level],
           :type     => arel_table[:type]]}).
      order(:level.asc, :type.desc, :senate_class.desc)
    else
      nil
    end
  end

  def name
    "#{title}. #{firstname} #{lastname}"
  end

  def bioguide_image
    "bioguides/#{level}/#{bioguide_id}.jpg"
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

  private

  def self.conditions(geoloc, options)
    options.merge(:state => geoloc.state, :in_office => true)
  end

end

