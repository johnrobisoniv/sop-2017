-- Global average speed of vessels "Under Way" grouped by type

SELECT	'120-199' AS length, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 120 AND 199
GROUP BY
	p.vessel_type

UNION ALL

SELECT	'200-299' AS length, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length BETWEEN 200 AND 299
GROUP BY
	p.vessel_type

UNION ALL

SELECT	'300+' AS length, p.vessel_type AS type, avg(p.sog) AS avg_speed
FROM	ping p
WHERE	nav_status_code = 0
AND	p.sog >= 5
AND	p.vessel_type_code BETWEEN 70 AND 89
AND	p.length >= 300
GROUP BY
	p.vessel_type
;
