
SELECT vp.partition_code, vp.vessel_name, vp.mmsi FROM vessel_profile vp, zone z
  WHERE z.name = 'vra_wa'
  AND ST_Intersects(vp.agg_geog, z.geog)
  AND (
    vp.mmsi = 657111001
    OR vp.mmsi = 657111115
    OR vp.mmsi = 667001473
    OR vp.mmsi = 667001474
    );
