
CREATE TABLE vessel_profile_monthly (
	month		TEXT NOT NULL,
	mmsi		INTEGER NOT NULL,
	vessel_name	TEXT NOT NULL,
	ping_count	INTEGER NOT NULL DEFAULT -1,
	agg_geog	GEOGRAPHY NOT NULL,

	PRIMARY KEY (month, mmsi, vessel_name)
);


INSERT INTO arcgis.vessel_profile_monthly(
	month, mmsi, vessel_name, ping_count, agg_geog)
SELECT DISTINCT ON (month, p.mmsi, p.vessel_name)
	date_trunc('month', p.ts_pos_utc) AS month,
	p.mmsi, p.vessel_name,
	count(*) AS ping_count,
	ST_Collect(p.position::geometry ORDER BY p.ts_pos_utc ASC)::geography AS agg_geog
FROM ping p
GROUP BY month, p.mmsi, p.vessel_name;

[Query returned successfully: 893518 rows affected, 86248 ms execution time.]





SELECT month,
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
	FROM vessel_profile_monthly vp
	LEFT OUTER JOIN zone z_red ON z_red.name='geog_red'
	LEFT OUTER JOIN zone z_goa ON z_goa.name='geog_goa'
	LEFT OUTER JOIN zone z_gnb ON z_gnb.name='geog_gulf&bay'
	LEFT OUTER JOIN zone z_reroute ON z_reroute.name='poly_reroute'
	LEFT OUTER JOIN zone z_alley ON z_alley.name='poly_alley'
	LEFT OUTER JOIN zone z_eior ON z_eior.name='box_eior'
	LEFT OUTER JOIN zone z_coast ON z_coast.name='geog_coast'

	WHERE	(ST_Intersects(vp.agg_geog, z_red.geog) OR ST_Intersects(vp.agg_geog, z_goa.geog))
	AND	ST_Intersects(vp.agg_geog, z_eior.geog)
	AND NOT	ST_Intersects(vp.agg_geog, z_gnb.geog)
) AS sub
GROUP BY sub.month
ORDER BY sub.month ASC;


SELECT sub.month, sub.mmsi, sub.vessel_name,
	v.vessel_type, v.vessel_type_code, v.length, v.flag_country,
	sub.hit_reroute, sub.hit_alley, sub.hit_coast,
	sub.agg_geog
FROM (

	SELECT vp.*,
		ST_Intersects(vp.agg_geog, z_reroute.geog) as hit_reroute,
		ST_Intersects(vp.agg_geog, z_alley.geog) as hit_alley,
		ST_Intersects(vp.agg_geog, z_coast.geog) as hit_coast
	FROM vessel_profile_monthly vp
	LEFT OUTER JOIN zone z_red ON z_red.name='geog_red'
	LEFT OUTER JOIN zone z_goa ON z_goa.name='geog_goa'
	LEFT OUTER JOIN zone z_gnb ON z_gnb.name='geog_gulf&bay'
	LEFT OUTER JOIN zone z_reroute ON z_reroute.name='poly_reroute'
	LEFT OUTER JOIN zone z_alley ON z_alley.name='poly_alley'
	LEFT OUTER JOIN zone z_eior ON z_eior.name='box_eior'
	LEFT OUTER JOIN zone z_coast ON z_coast.name='geog_coast'

	WHERE	(ST_Intersects(vp.agg_geog, z_red.geog) OR ST_Intersects(vp.agg_geog, z_goa.geog))
	AND	ST_Intersects(vp.agg_geog, z_eior.geog)
	AND NOT	ST_Intersects(vp.agg_geog, z_gnb.geog)
) AS sub
LEFT OUTER JOIN vessel v on (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name)
WHERE sub.hit_reroute
ORDER BY sub.month ASC, v.flag_country ASC, sub.mmsi, sub.vessel_name
;



