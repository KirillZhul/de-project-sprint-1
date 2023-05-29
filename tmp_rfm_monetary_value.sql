CREATE TABLE analysis.tmp_rfm_monetary_value (
user_id INT NOT NULL PRIMARY KEY,
monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

INSERT INTO analysis.tmp_rfm_monetary_value (user_id, monetary_value)
WITH mv AS (
SELECT u.id,
       o.status,
       CASE
           WHEN o.status = 4 THEN SUM (o.payment)
           ELSE 0
       END AS monetary_value,
       row_number() OVER (PARTITION BY u.id
                          ORDER BY CASE
                                       WHEN o.status = 4 THEN SUM (o.payment)
                                       ELSE 0
                                   END DESC) AS row_number
FROM production.users u
LEFT JOIN production.orders o ON u.id = o.user_id
GROUP BY u.id,
         o.status
ORDER BY u.id,
         monetary_value desc)
SELECT mv.id, 
NTILE(5) OVER(
         ORDER BY mvc.monetary_value) AS monetary_value
FROM mv
WHERE mv.row_number = 1;
