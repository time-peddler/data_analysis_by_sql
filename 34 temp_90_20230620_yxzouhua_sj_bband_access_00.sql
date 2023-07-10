
-- 计算一年标准差最大的300个渠道，标准差大于9

WITH channel_stats AS (
  SELECT channel_code, create_date, COUNT(user_id) AS user_count
  FROM jsj.temp_90_20230620_yxzouhua_sj_bband_access_00
  GROUP BY channel_code, create_date
  HAVING COUNT(user_id) > 0
),
channel_std AS (
  SELECT channel_code, STDDEV(user_count) AS std_dev
  FROM channel_stats
  GROUP BY channel_code
  ORDER BY std_dev DESC
  FETCH FIRST 300 ROWS ONLY
)
SELECT create_date, channel_name, channel_code, COUNT(*) AS num_accounts
-- SELECT *
FROM jsj.temp_90_20230620_yxzouhua_sj_bband_access_00
WHERE channel_code IN (
  SELECT channel_code FROM channel_std
)
  AND TO_DATE(create_date,'YYYY-MM-DD') < TO_DATE('2023-1-1','YYYY-MM-DD')
  AND TO_DATE(create_date,'YYYY-MM-DD') >= TO_DATE('2022-1-1','YYYY-MM-DD')
GROUP BY channel_name, channel_code, create_date;

-- 计算各渠道单日办理大于100个用户的详细清单
SELECT * 
FROM jsj.temp_90_20230620_yxzouhua_sj_bband_access_00
WHERE (channel_code, create_date) in (
  SELECT channel_code, create_date
  FROM jsj.temp_90_20230620_yxzouhua_sj_bband_access_00
  GROUP BY channel_code, create_date
  HAVING COUNT(user_id) > 100


-- 与经分对比，查看开通后没有计费 >> 结果为空
SELECT * 
FROM JSJ.temp_90_20230620_yxzouhua_sj_bband_access_00 t1
WHERE user_id IN (
	-- 获取费用为零的user_id
	SELECT user_id
	FROM JSJ.temp_31_20230627_yxchenhui_group_xxh_fee_001 t2
	GROUP BY user_id
	HAVING SUM(fee) = 0
	)


-- 与登录mac对比，查看开通后没有登录
SELECT * 
FROM JSJ.temp_90_20230620_yxzouhua_sj_bband_access_00 t1
WHERE 
