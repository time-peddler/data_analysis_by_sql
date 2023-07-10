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




