CREATE OR REPLACE view analysis.orders AS 
SELECT o.order_id, 
	osl.dttm AS "order_ts", 
	o.user_id, 
	o.bonus_payment, 
	o.payment, 
	o."cost", 
	o.bonus_grant,
	osl.status_id as "status" 
FROM production.orders o
LEFT JOIN production.orderstatuslog osl 
ON osl.order_id = o.order_id 
AND osl.dttm = (SELECT MAX(osl2.dttm) 
FROM production.orderstatuslog osl2 
WHERE osl2.order_id = o.order_id);
