SELECT vp.partition_code, vp.vessel_name, vp.mmsi FROM vessel_profile vp, zone z, vessel v
  WHERE z.name = 'vra_wa'
  AND v.mmsi = vp.mmsi
  AND ST_Intersects(vp.agg_geog, z.geog)
  AND vp.vessel_name LIKE 'GNS%'
  AND v.flag_country = 'Ghana';
