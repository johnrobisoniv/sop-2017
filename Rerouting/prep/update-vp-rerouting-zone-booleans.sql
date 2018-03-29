UPDATE rerouting_vp_wior
SET reroute_hit = 1
FROM rerouting_vp_wior vp, zone z
  WHERE z.name = 'poly_reroute'
  AND ST_Intersects(vp.agg_geog, z.geog);
