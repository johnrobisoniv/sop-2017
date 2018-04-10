-- Monthly averages by group OUTSIDE HRA
SELECT	'120-199' AS length, p.partition_code as pcode, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	p.nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 120 AND 199
AND NOT	ST_Intersects(p.position, z.geog)
GROUP BY
	type, pcode

UNION ALL

SELECT	'200-299' AS length, p.partition_code AS pcode, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	p.nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 200 AND 299
AND NOT	ST_Intersects(p.position, z.geog)
GROUP BY
	type, pcode

UNION ALL

SELECT	'300+' AS length, p.partition_code AS pcode, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
LEFT OUTER JOIN
	zone z ON (z.name = 'hra_ea_new')
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length >= 300
AND NOT	ST_Intersects(p.position, z.geog)
GROUP BY
	type, pcode

ORDER BY
	length, type, pcode
;
