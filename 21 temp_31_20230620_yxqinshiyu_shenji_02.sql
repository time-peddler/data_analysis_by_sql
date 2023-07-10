-- 各渠道每月新入网情况
SELECT SUBSTR(createdate, 1, 7) AS month,
       channel_code,
       COUNT(*) AS num_accounts
FROM jsj.temp_31_20230620_yxqinshiyu_shenji_02
GROUP BY SUBSTR(createdate, 1, 7), channel_code;

/* 
各渠道每日新入网情况，10000(channel)*365,数据量太大，不考虑分析所有渠道的异常情况
计算一年标准差最大的300个渠道，标准差大于9
*/
WITH channel_stats AS (
  SELECT channel_code, createdate, COUNT(user_id) AS user_count
  FROM jsj.temp_31_20230620_yxqinshiyu_shenji_02
  GROUP BY channel_code, createdate
  HAVING COUNT(user_id) > 0
),
channel_std AS (
  SELECT channel_code, STDDEV(user_count) AS std_dev
  FROM channel_stats
  GROUP BY channel_code
  ORDER BY std_dev DESC
  FETCH FIRST 300 ROWS ONLY
)
SELECT createdate, channel_code, COUNT(*) AS num_accounts
FROM jsj.temp_31_20230620_yxqinshiyu_shenji_02
WHERE channel_code IN (
  SELECT channel_code FROM channel_std
)
GROUP BY channel_code, createdate;


-- 获取已经注销的2022新入网用户使用时长小于30天的数据
SELECT  t.*
FROM jsj.temp_31_20230620_yxqinshiyu_shenji_02 t
WHERE xh_date != '\N' 
  AND TO_DATE(xh_date,'YYYY-MM-DD') - TO_DATE(createdate,'YYYY-MM-DD') as DURATION < 30;
  
  
-- 获取销号后是否继续有办理业务的结果

SELECT * 
FROM jsj.temp_90_20230615_yxzouhua_sj_high_value_02 t1
INNER JOIN (
	SELECT * 
	FROM jsj.temp_31_20230620_yxqinshiyu_shenji_02
	WHERE XH_DATE <> '\N') t2
ON TRIM(t1.product_no) = TRIM(t2.product_no)
WHERE TO_DATE(t2.xh_date, 'YYYY-MM-DD') <= TO_DATE(t1.create_date, 'YYYY-MM-DD')

-- 获取销号后是否继续在使用

SELECT * 
FROM jsj.temp_31_20230620_yxqinshiyu_shenji_22 t1
INNER JOIN (
	SELECT * 
	FROM jsj.temp_31_20230620_yxqinshiyu_shenji_02
	WHERE XH_DATE <> '\N') t2
ON TRIM(t1.product_no) = TRIM(t2.product_no)
WHERE (TO_DATE(t2.xh_date, 'YYYY-MM-DD') <= TO_DATE(t1.month, 'YYYY-MM'))
	AND (t1.mou >=0 OR t1.dou >=0)
	
-- 查询销号后是否还有办理权益、宽带或电视(使用PRODUCT_NO存在销号后仍有办理业务，但是属于不同渠道，不同操作人，可能是二次发卡，所以使用USER_ID字段)
	--宽带 >> 结果为空
SELECT *
FROM JSJ.temp_90_20230620_yxzouhua_sj_bband_access_00 t1
INNER JOIN (
	SELECT * 
	FROM jsj.temp_31_20230620_yxqinshiyu_shenji_02
	WHERE XH_DATE <> '\N') t2
ON TRIM(t1.user_id) = TRIM(t2.user_id)
WHERE TO_DATE(t2.xh_date, 'YYYY-MM-DD') <= TO_DATE(t1.create_date, 'YYYY-MM-DD')

	-- 权益  >> 
SELECT *
FROM JSJ.temp_31_20230621_maoshixin_qy t1
INNER JOIN (
	SELECT * 
	FROM jsj.temp_31_20230620_yxqinshiyu_shenji_02
	WHERE XH_DATE <> '\N') t2
ON TRIM(t1.user_id) = TRIM(t2.user_id)
WHERE TO_DATE(t2.xh_date, 'YYYY-MM-DD') <= TO_DATE(t1.rectime, 'YYYY-MM-DD')

	-- 电视
SELECT *
FROM JSJ. temp_90_20230620_yxzouhua_sj_mbh_access_00 t1
INNER JOIN (
	SELECT * 
	FROM jsj.temp_31_20230620_yxqinshiyu_shenji_02
	WHERE XH_DATE <> '\N') t2
ON TRIM(t1.user_id) = TRIM(t2.user_id)
WHERE TO_DATE(t2.xh_date, 'YYYY-MM-DD') <= TO_DATE(t1.create_date, 'YYYY-MM-DD')