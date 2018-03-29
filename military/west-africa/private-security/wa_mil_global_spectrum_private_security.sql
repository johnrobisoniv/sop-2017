
SELECT vp.partition_code, vp.vessel_name, vp.mmsi FROM vessel_profile vp, zone z
  WHERE z.name = 'vra_wa'
  AND ST_Intersects(vp.agg_geog, z.geog)
  AND (vp.mmsi = 434114300
      OR vp.mmsi = 657847000
      OR vp.mmsi = 657105500);
