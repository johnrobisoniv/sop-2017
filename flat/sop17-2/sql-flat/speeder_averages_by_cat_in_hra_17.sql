
-- Average speed, count, and fuel usage within EA HRA '17
SELECT cat, count(*),
	avg(sog_avg) AS cat_sog_avg,
	avg(spd_dif_avg) AS cat_spd_dif_avg,
	avg(fu_exc_avg) AS cat_fu_exc_avg
FROM (
	SELECT mmsi, vessel_name, cat,
		avg(sog) AS sog_avg,
		avg(spd_dif) AS spd_dif_avg,
		avg(fu_exc) AS fu_exc_avg,
		ST_Collect(pings.position::geometry ORDER BY pings.ts_pos_utc)::geography AS agg_geog
	FROM (
		SELECT p.mmsi, p.vessel_name, vessels.vessel_type, vessels.vessel_type_code, vessels.length, vessels.weight, vessels.cat,
			p.position, p.sog, p.nav_status_code, p.ts_pos_utc,
			vessels.spd_opt, vessels.spd_buf, vessels.spd_thr,
			(p.sog - vessels.spd_opt) AS spd_dif,
			vessels.fu_opt,
			calc_fuel_usage(vessels.vessel_type_code, vessels.length, p.sog) AS fu_act,
			calc_fuel_usage(vessels.vessel_type_code, vessels.length, p.sog) - vessels.fu_opt AS fu_exc
		FROM
		(
			SELECT inside.*, calc_fuel_usage(inside.vessel_type_code, inside.length, inside.spd_opt) AS fu_opt
			FROM (
				SELECT DISTINCT ON (p.mmsi, p.vessel_name)
					p.mmsi, p.vessel_name, p.vessel_type, p.vessel_type_code, p.length,
					calc_speed_optimum(p.vessel_type_code, p.length) AS spd_opt,
					calc_speed_buffer(p.vessel_type_code, p.length) AS spd_buf,
					calc_speed_threshold(p.vessel_type_code, p.length) AS spd_thr,
					calc_weight(p.vessel_type_code, p.length) AS weight,
					calc_group_custom(p.vessel_type_code, p.length) AS cat,
					z_hra.geog
				FROM ping p
				LEFT OUTER JOIN zone z_hra ON z_hra.name='hra_ea_new'
				WHERE p.vessel_type_code BETWEEN 70 AND 89
				AND p.length >= 120
				AND ST_Intersects(p.position, z_hra.geog)
				AND p.sog > calc_speed_threshold(p.vessel_type_code, p.length)
			) AS inside
		) AS vessels
		INNER JOIN ping p ON (p.mmsi=vessels.mmsi AND p.vessel_name=vessels.vessel_name)
		WHERE p.nav_status_code = 0
		AND p.sog >= 5.0
		AND ST_Intersects(p.position, vessels.geog)
		ORDER BY p.mmsi, p.vessel_name, p.ts_pos_utc
	) AS pings
	GROUP BY mmsi, vessel_name, cat
) AS v_avgs
GROUP BY cat
ORDER BY cat;
