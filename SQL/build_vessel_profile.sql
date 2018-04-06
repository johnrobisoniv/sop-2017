INSERT INTO vessel_profile (
	partition_code, mmsi, vessel_name, ping_count, agg_geog, agg_geog_ts,
	centroid, hull,
	in_region_wa, in_region_ea, in_region_sea,
	in_vra_wa, in_vra_ea, in_vra_sea,
	in_wra_wa, in_wra_ea, in_wra_sea,
	in_hra_ea_old, in_hra_ea_old_nowedge, in_hra_ea_new,
	in_ibf_woa_ea, in_ibf_xrz_ea, in_ibf_hra_wa, in_ibf_hra_ea,
	in_aoi_sea,
	in_jcc_wa, in_jcc_ea, in_jcc_sea,
	in_atalanta_red, in_atalanta_goa, in_atalanta_somali,
	in_atalanta_south, in_atalanta_north, in_atalanta_indian,
	in_irtc_east, in_irtc_west,
	in_strait_malacca, in_strait_singapore, in_strait_sunda,
	in_bgd_vicinity,
	in_nga_naa, in_nga_la, in_nga_sts, in_nga_saa, in_nga_saa_mez,
	in_ben_1_storage, in_ben_2_tanker, in_ben_3_tanker, in_ben_4_sts,
	in_tgo_waiting, in_tgo_berthing,
	in_gha_anchorage, in_gha_sts,
	range
	)
SELECT 	sub.*, 
	ST_Centroid(sub.agg_geog::geometry) AS centroid,
	ST_ConvexHull(sub.agg_geog::geometry) AS hull, 
	ST_Intersects(sub.agg_geog, z_region_wa.geog) AS in_region_wa,
	ST_Intersects(sub.agg_geog, z_region_ea.geog) AS in_region_ea,
	ST_Intersects(sub.agg_geog, z_region_sea.geog) AS in_region_sea,
	ST_Intersects(sub.agg_geog, z_vra_wa.geog) AS in_vra_wa,
	ST_Intersects(sub.agg_geog, z_vra_ea.geog) AS in_vra_ea,
	ST_Intersects(sub.agg_geog, z_vra_sea.geog) AS in_vra_sea,
	ST_Intersects(sub.agg_geog, z_wra_wa.geog) AS in_wra_wa,
	ST_Intersects(sub.agg_geog, z_wra_ea.geog) AS in_wra_ea,
	ST_Intersects(sub.agg_geog, z_wra_sea.geog) AS in_wra_sea,
	ST_Intersects(sub.agg_geog, z_hra_ea_old.geog) AS in_hra_ea_old,
	ST_Intersects(sub.agg_geog, z_hra_ea_old_nowedge.geog) AS in_hra_ea_old_nowedge,
	ST_Intersects(sub.agg_geog, z_hra_ea_new.geog) AS in_hra_ea_new,
	ST_Intersects(sub.agg_geog, z_ibf_woa_ea.geog) AS in_ibf_woa_ea,
	ST_Intersects(sub.agg_geog, z_ibf_xrz_ea.geog) AS in_ibf_xrz_ea,
	ST_Intersects(sub.agg_geog, z_ibf_hra_wa.geog) AS in_ibf_hra_wa,
	ST_Intersects(sub.agg_geog, z_ibf_hra_ea.geog) AS in_ibf_hra_ea,
	ST_Intersects(sub.agg_geog, z_aoi_sea.geog) AS in_aoi_sea,
	ST_Intersects(sub.agg_geog, z_jcc_wa.geog) AS in_jcc_wa,
	ST_Intersects(sub.agg_geog, z_jcc_ea.geog) AS in_jcc_ea,
	ST_Intersects(sub.agg_geog, z_jcc_sea.geog) AS in_jcc_sea,
	ST_Intersects(sub.agg_geog, z_atalanta_red.geog) AS in_atalanta_red,
	ST_Intersects(sub.agg_geog, z_atalanta_goa.geog) AS in_atalanta_goa,
	ST_Intersects(sub.agg_geog, z_atalanta_somali.geog) AS in_atalanta_somali,
	ST_Intersects(sub.agg_geog, z_atalanta_south.geog) AS in_atalanta_south,
	ST_Intersects(sub.agg_geog, z_atalanta_north.geog) AS in_atalanta_north,
	ST_Intersects(sub.agg_geog, z_atalanta_indian.geog) AS in_atalanta_indian,
	ST_Intersects(sub.agg_geog, z_irtc_east.geog) AS in_irtc_east,
	ST_Intersects(sub.agg_geog, z_irtc_west.geog) AS in_irtc_west,
	ST_Intersects(sub.agg_geog, z_strait_malacca.geog) AS in_strait_malacca,
	ST_Intersects(sub.agg_geog, z_strait_singapore.geog) AS in_strait_singapore,
	ST_Intersects(sub.agg_geog, z_strait_sunda.geog) AS in_strait_sunda,
	ST_Intersects(sub.agg_geog, z_bgd_vicinity.geog) AS in_bgd_vicinity,
	ST_Intersects(sub.agg_geog, z_nga_naa.geog) AS in_nga_naa,
	ST_Intersects(sub.agg_geog, z_nga_la.geog) AS in_nga_la,
	ST_Intersects(sub.agg_geog, z_nga_sts.geog) AS in_nga_sts,
	ST_Intersects(sub.agg_geog, z_nga_saa.geog) AS in_nga_saa,
	ST_Intersects(sub.agg_geog, z_nga_saa_mez.geog) AS in_nga_saa_mez,
	ST_Intersects(sub.agg_geog, z_ben_1_storage.geog) AS in_ben_1_storage,
	ST_Intersects(sub.agg_geog, z_ben_2_tanker.geog) AS in_ben_2_tanker,
	ST_Intersects(sub.agg_geog, z_ben_3_tanker.geog) AS in_ben_3_tanker,
	ST_Intersects(sub.agg_geog, z_ben_4_sts.geog) AS in_ben_4_sts,
	ST_Intersects(sub.agg_geog, z_tgo_waiting.geog) AS in_tgo_waiting,
	ST_Intersects(sub.agg_geog, z_tgo_berthing.geog) AS in_tgo_berthing,
	ST_Intersects(sub.agg_geog, z_gha_anchorage.geog) AS in_gha_anchorage,
	ST_Intersects(sub.agg_geog, z_gha_sts.geog) AS in_gha_sts,
	ST_MaxDistance(sub.agg_geog::geometry, sub.agg_geog::geometry) AS range
