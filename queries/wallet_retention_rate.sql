-- Wallet Retention Rate (as a percentage of returning wallets this month from last month) 

WITH date_ranges AS (
    SELECT 
        date_trunc('day', NOW()) - INTERVAL '60' DAY AS start_prev
        , date_trunc('day', NOW()) - INTERVAL '30' DAY AS end_prev
        , date_trunc('day', NOW()) - INTERVAL '30' DAY AS start_curr
        , date_trunc('day', NOW()) AS end_curr
),

prev_wallets AS (
    SELECT DISTINCT t.tx_from  
    FROM dex.trades t
    JOIN sample_dataset adds -- replace with appropriate dataset
        ON adds.evm_address = t.tx_from
    WHERE t.block_time >= (SELECT start_prev FROM date_ranges)
        AND t.block_time < (SELECT end_prev FROM date_ranges)
),

curr_wallets AS (
    SELECT DISTINCT t.tx_from
    FROM dex.trades t
    JOIN sample_dataset adds -- replace with appropriate dataset
        ON adds.evm_address = t.tx_from
    WHERE t.block_time >= (SELECT start_curr FROM date_ranges)
      AND t.block_time < (SELECT end_curr FROM date_ranges)
),

retention_stats AS (
  SELECT
      COUNT(c.tx_from) AS retained_wallets,
      COUNT(p.tx_from) - COUNT(c.tx_from) AS not_retained_wallets,
      COUNT(p.tx_from) AS total_wallets
  FROM prev_wallets p
  LEFT JOIN curr_wallets c ON p.tx_from = c.tx_from
)

SELECT 
    'Retained' AS segment
    , retained_wallets 
FROM retention_stats

UNION ALL

SELECT 
    'Not Retained' AS segment
    , not_retained_wallets 
FROM retention_stats;
