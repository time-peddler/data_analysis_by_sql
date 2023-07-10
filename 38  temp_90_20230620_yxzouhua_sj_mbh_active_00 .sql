-- 查询连续三个月online_cnt和online_cnt均为"当月不活跃"
SELECT DISTINCT a.product_no
FROM jsj.temp_90_20230620_yxzouhua_sj_mbh_active_00 a
WHERE a.online_cnt = '当月不活跃' AND a.online_dou = '当月不活跃'
  AND EXISTS (
    SELECT 1
    FROM jsj.temp_90_20230620_yxzouhua_sj_mbh_active_00 b
    WHERE b.product_no = a.product_no
      AND TO_DATE(b.month_id, 'YYYY-MM') = ADD_MONTHS(TO_DATE(a.month_id, 'YYYY-MM'), 1)
      AND b.online_cnt = '当月不活跃' AND b.online_dou = '当月不活跃'
  )
  AND EXISTS (
    SELECT 1
    FROM jsj.temp_90_20230620_yxzouhua_sj_mbh_active_00 c
    WHERE c.product_no = a.product_no
      AND TO_DATE(c.month_id, 'YYYY-MM') = ADD_MONTHS(TO_DATE(a.month_id, 'YYYY-MM'), 2)
      AND c.online_cnt = '当月不活跃' AND c.online_dou = '当月不活跃'
  );