FROM 
(
	SELECT 	t1.partition_code, t1.mmsi, t1.vessel_name,
		count(*) AS ping_count, 
		ST_Collect(t1.position::geometry ORDER BY t1.ts_pos_utc ASC)::geography AS agg_geog,
		ST_Collect(t1.position_ts::geometry ORDER BY t1.ts_pos_utc ASC)::geography AS agg_geog_ts
	FROM ping AS t1
	GROUP BY t1.partition_code, t1.mmsi, t1.vessel_name
) AS sub
LEFT OUTER JOIN zone z_region_wa
ON z_region_wa.name='region_wa'
LEFT OUTER JOIN zone z_region_ea
ON z_region_ea.name='region_ea'
LEFT OUTER JOIN zone z_region_sea
ON z_region_sea.name='region_sea'
LEFT OUTER JOIN zone z_vra_wa
ON z_vra_wa.name='vra_wa'
LEFT OUTER JOIN zone z_vra_ea
ON z_vra_ea.name='vra_ea'
LEFT OUTER JOIN zone z_vra_sea
ON z_vra_sea.name='vra_sea'
LEFT OUTER JOIN zone z_wra_wa
ON z_wra_wa.name='wra_wa'
LEFT OUTER JOIN zone z_wra_ea
ON z_wra_ea.name='wra_ea'
LEFT OUTER JOIN zone z_wra_sea
ON z_wra_sea.name='wra_sea'
LEFT OUTER JOIN zone z_hra_ea_old
ON z_hra_ea_old.name='hra_ea_old'
LEFT OUTER JOIN zone z_hra_ea_old_nowedge
ON z_hra_ea_old_nowedge.name='hra_ea_old_nowedge'
LEFT OUTER JOIN zone z_hra_ea_new
ON z_hra_ea_new.name='hra_ea_new'
LEFT OUTER JOIN zone z_ibf_woa_ea
ON z_ibf_woa_ea.name='ibf_woa_ea'
LEFT OUTER JOIN zone z_ibf_xrz_ea
ON z_ibf_xrz_ea.name='ibf_xrz_ea'
LEFT OUTER JOIN zone z_ibf_hra_wa
ON z_ibf_hra_wa.name='ibf_hra_wa'
LEFT OUTER JOIN zone z_ibf_hra_ea
ON z_ibf_hra_ea.name='ibf_hra_ea'
LEFT OUTER JOIN zone z_aoi_sea
ON z_aoi_sea.name='aoi_sea'
LEFT OUTER JOIN zone z_jcc_ea
ON z_jcc_ea.name='jcc_ea'
LEFT OUTER JOIN zone z_jcc_wa
ON z_jcc_wa.name='jcc_wa'
LEFT OUTER JOIN zone z_jcc_sea
ON z_jcc_sea.name='jcc_sea'
LEFT OUTER JOIN zone z_atalanta_red
ON z_atalanta_red.name='atalanta_red'
LEFT OUTER JOIN zone z_atalanta_goa
ON z_atalanta_goa.name='atalanta_goa'
LEFT OUTER JOIN zone z_atalanta_somali
ON z_atalanta_somali.name='atalanta_somali'
LEFT OUTER JOIN zone z_atalanta_south
ON z_atalanta_south.name='atalanta_south'
LEFT OUTER JOIN zone z_atalanta_north
ON z_atalanta_north.name='atalanta_north'
LEFT OUTER JOIN zone z_atalanta_indian
ON z_atalanta_indian.name='atalanta_indian'
LEFT OUTER JOIN zone z_irtc_east
ON z_irtc_east.name='irtc_east'
LEFT OUTER JOIN zone z_irtc_west
ON z_irtc_west.name='irtc_west'
LEFT OUTER JOIN zone z_strait_malacca
ON z_strait_malacca.name='strait_malacca'
LEFT OUTER JOIN zone z_strait_singapore
ON z_strait_singapore.name='strait_singapore'
LEFT OUTER JOIN zone z_strait_sunda
ON z_strait_sunda.name='strait_sunda'
LEFT OUTER JOIN zone z_bgd_vicinity
ON z_bgd_vicinity.name='bgd_vicinity'
LEFT OUTER JOIN zone z_nga_naa
ON z_nga_naa.name='nga_naa'
LEFT OUTER JOIN zone z_nga_la
ON z_nga_la.name='nga_la'
LEFT OUTER JOIN zone z_nga_sts
ON z_nga_sts.name='nga_sts'
LEFT OUTER JOIN zone z_nga_saa
ON z_nga_saa.name='nga_saa'
LEFT OUTER JOIN zone z_nga_saa_mez
ON z_nga_saa_mez.name='nga_saa_mez'
LEFT OUTER JOIN zone z_ben_1_storage
ON z_ben_1_storage.name='ben_1_storage'
LEFT OUTER JOIN zone z_ben_2_tanker
ON z_ben_2_tanker.name='ben_2_tanker'
LEFT OUTER JOIN zone z_ben_3_tanker
ON z_ben_3_tanker.name='ben_3_tanker'
LEFT OUTER JOIN zone z_ben_4_sts
ON z_ben_4_sts.name='ben_4_sts'
LEFT OUTER JOIN zone z_tgo_waiting
ON z_tgo_waiting.name='tgo_waiting'
LEFT OUTER JOIN zone z_tgo_berthing
ON z_tgo_berthing.name='tgo_berthing'
LEFT OUTER JOIN zone z_gha_anchorage
ON z_gha_anchorage.name='gha_anchorage'
LEFT OUTER JOIN zone z_gha_sts
ON z_gha_sts.name='gha_sts'
