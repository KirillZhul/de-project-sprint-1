create or replace view analysis.users AS
	select * from production.users;

create or replace view analysis.products AS
	select * from production.products;
	
create or replace view analysis.orderstatuses AS
	select * from production.orderstatuses;
	
create or replace view analysis.orders AS
	select * from production.orders;
	
create or replace view analysis.orderitems AS
	select * from production.orderitems;
	
create or replace view analysis.orderstatuslog AS
	select * from production.orderstatuslog;
