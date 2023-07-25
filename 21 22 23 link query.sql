-- 查询新入网主资费大于68的用户，实际消费小于主资费的清单（无结果）
SELECT t2.*, t1.arpu, t1.zk_arpu, t1.real_arpu
FROM (SELECT t1.*, 
     CASE WHEN t1.zk_arpu IS NOT NULL THEN t1.zk_arpu ELSE t1.arpu END AS real_arpu
     FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_22 t1) t1
RIGHT JOIN (SELECT DISTINCT month_id, product_no, total_value 
  FROM JSJ.temp_90_20230615_yxzouhua_sj_high_value_02) t2
ON t1.product_no = t2.product_no AND t1.month = t2.month_id
WHERE t2.total_value < t1.real_arpu;

-- 查询平安卡下主资费小于zk_arpu
SELECT *
FROM JSJ.Temp_31_20230620_Yxqinshiyu_Shenji_22 t1
LEFT JOIN JSJ.temp_31_20230620_yxqinshiyu_shenji_02 t2
ON TRIM(t2.PRODUCT_NO) = TRIM(t1.PRODUCT_NO)
LEFT JOIN JSJ.temp_90_20230615_yxzouhua_sj_high_value_02 t3
ON TRIM(t1.PRODUCT_NO) = TRIM(t3.PRODUCT_NO)
WHERE t2.PLAN_NAME LIKE '%平安%' 
      AND t3.lv_type IS NOT NULL
      AND t1.zk_arpu = 1.90
      -- AND t3.total_value < (CASE WHEN t1.zk_arpu IS NOT NULL THEN t1.zk_arpu ELSE t1.arpu END)

-- 查询平安卡下主资费小于zk_arpu
WITH real_arpu_table AS (
	SELECT *
	FROM (SELECT t1.*, 
     CASE WHEN t1.zk_arpu IS NOT NULL THEN t1.zk_arpu ELSE t1.arpu END AS real_arpu
     FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_22 t1)
	)

SELECT * 
FROM real_arpu_table t2
INNER JOIN JSJ.temp_90_20230615_yxzouhua_sj_high_value_02 t3
ON TRIM(t2.PRODUCT_NO) = TRIM(t3.PRODUCT_NO) AND TRIM(t2.month) = TRIM(t3.month_id)
WHERE (t2.real_arpu < 68 AND t3.lv_type='大于等于68') OR (t2.real_arpu < 168 OR t3.lv_type='大于等于168')

-- 计算real_arpu，如果存在zk_arpu,real_arpu即为zk_arpu,否则为arpu
WITH real_arpu_table AS (
	SELECT *
	FROM (SELECT t1.*, 
     CASE WHEN t1.zk_arpu IS NOT NULL THEN t1.zk_arpu ELSE t1.arpu END AS real_arpu
     FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_22 t1)
	)


	-- lv_type有两种类型：['大于等于68小于168','大于等于168']

-- real_arpu 不在lv_type区间内的数据清单(建立新表inconform_table，方便后续计算)
CREATE TABLE inconform_table AS
WITH real_arpu_table AS (
  SELECT *
  FROM (
    SELECT t1.*, 
    CASE WHEN t1.zk_arpu IS NOT NULL THEN t1.zk_arpu ELSE t1.arpu END AS real_arpu
    FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_22 t1
  )
)
SELECT t3.*, t2.product_no AS PN, t2.arpu AS arpu, t2.zk_arpu AS zk_arpu,
  t2.status AS status, t2.real_arpu AS real_arpu,
  t2.mou AS mou, t2.dou AS dou,
  t2.itemname AS ITNM, t2.total_value AS TOL_VAL
FROM real_arpu_table t2
INNER JOIN JSJ.temp_90_20230615_yxzouhua_sj_high_value_02 t3
ON TRIM(t2.user_id) = TRIM(t3.user_id) AND TRIM(t2.month) = TRIM(t3.month_id)
WHERE (t2.real_arpu < 68 AND t3.lv_type='大于等于68小于168') OR (t2.real_arpu < 168 AND t3.lv_type='大于等于168');

-- 统计real_arpu不在lv_type范围内的清单及其折扣率，折扣率计算方式real_arpu/total_value
SELECT DISTINCT user_id, product_no, month_id, lv_type, status, arpu, zk_arpu, real_arpu, itnm, total_value, region_name, channel_name, channel_code,
real_arpu/total_value AS discount_rate
FROM inconform_table

-- 统计 real_arpu 不在lv_type区间内的计数
SELECT lv_type, COUNT(DISTINCT user_id) AS user_count
FROM inconform_table
GROUP BY lv_type

-- 以lv_type为分类条件，计算2023前三个月的退网率

SELECT t1.lv_type,
  COUNT(t2.xh_date)/COUNT(DISTINCT t1.user_id) AS quit_rate
FROM (
     SELECT DISTINCT user_id, lv_type
     FROM inconform_table
     ) t1
LEFT JOIN(
  SELECT * 
    FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_02 t2
    WHERE t2.xh_date <> '\N'
      AND TO_DATE(t2.xh_date,'YYYY-MM-DD') >= TO_DATE('2023-01-01','YYYY-MM-DD')
      AND TO_DATE(t2.xh_date,'YYYY-MM-DD') <= TO_DATE('2023-03-31','YYYY-MM-DD')
  ) t2
ON TRIM(t1.user_id) = TRIM(t2.user_id)
GROUP BY t1.lv_type

-- 以lv_type为分类条件，计算2023前三个月的退网数量

SELECT t1.lv_type,
  COUNT(t2.xh_date) AS quit_num
FROM (
     SELECT DISTINCT user_id, lv_type
     FROM inconform_table
     ) t1
LEFT JOIN(
  SELECT * 
    FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_02 t2
    WHERE t2.xh_date <> '\N'
      AND TO_DATE(t2.xh_date,'YYYY-MM-DD') >= TO_DATE('2023-01-01','YYYY-MM-DD')
      AND TO_DATE(t2.xh_date,'YYYY-MM-DD') <= TO_DATE('2023-03-31','YYYY-MM-DD')
  ) t2
ON TRIM(t1.user_id) = TRIM(t2.user_id)
GROUP BY t1.lv_type



