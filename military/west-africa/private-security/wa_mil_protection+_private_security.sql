

SELECT vp.partition_code, vp.vessel_name, vp.mmsi FROM vessel_profile vp, zone z
  WHERE z.name = 'vra_wa'
  AND ST_Intersects(vp.agg_geog, z.geog)
  AND
(vp.mmsi = 657123000
OR vp.mmsi = 657127200
OR vp.mmsi = 657107100
OR vp.mmsi = 657327000);