pgsql2shp -f "C:/custom/pg_exports/rerouters_monthly" -h localhost -u arcgis -P postgres -g agg_geog shipview_beta "SELECT sub.month, sub.mmsi, sub.vessel_name, v.vessel_type, v.vessel_type_code, v.length, v.flag_country, sub.hit_reroute, sub.hit_alley, sub.hit_coast, sub.agg_geog FROM ( SELECT vp.*, ST_Intersects(vp.agg_geog, z_reroute.geog) as hit_reroute, ST_Intersects(vp.agg_geog, z_alley.geog) as hit_alley, ST_Intersects(vp.agg_geog, z_coast.geog) as hit_coast FROM vessel_profile_monthly vp LEFT OUTER JOIN zone z_red ON z_red.name='geog_red' LEFT OUTER JOIN zone z_goa ON z_goa.name='geog_goa' LEFT OUTER JOIN zone z_gnb ON z_gnb.name='geog_gulf&bay' LEFT OUTER JOIN zone z_reroute ON z_reroute.name='poly_reroute' LEFT OUTER JOIN zone z_alley ON z_alley.name='poly_alley' LEFT OUTER JOIN zone z_eior ON z_eior.name='box_eior' LEFT OUTER JOIN zone z_coast ON z_coast.name='geog_coast' WHERE (ST_Intersects(vp.agg_geog, z_red.geog) OR ST_Intersects(vp.agg_geog, z_goa.geog)) AND ST_Intersects(vp.agg_geog, z_eior.geog) AND NOT ST_Intersects(vp.agg_geog, z_gnb.geog) ) AS sub LEFT OUTER JOIN vessel v on (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name) WHERE sub.hit_reroute ORDER BY sub.month ASC, v.flag_country ASC, sub.mmsi, sub.vessel_name;"


----------------

PG reroute

SELECT sub.month, sub.mmsi, sub.vessel_name,
	v.vessel_type, v.vessel_type_code, v.length, v.flag_country,
	sub.hit_arabian,
	sub.agg_geog
FROM (

	SELECT vp.*,
		ST_Intersects(vp.agg_geog, z_arabian.geog) as hit_arabian
	FROM vessel_profile_monthly vp
	LEFT OUTER JOIN zone z_gnb ON z_gnb.name='geog_gulf&bay'
	LEFT OUTER JOIN zone z_eior ON z_eior.name='box_eior'
	LEFT OUTER JOIN zone z_coast ON z_coast.name='geog_coast'
	LEFT OUTER JOIN zone z_arabian ON z_arabian.name='poly_arabian'

	WHERE	ST_Intersects(vp.agg_geog, z_gnb.geog)
	AND	ST_Intersects(vp.agg_geog, z_eior.geog)
	AND NOT	ST_Intersects(vp.agg_geog, z_coast.geog)
) AS sub
LEFT OUTER JOIN vessel v on (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name)
ORDER BY sub.month ASC, v.flag_country ASC, sub.mmsi, sub.vessel_name
;

pgsql2shp -f "C:/custom/pg_exports/rerouters_monthly_persian" -h localhost -u arcgis -P postgres -g agg_geog shipview_beta "SELECT sub.month, sub.mmsi, sub.vessel_name, v.vessel_type, v.vessel_type_code, v.length, v.flag_country, sub.hit_arabian, sub.agg_geog FROM (SELECT vp.*, ST_Intersects(vp.agg_geog, z_arabian.geog) as hit_arabian FROM vessel_profile_monthly vp LEFT OUTER JOIN zone z_gnb ON z_gnb.name='geog_gulf&bay' LEFT OUTER JOIN zone z_eior ON z_eior.name='box_eior' LEFT OUTER JOIN zone z_coast ON z_coast.name='geog_coast' LEFT OUTER JOIN zone z_arabian ON z_arabian.name='poly_arabian' WHERE ST_Intersects(vp.agg_geog, z_gnb.geog) AND ST_Intersects(vp.agg_geog, z_eior.geog) AND NOT ST_Intersects(vp.agg_geog, z_coast.geog) ) AS sub LEFT OUTER JOIN vessel v on (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name) ORDER BY sub.month ASC, v.flag_country ASC, sub.mmsi, sub.vessel_name;"

----------------

PG reroute with heading breakdown

