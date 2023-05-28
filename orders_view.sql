create or replace view analysis.orders as 
select o.order_id, 
	osl.dttm as "order_ts", 
	o.user_id, 
	o.bonus_payment, 
	o.payment, 
	o."cost", 
	o.bonus_grant,
	osl.status_id as "status" 
from production.orders o
left join production.orderstatuslog osl 
on osl.order_id = o.order_id 
and osl.dttm = (select max(osl2.dttm) 
from production.orderstatuslog osl2 
where osl2.order_id = o.order_id);
