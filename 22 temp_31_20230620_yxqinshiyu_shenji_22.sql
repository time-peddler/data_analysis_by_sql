-- 查询连续三个月MOU和MOU均为"0"
SELECT a.product_no
FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_22 a
WHERE a.mou = 0 AND a.dou = 0
  AND EXISTS (
    SELECT 1
    FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_22 b
    WHERE b.product_no = a.product_no
      AND TO_DATE(b.month, 'YYYY-MM') = ADD_MONTHS(TO_DATE(a.month, 'YYYY-MM'), 1)
      AND b.mou = 0 AND b.dou = 0
  )
  AND EXISTS (
    SELECT 1
    FROM JSJ.temp_31_20230620_yxqinshiyu_shenji_22 c
    WHERE c.product_no = a.product_no
      AND TO_DATE(c.month, 'YYYY-MM') = ADD_MONTHS(TO_DATE(a.month, 'YYYY-MM'), 2)
      AND c.mou = 0 AND c.dou = 0
  );