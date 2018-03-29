

-- Check to make sure polygon's ST_GeometryType

  SELECT ST_GeometryType(poly::geometry) FROM zone;

-- Select points that intersect zone by objectid

  SELECT * FROM ping_sep as p, zone as z
  WHERE ST_Intersects(z.poly, p.position_ts);

  -- Or, as subquery:

  SELECT sub.* FROM (SELECT * FROM ping_sep as p, zone as z
  WHERE ST_Intersects(z.poly, p.position_ts)) AS sub;

-- Load Join of ping_goa, zone on ST_Intersects() into ping_zone

  INSERT INTO ping_zone (SELECT * FROM ping_goa as p, zone as z
  WHERE ST_Intersects(z.poly, p.position_ts));

-- Pull descriptive statistics of each zone by day

    -- Average # of ships / zone

        -- TOTAL:

          SELECT COUNT(DISTINCT mmsi) FROM ping_sep as p, zone as z
          WHERE ST_Intersects(z.poly, p.position_ts) AND z.objectid = !!!x!!!;

        -- MONTH:

          SELECT sub.m, COUNT(DISTINCT sub.mmsi)
          FROM (SELECT EXTRACT(month FROM ts_pos_utc) AS m, *
          FROM ping_sep AS p, zone AS z
          WHERE ST_Intersects(z.poly, p.position_ts)
          AND z.objectid = 1) AS sub
          GROUP BY sub.m;


        -- DAY:

          SELECT sub.doy, COUNT(DISTINCT sub.mmsi)
          FROM (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy, *
          FROM ping_sep AS p, zone AS z
          WHERE ST_Intersects(z.poly, p.position_ts)
          AND z.objectid = 1) AS sub
          GROUP BY sub.doy;

          -- Return table of doy, yemen, somalia, irtc counts:

          SELECT series.doy, total, yemen, somalia, irtc FROM
    	     (SELECT generate_series(244,335) AS doy) AS series
           LEFT JOIN
             (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy,
             COUNT(DISTINCT mmsi) AS total
             FROM ping_zone
             GROUP BY doy) AS zero
           ON zero.doy = series.doy
          LEFT JOIN
            (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy,
            COUNT(DISTINCT mmsi) AS yemen
            FROM ping_zone WHERE objectid = 1
            GROUP BY doy) AS one
          ON one.doy = series.doy
          LEFT JOIN
            (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy,
            COUNT(DISTINCT mmsi) AS somalia
            FROM ping_zone WHERE objectid = 2
            GROUP BY doy) AS two
          ON series.doy = two.doy
          LEFT JOIN
            (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy,
            COUNT(DISTINCT mmsi) AS irtc
            FROM ping_zone WHERE objectid = 3
            GROUP BY doy) AS three
          ON three.doy = series.doy;

          -- Exclude certain nav_status?
            -- No, want to see if ships are moving away from Yemen. Including
            -- anchored ships...

    -- Number of pings / day

      SELECT series.doy, total, yemen, somalia, irtc FROM
       (SELECT generate_series(244,335) AS doy) AS series
      LEFT JOIN
        (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy,
        COUNT(*) AS total
        FROM ping_zone
        GROUP BY doy) AS zero
      ON zero.doy = series.doy
    LEFT JOIN
        (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy,
        COUNT(*) AS yemen
        FROM ping_zone WHERE objectid = 1
        GROUP BY doy) AS one
      ON one.doy = series.doy
      LEFT JOIN
        (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy,
        COUNT(*) AS somalia
        FROM ping_zone WHERE objectid = 2
        GROUP BY doy) AS two
      ON series.doy = two.doy
      LEFT JOIN
        (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy,
        COUNT(*) AS irtc
        FROM ping_zone WHERE objectid = 3
        GROUP BY doy) AS three
      ON three.doy = series.doy;

    -- Average time between pings

      -- Irrelevant - it is around 4 hours because of our sampling time.
      -- Actual average is more like 40 min (?)

    -- Average amount of time in each zone

      -- x Check max(ts_pos_utc) - min(ts_pos_utc) (Need to use LAG / LEAD...but how to exclude first (last) value (i.e. negatives (duh)))


    -- Average vessel length, width, draft
      -- Need to exclude 0 values. Otherwise assume accuracy?

      SELECT DISTINCT ON (mmsi) mmsi, length FROM ping_zone WHERE length <> 0 ORDER BY mmsi;
      SELECT DISTINCT ON (mmsi) mmsi, width FROM ping_zone WHERE width <> 0 ORDER BY mmsi;
      SELECT DISTINCT ON (mmsi) mmsi, draught FROM ping_zone WHERE draught <> 0 ORDER BY mmsi;



    -- vessel SOG by zone

      SELECT name, sog FROM ping_zone;


    -- # of ships of each vessel_type -- Odd results? Tons in somalia zone...

      SELECT total.vessel_type, total.total, y.yemen, i.irtc, s.somalia FROM
      (SELECT vessel_type, count(DISTINCT mmsi) AS total FROM ping_zone GROUP BY vessel_type) AS total
      LEFT JOIN
      (SELECT vessel_type, count(DISTINCT mmsi) AS yemen FROM ping_zone WHERE objectid = 1 GROUP BY vessel_type) AS y
      ON total.vessel_type = y.vessel_type
      LEFT JOIN
      (SELECT vessel_type, count(DISTINCT mmsi) AS somalia FROM ping_zone WHERE objectid = 2 GROUP BY vessel_type) AS s
      ON total.vessel_type = s.vessel_type
      LEFT JOIN
      (SELECT vessel_type, count(DISTINCT mmsi) AS irtc FROM ping_zone WHERE objectid = 3 GROUP BY vessel_type) AS i
      ON total.vessel_type = i.vessel_type
      ;


    -- # of ships of each nav_status

      SELECT total.nav_status, total.t, yemen.y, irtc.i, somalia.s FROM
      (SELECT DISTINCT ON (nav_status) nav_status, COUNT(*) as t FROM ping_zone GROUP BY nav_status) as total
      LEFT JOIN
      (SELECT DISTINCT ON (nav_status) nav_status, COUNT(*) as y FROM ping_zone WHERE objectid = 1 GROUP BY nav_status) AS yemen
      ON total.nav_status = yemen.nav_status
      LEFT JOIN
      (SELECT DISTINCT ON (nav_status) nav_status, COUNT(*) as s FROM ping_zone WHERE objectid = 2 GROUP BY nav_status) AS somalia
      ON total.nav_status = somalia.nav_status
      LEFT JOIN
      (SELECT DISTINCT ON (nav_status) nav_status, COUNT(*) as i FROM ping_zone WHERE objectid = 3 GROUP BY nav_status) AS irtc
      ON total.nav_status = irtc.nav_status
      ;




-- nah
      SELECT sub.ns, sub.doy, COUNT(DISTINCT sub.mmsi) as c
      FROM (SELECT nav_status AS ns, EXTRACT(doy from ts_pos_utc) as doy, *
      FROM ping_sep AS p, zone AS z
      WHERE ST_Intersects(z.poly, p.position_ts)
      AND z.objectid = 1) AS sub
      GROUP BY  sub.ns, sub.doy;



    -- Rough assessment of dataset completeness

    SELECT series.doy, zone.no_pings FROM
     (SELECT generate_series(244,336) AS doy) AS series
    LEFT JOIN
      (SELECT EXTRACT(doy FROM ts_pos_utc) AS doy,
      COUNT(*) AS no_pings
      FROM ping_zone
      GROUP BY doy) AS zone
    ON zone.doy = series.doy
    GROUP BY series.doy, zone.no_pings
    ORDER BY series.doy;
