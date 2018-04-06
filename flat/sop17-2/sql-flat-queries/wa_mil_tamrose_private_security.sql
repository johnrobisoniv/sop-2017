
SELECT vp.partition_code, vp.vessel_name, vp.mmsi FROM vessel_profile vp, zone z
  WHERE z.name = 'vra_wa'
  AND ST_Intersects(vp.agg_geog, z.geog)
  AND (vp.mmsi = 657100100
      OR vp.mmsi = 657126400
      OR vp.mmsi = 376496000
      OR vp.mmsi = 657109500
      OR vp.mmsi = 657109400)
      ;
