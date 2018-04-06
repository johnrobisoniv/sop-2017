SELECT partition_code,
        COUNT(*) AS cnt_total,
        COUNT(CASE WHEN hit_reroute=TRUE THEN 1 ELSE NULL END) AS cnt_reroute,
        COUNT(CASE WHEN hit_alley=TRUE THEN 1 ELSE NULL END) AS cnt_alley,
        COUNT(CASE WHEN (hit_alley AND NOT hit_reroute)=TRUE THEN 1 ELSE NULL END) AS cnt_alley_ONLY,
        COUNT(CASE WHEN hit_coast=TRUE THEN 1 ELSE NULL END) AS cnt_coast
FROM (

        SELECT vp.*,
                ST_Intersects(vp.agg_geog, z_reroute.geog) as hit_reroute,
                ST_Intersects(vp.agg_geog, z_alley.geog) as hit_alley,
                ST_Intersects(vp.agg_geog, z_coast.geog) as hit_coast
        FROM vessel_profile vp
        LEFT OUTER JOIN zone z_red ON z_red.name='geog_red'
        LEFT OUTER JOIN zone z_goa ON z_goa.name='geog_goa'
        LEFT OUTER JOIN zone z_gnb ON z_gnb.name='geog_gulf&bay'
        LEFT OUTER JOIN zone z_reroute ON z_reroute.name='poly_reroute'
        LEFT OUTER JOIN zone z_alley ON z_alley.name='poly_alley'
        LEFT OUTER JOIN zone z_eior ON z_eior.name='box_eior'
        LEFT OUTER JOIN zone z_coast ON z_coast.name='geog_coast'

        WHERE   (ST_Intersects(vp.agg_geog, z_red.geog) OR ST_Intersects(vp.agg_geog, z_goa.geog))
        AND     ST_Intersects(vp.agg_geog, z_eior.geog)
        AND NOT ST_Intersects(vp.agg_geog, z_gnb.geog)
) AS sub
GROUP BY sub.partition_code
ORDER BY sub.partition_code ASC;
