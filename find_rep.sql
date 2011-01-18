select legislators.*
from (select * from federal_rep_districts where ST_CONTAINS(the_geom, PointFromText('POINT(-71.03 42.37)'))) as congress
join states on (cast(congress.state as integer) = states.fips)
join legislators on (legislators.state = states.code)
where ((legislators.title = 'Rep' and cast(legislators.district as integer) = cast(congress.cd as integer)) or (legislators.title = 'Sen'))
and legislators.in_office is true
