-- Return table with a count of distinct MMSIs in East Africa HRA for each day of year
SELECT series.doy, total FROM
    (SELECT generate_series(0,365) AS doy) AS series
  LEFT OUTER JOIN
    (SELECT EXTRACT(doy FROM p.ts_pos_utc) AS doy,
    COUNT(DISTINCT p.mmsi) AS total
    FROM ping p, zone z
    WHERE z.name = 'hra_ea_new'
    AND ST_Intersects(z.geog, p.position_ts)
    GROUP BY doy) AS zero
  ON zero.doy = series.doy;
