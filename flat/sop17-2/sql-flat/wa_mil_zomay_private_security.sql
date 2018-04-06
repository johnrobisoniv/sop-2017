
SELECT vp.partition_code, vp.vessel_name, vp.mmsi FROM vessel_profile vp, zone z
  WHERE z.name = 'vra_wa'
  AND ST_Intersects(vp.agg_geog, z.geog)
  AND (vp.mmsi = 657115600
      OR vp.mmsi = 657115500
      OR vp.mmsi = 657635000
      OR vp.mmsi = 657125000
      OR vp.mmsi = 657124900)

  ;
