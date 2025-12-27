-- Top Chains by User Trading Activity (with 50,000 transactions or higher, in the past 30 days) 

SELECT
    t.blockchain AS chain
    , COUNT(t.tx_from) AS num_trades
FROM dex.trades t 
JOIN (
    SELECT DISTINCT evm_address 
    FROM sample_dataset -- replace with appropriate dataset
    ) adds
    ON adds.evm_address = t.tx_from
WHERE 
    t.block_time >= date_trunc('day', NOW()) - INTERVAL '30' DAY
    AND t.block_time < date_trunc('day', NOW())
GROUP BY 1
HAVING COUNT(t.tx_from) >= 50000
ORDER BY 2 DESC 
