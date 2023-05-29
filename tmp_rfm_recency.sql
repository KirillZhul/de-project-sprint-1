CREATE TABLE analysis.tmp_rfm_recency (
user_id INT NOT NULL PRIMARY KEY,
recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);

INSERT INTO analysis.tmp_rfm_recency (user_id, recency)   
WITH rc AS
  (SELECT u.id,
          o.status,
          o.order_ts,
          CASE
              WHEN o.status = 4 THEN o.order_ts
              ELSE
                     (SELECT MIN(o2.order_ts)
                      FROM production.orders o2)
          END AS order_time,
          row_number() OVER (PARTITION BY u.id
                      ORDER BY CASE
                            WHEN o.status = 4 THEN o.order_ts
                                ELSE
                                    (SELECT MIN(o2.order_ts)
                                     FROM production.orders o2)
                             END DESC) AS row_number
   FROM production.users u
   LEFT JOIN production.orders o ON u.id = o.user_id
   ORDER BY u.id ASC)
SELECT rc.id,
       ntile(5) OVER (
                ORDER BY rc.order_time) AS recency
FROM rc
WHERE rc.row_number = 1;