SELECT sub.*, v.vessel_type, v.vessel_type_code, v.length, v.flag_country FROM (
	SELECT DISTINCT ON (month, p.mmsi, p.vessel_name)
		'SE'::text AS heading,
		date_trunc('month', p.ts_pos_utc) AS month,
		p.mmsi, p.vessel_name,
		count(*) AS ping_count,
		ST_Collect(p.position::geometry ORDER BY p.ts_pos_utc ASC)::geography AS agg_geog
	FROM ping p
	WHERE p.cog BETWEEN 45 AND 225
	GROUP BY month, p.mmsi, p.vessel_name
) AS sub
LEFT OUTER JOIN vessel v ON (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name)
WHERE sub.ping_count > 3
AND v.length >= 120

UNION ALL

SELECT sub.*, v.vessel_type, v.vessel_type_code, v.length, v.flag_country FROM (
	SELECT DISTINCT ON (month, p.mmsi, p.vessel_name)
		'NW'::text AS heading,
		date_trunc('month', p.ts_pos_utc) AS month,
		p.mmsi, p.vessel_name,
		count(*) AS ping_count,
		ST_Collect(p.position::geometry ORDER BY p.ts_pos_utc ASC)::geography AS agg_geog
	FROM ping p
	WHERE p.cog NOT BETWEEN 45 AND 225
	GROUP BY month, p.mmsi, p.vessel_name
) AS sub
LEFT OUTER JOIN vessel v ON (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name)
WHERE sub.ping_count > 3
AND v.length >= 120

ORDER BY month, flag_country, vessel_type, mmsi, vessel_name, heading
;

pgsql2shp -f "C:/custom/pg_exports/rerouters_monthly_persian_heading" -h localhost -u arcgis -P postgres -g agg_geog shipview_beta "SELECT sub.*, v.vessel_type, v.vessel_type_code, v.length, v.flag_country FROM (SELECT DISTINCT ON (month, p.mmsi, p.vessel_name) 'SE'::text AS heading, date_trunc('month', p.ts_pos_utc) AS month, p.mmsi, p.vessel_name, count(*) AS ping_count, ST_Collect(p.position::geometry ORDER BY p.ts_pos_utc ASC)::geography AS agg_geog FROM ping p WHERE p.cog BETWEEN 45 AND 225 GROUP BY month, p.mmsi, p.vessel_name) AS sub LEFT OUTER JOIN vessel v ON (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name) WHERE sub.ping_count > 9 AND v.length >= 120 UNION ALL SELECT sub.*, v.vessel_type, v.vessel_type_code, v.length, v.flag_country FROM (SELECT DISTINCT ON (month, p.mmsi, p.vessel_name) 'NW'::text AS heading, date_trunc('month', p.ts_pos_utc) AS month, p.mmsi, p.vessel_name, count(*) AS ping_count, ST_Collect(p.position::geometry ORDER BY p.ts_pos_utc ASC)::geography AS agg_geog FROM ping p WHERE p.cog NOT BETWEEN 45 AND 225 GROUP BY month, p.mmsi, p.vessel_name) AS sub LEFT OUTER JOIN vessel v ON (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name) WHERE sub.ping_count > 9 AND v.length >= 120 ORDER BY month, flag_country, vessel_type, mmsi, vessel_name, heading;"

maybe actually better disaggregated...

SELECT sub.*, v.vessel_type, v.vessel_type_code, v.length, v.flag_country, ST_Intersects(z_arabian.geog, sub.agg_geog) AS hit_reroute FROM (
	SELECT DISTINCT ON (month, p.mmsi, p.vessel_name)
		'NW'::text AS heading,
		date_trunc('month', p.ts_pos_utc) AS month,
		p.mmsi, p.vessel_name,
		count(*) AS ping_count,
		ST_Collect(p.position::geometry ORDER BY p.ts_pos_utc ASC)::geography AS agg_geog
	FROM ping p
	WHERE p.cog NOT BETWEEN 45 AND 225
	GROUP BY month, p.mmsi, p.vessel_name
) AS sub
LEFT OUTER JOIN vessel v ON (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name)
LEFT OUTER JOIN zone z_gnb ON z_gnb.name='geog_gulf&bay'
LEFT OUTER JOIN zone z_eior ON z_eior.name='box_eior'
LEFT OUTER JOIN zone z_coast ON z_coast.name='geog_coast'
LEFT OUTER JOIN zone z_arabian ON z_arabian.name='poly_arabian'

