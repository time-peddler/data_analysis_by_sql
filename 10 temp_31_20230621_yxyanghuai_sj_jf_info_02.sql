/*统计积分集中的分公司：*/
SELECT county_name, SUM(SCOREAMT) AS total_score
FROM jsj.temp_31_20230621_yxyanghuai_sj_jf_info_02
GROUP BY county_name
HAVING SUM(SCOREAMT) > (
	SELECT AVG(total_score) 
	FROM (
		SELECT county_name, SUM(SCOREAMT) AS total_score 
		FROM jsj.temp_31_20230621_yxyanghuai_sj_jf_info_02 
		GROUP BY county_name)
	);

/*统计积分集中的流动类型：*/
SELECT ls_tpye, SUM(SCOREAMT) AS total_score
FROM jsj.temp_31_20230621_yxyanghuai_sj_jf_info_02
GROUP BY ls_tpye
HAVING SUM(SCOREAMT) > (
	SELECT AVG(total_score) 
	FROM (
		SELECT ls_tpye, SUM(SCOREAMT) AS total_score 
		FROM jsj.temp_31_20230621_yxyanghuai_sj_jf_info_02 
		GROUP BY ls_tpye)
	);


/*按分公司分类，分别计算每日流入流出量的总和*/
SELECT t1.county_name, t1.FINISHDATE, t1.incoming_total, t2.outgoing_total
FROM
  (SELECT county_name, FINISHDATE, 
	SUM(CASE WHEN ls_tpye = '流入' THEN TO_NUMBER(SCOREAMT) ELSE 0 END) AS incoming_total
  FROM jsj.temp_31_20230621_yxyanghuai_sj_jf_info_02
  GROUP BY county_name, FINISHDATE) t1
JOIN
  (SELECT county_name, FINISHDATE, 
	SUM(CASE WHEN ls_tpye = '流出' THEN TO_NUMBER(SCOREAMT) ELSE 0 END) AS outgoing_total
  FROM jsj.temp_31_20230621_yxyanghuai_sj_jf_info_02
  GROUP BY county_name, FINISHDATE) t2
ON t1.county_name = t2.county_name AND t1.FINISHDATE = t2.FINISHDATE;
