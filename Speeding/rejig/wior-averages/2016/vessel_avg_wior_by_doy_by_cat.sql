SELECT doy, cat, COUNT(DISTINCT mmsi) as ct_vessels, AVG(sog) AS avg_sog, 
	AVG(actual_fur - opt_fur) AS avg_exc_fur FROM
  (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy, mmsi, vessel_name, 
    calc_group_custom(vessel_type_code, length) AS cat,
    sog, 
    calc_speed_optimum(vessel_type_code, length) AS spd_opt, 
    calc_fuel_usage(vessel_type_code, length, calc_speed_optimum(vessel_type_code, length)) AS opt_fur,
    calc_fuel_usage(vessel_type_code, length, sog) AS actual_fur
    
    FROM ping p, zone z
    WHERE vessel_type_code BETWEEN 70 AND 89
    AND length BETWEEN 120 AND 500
    AND p.nav_status_code = 0
    AND p.sog >= 5.0
    AND z.name = 'hra_ea_new'
    AND ST_Intersects(p.position_ts, z.geog)
  ) AS pings
    GROUP BY doy, cat
    ORDER BY doy;
