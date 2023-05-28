CREATE TABLE analysis.dm_rfm_segments (user_id int PRIMARY KEY,
recency int CHECK(recency > 0 AND recency <= 5),
frequency int CHECK(frequency > 0 AND recency <= 5),
monetary_value int CHECK(monetary_value > 0 AND monetary_value <= 5))

ALTER TABLE analysis.dm_rfm_segments ADD CONSTRAINT dm_rfm_segments_user_id_fkey FOREIGN KEY (user_id) REFERENCES production.users(id);
