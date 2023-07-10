
SELECT DISTINCT priv_id, priv_name
FROM JSJ.temp_31_20230620_yxcaimeng_5gtb_info
WHERE priv_id in (
  SELECT priv_id FROM (
    -- 筛选同一天大量开通的业务
    SELECT 
      priv_id,
      op_time, 
      COUNT(priv_id) as priv_count
    FROM JSJ.temp_31_20230620_yxcaimeng_5gtb_info
    GROUP BY op_time, priv_id
    ORDER BY priv_count DESC
    FETCH FIRST 100 ROW ONLY))
    
AND priv_id IN (
  SELECT priv_id
  FROM (
    -- 年底大量开通的业务
    SELECT priv_id,
      COUNT(priv_id) AS priv_count
    FROM JSJ.temp_31_20230620_yxcaimeng_5gtb_info
    WHERE TO_DATE(op_time,'YYYY-MM-DD') < TO_DATE('2023-01-01','YYYY-MM-DD')
      AND TO_DATE(op_time,'YYYY-MM-DD') >= TO_DATE('2022-11-01','YYYY-MM-DD')
    GROUP BY priv_id
    ORDER BY priv_count DESC
    FETCH FIRST 100 ROW ONLY)
  )