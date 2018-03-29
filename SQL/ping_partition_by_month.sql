UPDATE ping
SET	partition_code = CASE
    	WHEN EXTRACT(month from ts_pos_utc) = 1 THEN 'A'
    	WHEN EXTRACT(month from ts_pos_utc) = 2 THEN 'B'
    	WHEN EXTRACT(month from ts_pos_utc) = 3 THEN 'C'
    	WHEN EXTRACT(month from ts_pos_utc) = 4 THEN 'D'
    	WHEN EXTRACT(month from ts_pos_utc) = 5 THEN 'E'
    	WHEN EXTRACT(month from ts_pos_utc) = 6 THEN 'F'
    	WHEN EXTRACT(month from ts_pos_utc) = 7 THEN 'G'
    	WHEN EXTRACT(month from ts_pos_utc) = 8 THEN 'H'
        WHEN EXTRACT(month from ts_pos_utc) = 9 THEN 'I'
    	WHEN EXTRACT(month from ts_pos_utc) = 10 THEN 'J'
    	WHEN EXTRACT(month from ts_pos_utc) = 11 THEN 'K'
    	WHEN EXTRACT(month from ts_pos_utc) = 12 THEN 'L'

        ELSE 'n'
        END;
