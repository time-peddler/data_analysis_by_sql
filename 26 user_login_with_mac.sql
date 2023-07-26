WITH login_mac_30 AS (
    SELECT *
    FROM login_mac 
    WHERE mac_address IN (SELECT mac_address
        FROM login_mac
        GROUP BY mac_address
        HAVING COUNT(DISTINCT user_number) >= 30)
)

SELECT COUNT(DISTINCT product_no)
FROM JSJ.temp_90_20230620_yxzouhua_sj_bband_access_00
WHERE TRIM(product_no) IN (
  SELECT DISTINCT TRIM(a.product_no)
  FROM login_mac_30 lm
  INNER JOIN jsj.temp_90_20230704_yxzouhua_sj_bband_active_result a
      ON TRIM(lm.user_number) = TRIM(a.product_no)
  WHERE a.user_time / 60 < 10)
