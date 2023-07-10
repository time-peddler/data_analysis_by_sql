/*temp_31_20230627_yxchenhui_group_xxh_fee_001*/

-- 资管开通、复机之后是否第二月开始计费

	
WITH group_prod AS (
	-- 从资管表中获取实例状态
  SELECT 产品实例标识, 工单类型, 完成时间
  FROM ASSET_MANAGEMENT_SYS
  WHERE 产品实例标识 IS NOT NULL
  GROUP BY 产品实例标识, 工单类型, 完成时间)
SELECT * FROM group_prod
WHERE 产品实例标识 NOT IN (
  SELECT DISTINCT t2.产品实例标识
  FROM JSJ.temp_31_20230627_yxchenhui_group_xxh_fee_001 t1
  FULL JOIN group_prod t2
  ON t1.acct_id = t2.产品实例标识
  WHERE (t2.工单类型 = '开通' OR t2.工单类型 = '复机') 
  AND TO_CHAR(ADD_MONTHS(TO_DATE(t2.完成时间, 'YYYY-MM-DD HH24:MI:SS'),1),'YYYY-MM') = TO_CHAR(TO_DATE(t1.stat_month, 'YYYY-MM'),'YYYY-MM')
  )

-- 资管开通、复机后2022年以后没有计费的清单
WITH group_prod AS (
  SELECT 产品实例标识, 工单类型, 完成时间
  FROM ASSET_MANAGEMENT_SYS
  WHERE 产品实例标识 IS NOT NULL
  GROUP BY 产品实例标识, 工单类型, 完成时间)

SELECT DISTINCT *
FROM group_prod g
WHERE 产品实例标识 IN (
  SELECT DISTINCT t2.产品实例标识
  FROM JSJ.temp_31_20230627_yxchenhui_group_xxh_fee_001 t1
  FULL JOIN group_prod t2
  ON t1.acct_id = t2.产品实例标识
  WHERE (t2.工单类型 = '开通' OR t2.工单类型 = '复机') 
    AND t1.stat_month IS NULL)


-- 离网之后是否继续计费
SELECT DISTINCT t2.产品实例标识, t2.工单类型, t2.完成时间
FROM JSJ.temp_31_20230627_yxchenhui_group_xxh_fee_001 t1
  -- 从资管表中获取实例状态
FULL JOIN (SELECT 产品实例标识, 工单类型, 完成时间
  FROM ASSET_MANAGEMENT_SYS
  WHERE 产品实例标识 IS NOT NULL
  GROUP BY 产品实例标识, 工单类型, 完成时间) t2
ON t1.acct_id = t2.产品实例标识
WHERE t2.工单类型 = '停机' 
AND ADD_MONTHS(TO_DATE(t2.完成时间, 'YYYY-MM-DD HH24:MI:SS'),1) <= TO_DATE(t1.stat_month, 'YYYY-MM')

/* temp_31_20230627_yxchenhui_group_xxh_qf_01 */