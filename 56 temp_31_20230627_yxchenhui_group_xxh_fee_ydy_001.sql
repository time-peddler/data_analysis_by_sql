-- 出账金额最大的100个集团
SELECT ent_name, total_fee
FROM (
  SELECT ent_name, SUM(fee) AS total_fee
  FROM jsj.temp_31_20230627_yxchenhui_group_xxh_fee_ydy_001
  GROUP BY ent_name
  ORDER BY total_fee DESC
  FETCH FIRST 100 ROWS ONLY
) top_100_ent_names;


-- 出账金额最小的100个集团
SELECT ent_name, total_fee
FROM (
  SELECT ent_name, SUM(fee) AS total_fee
  FROM jsj.temp_31_20230627_yxchenhui_group_xxh_fee_ydy_001
  GROUP BY ent_name
  ORDER BY total_fee ASC
  FETCH FIRST 100 ROWS ONLY
) top_100_ent_names;

