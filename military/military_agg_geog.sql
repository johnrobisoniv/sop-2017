SELECT agg_geog FROM vessel_profile vp, vessel v 
	WHERE v.mmsi = vp.mmsi
    AND (vessel_type = 'Military' OR vessel_type = 'Law Enforcement');
