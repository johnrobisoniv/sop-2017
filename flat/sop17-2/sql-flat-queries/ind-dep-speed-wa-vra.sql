SELECT vp.partition_code, vp.mmsi, vp.vessel_name, p.flag_country
FROM wa_vessel_profile_vra vp, ping p
WHERE vp.mmsi = p.mmsi AND vp.partition_code = p.partition_code
AND (vessel_type LIKE '%Military%' OR p.vessel_type LIKE '%Law%Enforcement%')
AND p.sog > 1
GROUP BY vp.partition_code, vp.mmsi, vp.vessel_name, p.flag_country
ORDER BY vp.partition_code, vp.mmsi;
