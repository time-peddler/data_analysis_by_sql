-- 选取各渠道开通数量最多5天的所有清单，且活跃度进行对比，最终得出新开电视客户连续三月以上不活跃的清单。

SELECT *
FROM jsj.temp_90_20230620_yxzouhua_sj_mbh_access_00
WHERE TRIM(product_no) in (
	SELECT DISTINCT TRIM(a.product_no)
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
	  )
)
AND TRIM(product_no) in (
	SELECT DISTINCT TRIM(product_no)
	FROM jsj.temp_90_20230620_yxzouhua_sj_mbh_access_00
	WHERE (channel_code, create_date ) IN (
		SELECT channel_code, create_date
		FROM (
			SELECT channel_code, create_date, access_num,
			ROW_NUMBER() OVER (PARTITION BY channel_code ORDER BY access_num DESC) AS rn
			FROM (
				SELECT channel_code, create_date, COUNT(user_id) AS access_num
				FROM jsj.temp_90_20230620_yxzouhua_sj_mbh_access_00
				WHERE TO_DATE(create_date,'YYYY-MM-DD') < TO_DATE('2023-1-1', 'YYYY-MM-DD') 
					AND TO_DATE(create_date,'YYYY-MM-DD') >= TO_DATE('2022-1-1' ,'YYYY-MM-DD')
				GROUP BY channel_code, create_date
			)
		)
		WHERE rn <= 5
	)
)

-- 查看新开电视用户的活跃度
SELECT *
FROM jsj.temp_90_20230620_yxzouhua_sj_mbh_access_00
WHERE product_no IN (
	SELECT a.product_no
		FROM jsj.temp_90_20230620_yxzouhua_sj_mbh_access_00 a,
			jsj.temp_90_20230620_yxzouhua_sj_mbh_active_00 b
		WHERE TRIM(a.product_no) = TRIM(b.product_no))
	AND TO_DATE(create_date,'YYYY-MM-DD') < TO_DATE('2023-1-1', 'YYYY-MM-DD') 
	AND TO_DATE(create_date,'YYYY-MM-DD') >= TO_DATE('2022-1-1' ,'YYYY-MM-DD')
	
-- 查看2022所有渠道数量 => 六千多个
SELECT COUNT(DISTINCT channel_code)
FROM jsj.temp_90_20230620_yxzouhua_sj_mbh_access_00
WHERE TO_DATE(create_date,'YYYY-MM-DD') < TO_DATE('2023-1-1', 'YYYY-MM-DD') 
	AND TO_DATE(create_date,'YYYY-MM-DD') >= TO_DATE('2022-1-1' ,'YYYY-MM-DD')