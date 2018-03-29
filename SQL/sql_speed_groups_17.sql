
-- Averages by group INSIDE HRA
SELECT	'120-199' AS length, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 120 AND 199
AND	ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type

UNION ALL

SELECT	'200-299' AS length, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 200 AND 299
AND	ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type

UNION ALL

SELECT	'300+' AS length, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length >= 300
AND	ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type
;

-- Averages by group OUTSIDE HRA
SELECT	'120-199' AS length, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 120 AND 199
AND	NOT ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type

UNION ALL

SELECT	'200-299' AS length, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 200 AND 299
AND	NOT ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type

UNION ALL

SELECT	'300+' AS length, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length >= 300
AND	NOT ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type
;

-----------------------

-- Monthly averages by group INSIDE HRA
SELECT	'120-199' AS length, date_trunc('month', p.ts_pos_utc) AS month, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 120 AND 199
AND	ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type, date_trunc('month', p.ts_pos_utc)

UNION ALL

SELECT	'200-299' AS length, date_trunc('month', p.ts_pos_utc) AS month, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 200 AND 299
AND	ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type, date_trunc('month', p.ts_pos_utc)

UNION ALL

SELECT	'300+' AS length, date_trunc('month', p.ts_pos_utc) AS month, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length >= 300
AND	ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type, date_trunc('month', p.ts_pos_utc)

ORDER BY
	p.length, p.vessel_type, date_trunc('month', p.ts_pos_utc)
;




-- Monthly averages by group OUTSIDE HRA
SELECT	'120-199' AS length, date_trunc('month', p.ts_pos_utc) AS month, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 120 AND 199
AND	NOT ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type, date_trunc('month', p.ts_pos_utc)

UNION ALL

SELECT	'200-299' AS length, date_trunc('month', p.ts_pos_utc) AS month, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 200 AND 299
AND	NOT ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type, date_trunc('month', p.ts_pos_utc)

UNION ALL

SELECT	'300+' AS length, date_trunc('month', p.ts_pos_utc) AS month, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length >= 300
AND	NOT ST_Intersects(p.position, z.geog)
GROUP BY
	p.vessel_type, date_trunc('month', p.ts_pos_utc)

ORDER BY
	p.length, p.vessel_type, date_trunc('month', p.ts_pos_utc)
;
