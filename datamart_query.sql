INCERT INTO analysis.dm_rfm_segments (user_id, recency, frequency, monetary_value)
SELECT u.id, 
       r.recency, 
       f.frequency, 
       m.monetary_value 
FROM analysis.users u 
LEFT JOIN analysis.tmp_rfm_recency r ON u.id = r.user_id 
LEFT JOIN analysis.tmp_rfm_frequency f ON u.id = f.user_id 
LEFT JOIN analysis.tmp_rfm_monetary_value m ON u.id = m.user_id;
