SELECT vp.partition_code, vp.vessel_name, vp.mmsi FROM vessel_profile vp, zone z
  WHERE z.name = 'vra_wa'
  AND ST_Intersects(vp.agg_geog, z.geog)
  AND
  (vp.mmsi = 657133000
  OR vp.mmsi = 657133100
  OR vp.mmsi = 657133200
  OR vp.mmsi = 657133300
  OR vp.mmsi = 657557000
  OR vp.mmsi = 657556000
  OR vp.mmsi = 657945000
  OR vp.mmsi = 518511000)
  ;
