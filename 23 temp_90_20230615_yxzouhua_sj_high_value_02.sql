-- 检查lv_type的真实性（结果为真）
select  
sum(case when total_value>=168 and lv_type='大于等于168' then 0
		when total_value>=68 and total_value<168 and lv_type='大于等于68小于168' then 0 
		else 1 end) as check_lv_type
from jsj.temp_90_20230615_yxzouhua_sj_high_value_02