WHERE sub.ping_count > 9
AND v.length >= 120
AND	ST_Intersects(sub.agg_geog, z_gnb.geog)
AND	ST_Intersects(sub.agg_geog, z_eior.geog)
AND NOT	ST_Intersects(sub.agg_geog, z_coast.geog)

ORDER BY month, flag_country, vessel_type, mmsi, vessel_name


pgsql2shp -f "C:/custom/pg_exports/rerouters_monthly_persian_nw" -h localhost -u arcgis -P postgres -g agg_geog shipview_beta "SELECT sub.*, v.vessel_type, v.vessel_type_code, v.length, v.flag_country, ST_Intersects(z_arabian.geog, sub.agg_geog) AS hit_reroute FROM (SELECT DISTINCT ON (month, p.mmsi, p.vessel_name) 'NW'::text AS heading, date_trunc('month', p.ts_pos_utc) AS month, p.mmsi, p.vessel_name, count(*) AS ping_count, ST_Collect(p.position::geometry ORDER BY p.ts_pos_utc ASC)::geography AS agg_geog FROM ping p WHERE p.cog NOT BETWEEN 45 AND 225 GROUP BY month, p.mmsi, p.vessel_name) AS sub LEFT OUTER JOIN vessel v ON (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name) LEFT OUTER JOIN zone z_gnb ON z_gnb.name='geog_gulf&bay' LEFT OUTER JOIN zone z_eior ON z_eior.name='box_eior' LEFT OUTER JOIN zone z_coast ON z_coast.name='geog_coast' LEFT OUTER JOIN zone z_arabian ON z_arabian.name='poly_arabian' WHERE sub.ping_count > 9 AND v.length >= 120 AND ST_Intersects(sub.agg_geog, z_gnb.geog) AND ST_Intersects(sub.agg_geog, z_eior.geog) AND NOT ST_Intersects(sub.agg_geog, z_coast.geog) ORDER BY month, flag_country, vessel_type, mmsi, vessel_name;"

pgsql2shp -f "C:/custom/pg_exports/rerouters_monthly_persian_se" -h localhost -u arcgis -P postgres -g agg_geog shipview_beta "SELECT sub.*, v.vessel_type, v.vessel_type_code, v.length, v.flag_country, ST_Intersects(z_arabian.geog, sub.agg_geog) AS hit_reroute FROM (SELECT DISTINCT ON (month, p.mmsi, p.vessel_name) 'SE'::text AS heading, date_trunc('month', p.ts_pos_utc) AS month, p.mmsi, p.vessel_name, count(*) AS ping_count, ST_Collect(p.position::geometry ORDER BY p.ts_pos_utc ASC)::geography AS agg_geog FROM ping p WHERE p.cog BETWEEN 45 AND 225 GROUP BY month, p.mmsi, p.vessel_name) AS sub LEFT OUTER JOIN vessel v ON (v.mmsi=sub.mmsi AND v.vessel_name=sub.vessel_name) LEFT OUTER JOIN zone z_gnb ON z_gnb.name='geog_gulf&bay' LEFT OUTER JOIN zone z_eior ON z_eior.name='box_eior' LEFT OUTER JOIN zone z_coast ON z_coast.name='geog_coast' LEFT OUTER JOIN zone z_arabian ON z_arabian.name='poly_arabian' WHERE sub.ping_count > 9 AND v.length >= 120 AND ST_Intersects(sub.agg_geog, z_gnb.geog) AND ST_Intersects(sub.agg_geog, z_eior.geog) AND NOT ST_Intersects(sub.agg_geog, z_coast.geog) ORDER BY month, flag_country, vessel_type, mmsi, vessel_name;"
