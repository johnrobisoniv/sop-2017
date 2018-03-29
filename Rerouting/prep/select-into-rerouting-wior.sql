SELECT * INTO rerouting FROM ping p, zone z
    WHERE (z.name = 'region_ea' OR z.name = 'box_eior')
    AND ST_Intersects(p.position, z.geog);
