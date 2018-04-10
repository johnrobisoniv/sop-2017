
SELECT vp.partition_code, vp.vessel_name, vp.mmsi FROM vessel_profile vp, zone z
  WHERE z.name = 'vra_wa'
  AND ST_Intersects(vp.agg_geog, z.geog)
  AND (
    vp.mmsi = 657620000
    OR vp.mmsi = 657919000
    OR vp.mmsi = 657129300
    OR vp.mmsi = 657129400
    );
