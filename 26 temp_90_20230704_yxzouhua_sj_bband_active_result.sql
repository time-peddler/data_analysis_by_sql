-- 统计开通之后一直没有流量的宽带

	--temp_90_20230620_yxzouhua_sj_bband_access_00 宽带到达
		/* 
		1.查询各个宽带的开通时间 create_date
		2. 查询连续三个月宽带不活跃的宽带
		3. 两表取交集
		*/
	
	SELECT user_id,
	FROM JSJ.temp_90_20230620_yxzouhua_sj_bband_access_00
	GROUP BY user_id, month_id

-- 连续三个月无流量出入的宽带
SELECT DISTINCT a.product_no
FROM jsj.temp_90_20230704_yxzouhua_sj_bband_active_result a
WHERE a.sendkbytes = 0 AND a.receivekbytes = 0
  AND EXISTS (
    SELECT 1
    FROM jsj.temp_90_20230704_yxzouhua_sj_bband_active_result b
    WHERE b.product_no = a.product_no
      AND TO_DATE(b.month_id, 'YYYY-MM') = ADD_MONTHS(TO_DATE(a.month_id, 'YYYY-MM'), 1)
      AND b.sendkbytes = 0 AND b.receivekbytes = 0
  )
  AND EXISTS (
    SELECT 1
    FROM jsj.temp_90_20230704_yxzouhua_sj_bband_active_result c
    WHERE c.product_no = a.product_no
      AND TO_DATE(c.month_id, 'YYYY-MM') = ADD_MONTHS(TO_DATE(a.month_id, 'YYYY-MM'), 2)
      AND c.sendkbytes = 0 AND c.receivekbytes = 0
  );