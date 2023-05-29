CREATE TABLE analysis.tmp_rfm_frequency (
user_id INT NOT NULL PRIMARY KEY,
frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);

SELECT 	o.user_id,
	COUNT(
	      CASE 
		        WHEN os.key = 'Closed' then 1
	      END
	     ) AS orders_closed
FROM 
	analysis.orders o LEFT JOIN analysis.orderstatuses os 
ON o.status  = os.id
GROUP BY o.user_id 
ORDER BY orders_closed DESC;
	
WITH num_orders AS
  (SELECT o.user_id,
          COUNT (CASE
                     WHEN os.key = 'Closed' THEN 1
                 END) AS orders_closed
   FROM analysis.orders o
   LEFT JOIN analysis.orderstatuses os ON o.status = os.id
   GROUP BY o.user_id
   ORDER BY orders_closed DESC)
SELECT u.id, 
NTILE(5) OVER(
               ORDER BY nrds.orders_closed) AS frequency
FROM analysis.users u
INNER JOIN num_orders nrds ON u.id = nrds.user_id;

INSERT INTO analysis.tmp_rfm_frequency (user_id, frequency)
WITH num_orders AS
  (SELECT o.user_id,
          COUNT (CASE
                     WHEN os.key = 'Closed' THEN 1
                 END) AS orders_closed
   FROM analysis.orders o
   LEFT JOIN analysis.orderstatuses os ON o.status = os.id
   GROUP BY o.user_id
   ORDER BY orders_closed DESC)
SELECT u.id, 
NTILE(5) OVER(
               ORDER BY nrds.orders_closed) AS frequency
FROM analysis.users u
INNER JOIN num_orders nrds ON u.id = nrds.user_id;
