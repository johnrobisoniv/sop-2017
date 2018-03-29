-- Return table with a count of distinct MMSIs globally for each day of year that are Under Way sog > 5 kt
SELECT series.doy, total FROM
    (SELECT generate_series(0,366) AS doy) AS series
  LEFT OUTER JOIN
    (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy,
    COUNT(DISTINCT mmsi) AS total
    FROM ping
    WHERE nav_status_code = 0
    AND sog >= 5.0
    GROUP BY doy) AS zero
  ON zero.doy = series.doy;
