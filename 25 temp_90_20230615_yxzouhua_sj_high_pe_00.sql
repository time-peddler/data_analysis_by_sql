-- 筛选2022年最后三个月折后APRU值是否有负数（结果为空）

SELECT *
FROM jsj.temp_90_20230615_yxzouhua_sj_high_pe_00
WHERE zk_arpu_202210 < 0
   OR zk_arpu_202211 < 0
   OR zk_arpu_202212 < 0;
