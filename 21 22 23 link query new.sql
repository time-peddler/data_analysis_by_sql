
/* 实际上temp_90_20230615_yxzouhua_sj_high_value_02数据有问题，缺失某些月份的数据，
该表主要按增值业务办理时间来统计数据，在此基础上补充lv_type等字段，故而没有办理增值业务的月份就没有记录*/

-- 将两表按月份合并以备后用

CREATE TABLE high_value_arpu AS
WITH real_arpu_table AS (
  SELECT *
  FROM (
    SELECT t1.*, 
    CASE WHEN (t1.zk_arpu IS NOT NULL AND t1.zk_arpu <> 0) THEN t1.zk_arpu ELSE t1.arpu END AS real_arpu
    FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_22 t1
  )
)
SELECT DISTINCT t2.*, t3.lv_type, t3.product_no as PN, t3.total_value,
	t3.region_name, t3.create_date, t3.channel_name, t3.channel_code
FROM real_arpu_table t2
INNER JOIN JSJ.temp_90_20230615_yxzouhua_sj_high_value_02 t3
ON TRIM(t2.user_id) = TRIM(t3.user_id) AND TRIM(t2.month) = TRIM(t3.month_id)

-- 提取 2022新入网账户第四季度平均real_arpu不在lv_type范围内的详细清单（只包括这些用户第四季度的数据）

SELECT DISTINCT month, user_id, product_no, arpu, zk_arpu, real_arpu, total_value, lv_type, status, mou, dou, itemname,  
  region_name, create_date, channel_name, channel_code
FROM high_value_arpu
WHERE (user_id, lv_type) IN (
  SELECT user_id, lv_type
  FROM high_value_arpu
  WHERE TO_DATE(month,'YYYYMM') BETWEEN TO_DATE('202210','YYYYMM') AND TO_DATE('202212','YYYYMM')
    AND TO_DATE(create_date,'YYYY-MM-DD') BETWEEN TO_DATE('2022-01-01','YYYY-MM-DD') AND TO_DATE('2022-12-31','YYYY-MM-DD')
  GROUP BY user_id, lv_type
  HAVING (AVG(real_arpu) < 68 AND lv_type='大于等于68小于168') OR (AVG(real_arpu) < 168 AND lv_type='大于等于168')
  )
AND TO_DATE(month,'YYYYMM') BETWEEN TO_DATE('202210','YYYYMM') AND TO_DATE('202212','YYYYMM')

-- 以lv_type为分类条件，计算2023前三个月的退网率

SELECT t1.lv_type,
  COUNT(t2.xh_date)/COUNT(DISTINCT t1.user_id) AS quit_rate
FROM (
     SELECT DISTINCT user_id, lv_type
     FROM forth_quarter_inconform
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
     FROM forth_quarter_inconform
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

-- 以下建表方式，报错：ora-01652:无法通过128(在表空间space中)扩展temp

CREATE TABLE high_value_real_arpu AS
SELECT t1.*, t2.lv_type, t2.PN, t2.T_VAL, t2.region_name, t2.create_date,
  t2.channel_name, t2.channel_code
FROM (SELECT *
      FROM (
        SELECT temp.*, 
        CASE WHEN (temp.zk_arpu IS NOT NULL AND temp.zk_arpu <> 0) THEN temp.zk_arpu ELSE temp.arpu END AS real_arpu
        FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_22  temp)
        ) t1
INNER JOIN (SELECT DISTINCT user_id, month_id, lv_type, 
      product_no as PN, total_value AS T_VAL,
      region_name, create_date, channel_name, channel_code
    FROM JSJ.temp_90_20230615_yxzouhua_sj_high_value_02) t2
ON TRIM(t1.user_id) = TRIM(t2.user_id) AND TRIM(t1.month) = TRIM(t2.month_id)
