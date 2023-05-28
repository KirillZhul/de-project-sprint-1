по DDL:

1) таблица production.products:

для хранения общей информации о продукте.

CREATE TABLE production.products (
	id int4 NOT NULL,
	"name" varchar(2048) NOT NULL,
	price numeric(19, 5) NOT NULL DEFAULT 0,
	CONSTRAINT products_pkey PRIMARY KEY (id),
	CONSTRAINT products_price_check CHECK ((price >= (0)::numeric))
);

Вывод: Верный тип данных, отсутствие NULL.


2) таблица production.orderitem: 

Для хранения информации о специфике заказов (вкл. дисконты).


CREATE TABLE production.orderitems (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	product_id int4 NOT NULL,
	order_id int4 NOT NULL,
	"name" varchar(2048) NOT NULL,
	price numeric(19, 5) NOT NULL DEFAULT 0,
	discount numeric(19, 5) NOT NULL DEFAULT 0,
	quantity int4 NOT NULL,
	CONSTRAINT orderitems_check CHECK (((discount >= (0)::numeric) AND (discount <= price))),
	CONSTRAINT orderitems_order_id_product_id_key UNIQUE (order_id, product_id),
	CONSTRAINT orderitems_pkey PRIMARY KEY (id),
	CONSTRAINT orderitems_price_check CHECK ((price >= (0)::numeric)),
	CONSTRAINT orderitems_quantity_check CHECK ((quantity > 0))
);


-- production.orderitems foreign keys

ALTER TABLE production.orderitems ADD CONSTRAINT orderitems_order_id_fkey FOREIGN KEY (order_id) REFERENCES production.orders(order_id);
ALTER TABLE production.orderitems ADD CONSTRAINT orderitems_product_id_fkey FOREIGN KEY (product_id) REFERENCES production.products(id);

Вывод: Верный тип данных, отсутствие NULL, сумма покупки не должна быть равна нулю. 



3) таблица production.orders:

для хранения информации о заказах.

CREATE TABLE production.orders (
	order_id int4 NOT NULL,
	order_ts timestamp NOT NULL,
	user_id int4 NOT NULL,
	bonus_payment numeric(19, 5) NOT NULL DEFAULT 0,
	payment numeric(19, 5) NOT NULL DEFAULT 0,
	"cost" numeric(19, 5) NOT NULL DEFAULT 0,
	bonus_grant numeric(19, 5) NOT NULL DEFAULT 0,
	status int4 NOT NULL,
	CONSTRAINT orders_check CHECK ((cost = (payment + bonus_payment))),
	CONSTRAINT orders_pkey PRIMARY KEY (order_id)
);

Вывод: Верный тип данных, отсутствие NULL.

4) таблица production.orderstatuses: 
   
для хранения статуса заказа.

CREATE TABLE production.orderstatuses (
	id int4 NOT NULL,
	"key" varchar(255) NOT NULL,
	CONSTRAINT orderstatuses_pkey PRIMARY KEY (id)
);

Вывод: Верный тип данных, отсутствие NULL.

5) таблица production.users: 

для хранения данных о клиентах.

CREATE TABLE production.users (
	id int4 NOT NULL,
	"name" varchar(2048) NULL,
	login varchar(2048) NOT NULL,
	CONSTRAINT users_pkey PRIMARY KEY (id)
);

Вывод: Верный тип данных, отсутствие NULL (кроме столбца "name").

6) таблица production.orderstatuslog: 

для хранения логов (статус заказа).

CREATE TABLE production.orderstatuslog (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	order_id int4 NOT NULL,
	status_id int4 NOT NULL,
	dttm timestamp NOT NULL,
	CONSTRAINT orderstatuslog_order_id_status_id_key UNIQUE (order_id, status_id),
	CONSTRAINT orderstatuslog_pkey PRIMARY KEY (id)
);

-- production.orderstatuslog foreign keys

ALTER TABLE production.orderstatuslog ADD CONSTRAINT orderstatuslog_order_id_fkey FOREIGN KEY (order_id) REFERENCES production.orders(order_id);
ALTER TABLE production.orderstatuslog ADD CONSTRAINT orderstatuslog_status_id_fkey FOREIGN KEY (status_id) REFERENCES production.orderstatuses(id);

Вывод: Верный тип данных, отсутствие NULL.

Общий вывод: в таблицах верные типы данных, отсутствуют NULL, необходимые ограничения в наличии. 

~~Количество заказов и уникальных заказов в таблице orders равно (10000).~~
~~количество заказов со статусом "4" (Closed) равно 4991, со статусом "5" (Canceled) равно 5009. ~~

Инструменты применяемые для анализа качества данных в таблицах production:
- первичные ключи PRIMARY KEY;
- внешние ключи FOREIGN KEY;
- ограничения CONSTRAINT;
- проверка типа данных. 
