SELECT partition_code, COUNT(DISTINCT mmsi) FROM vessel_profile 
	WHERE in_wra_wa = 'true' 
	GROUP BY partition_code
	ORDER BY partition_code;
