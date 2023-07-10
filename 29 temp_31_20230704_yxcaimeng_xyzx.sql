
-- 筛选套餐资费有降档的数据
SELECT *
FROM JSJ.temp_31_20230704_yxcaimeng_xyzx
WHERE 
    (TO_NUMBER(REGEXP_SUBSTR(planname1, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname2, '(\d{2,})元',1,1,NULL,1))) OR
    (TO_NUMBER(REGEXP_SUBSTR(planname2, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname3, '(\d{2,})元',1,1,NULL,1))) OR
    (TO_NUMBER(REGEXP_SUBSTR(planname3, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname4, '(\d{2,})元',1,1,NULL,1))) OR
    (TO_NUMBER(REGEXP_SUBSTR(planname4, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname5, '(\d{2,})元',1,1,NULL,1))) OR
    (TO_NUMBER(REGEXP_SUBSTR(planname5, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname6, '(\d{2,})元',1,1,NULL,1))) OR
    (TO_NUMBER(REGEXP_SUBSTR(planname6, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname7, '(\d{2,})元',1,1,NULL,1))) OR
    (TO_NUMBER(REGEXP_SUBSTR(planname7, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname8, '(\d{2,})元',1,1,NULL,1))) OR
    (TO_NUMBER(REGEXP_SUBSTR(planname8, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname9, '(\d{2,})元',1,1,NULL,1))) OR
    (TO_NUMBER(REGEXP_SUBSTR(planname9, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname10, '(\d{2,})元',1,1,NULL,1))) OR
    (TO_NUMBER(REGEXP_SUBSTR(planname10, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname11, '(\d{2,})元',1,1,NULL,1))) OR
    (TO_NUMBER(REGEXP_SUBSTR(planname11, '(\d{2,})元',1,1,NULL,1)) > TO_NUMBER(REGEXP_SUBSTR(planname12, '(\d{2,})元',1,1,NULL,1)));

      
-- 看用户连续两个月以上状态不是"正常在用"

SELECT *
FROM JSJ.temp_31_20230704_yxcaimeng_xyzx
WHERE 
    (status1 <> '正常在用' AND status2 <> '正常在用' AND status3 <> '正常在用') OR
    (status2 <> '正常在用' AND status3 <> '正常在用' AND status4 <> '正常在用') OR
    (status3 <> '正常在用' AND status4 <> '正常在用' AND status5 <> '正常在用') OR
    (status4 <> '正常在用' AND status5 <> '正常在用' AND status6 <> '正常在用') OR
    (status5 <> '正常在用' AND status6 <> '正常在用' AND status7 <> '正常在用') OR
    (status6 <> '正常在用' AND status7 <> '正常在用' AND status8 <> '正常在用') OR
    (status7 <> '正常在用' AND status8 <> '正常在用' AND status9 <> '正常在用') OR
    (status8 <> '正常在用' AND status9 <> '正常在用' AND status10 <> '正常在用') OR
    (status9 <> '正常在用' AND status10 <> '正常在用' AND status11 <> '正常在用') OR
    (status10 <> '正常在用' AND status11 <> '正常在用' AND status12 <> '正常在用');



