-- Number of Active Wallets (in the past seven days)

SELECT 
    date_trunc('day', t.block_time) AS dates
    , COUNT(DISTINCT t.tx_from) AS active_wallets
FROM dex.trades t 
JOIN (
    SELECT DISTINCT evm_address 
    FROM sample_dataset -- replace with appropriate dataset 
    ) adds
    ON adds.evm_address = t.tx_from
WHERE 
    t.block_time >= date_trunc('day', NOW()) - INTERVAL '7' DAY
    AND t.block_time < date_trunc('day', NOW())
GROUP BY 1 
ORDER BY 1 DESC;
