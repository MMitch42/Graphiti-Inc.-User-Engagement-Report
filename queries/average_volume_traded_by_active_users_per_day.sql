-- Average Volume Traded by Active Users Per Day (USD, past 30 days) 

SELECT 
    date_trunc('day', t.block_time) AS dates
    , SUM(t.amount_usd) / COUNT(DISTINCT t.tx_from) AS avg_volume_per_user
FROM dex.trades t
JOIN (
    SELECT DISTINCT evm_address 
    FROM sample_dataset -- replace with appropriate dataset 
    ) adds
    ON adds.evm_address = t.tx_from
WHERE 
    t.block_time >= date_trunc('day',NOW()) - INTERVAL '30' DAY 
    AND t.block_time < date_trunc('day', NOW())
GROUP BY 1
ORDER BY 1 DESC;
