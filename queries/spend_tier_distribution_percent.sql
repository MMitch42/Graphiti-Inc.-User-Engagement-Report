-- Spend Tier Distribution by Wallet (As percentage, USD, past 90 days) 

WITH wallet_spend AS (
    SELECT 
        t.tx_from AS wallet
        , SUM(amount_usd) AS total_spent
    FROM dex.trades t
    JOIN (
    SELECT DISTINCT evm_address 
    FROM sample_dataset -- replace with appropriate dataset 
    ) adds
    ON adds.evm_address = t.tx_from
    WHERE 
        t.block_time >= date_trunc('day', NOW()) - INTERVAL '3' MONTH
        AND t.block_time < date_trunc('day', NOW())
    GROUP BY 1
)
SELECT 
  CASE 
    WHEN total_spent >= 100000 THEN '$100K+'
    WHEN total_spent >= 10000 THEN '$10K–$100K'
    WHEN total_spent >= 1000 THEN '$1K–$10K'
    WHEN total_spent >= 100 THEN '$100–$1K'
    WHEN total_spent >= 1 THEN '$1–$100'
    ELSE 'Below $1'
      END AS spend_tier
, COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS percentage
, COUNT(*) AS num_wallets
FROM wallet_spend
GROUP BY 1
ORDER BY 
  CASE 
    WHEN spend_tier = '$100K+' THEN 6
    WHEN spend_tier = '$10K–$100K' THEN 5
    WHEN spend_tier = '$1K–$10K' THEN 4
    WHEN spend_tier = '$100–$1K' THEN 3
    WHEN spend_tier = '$1–$100' THEN 2
    ELSE 1
  END;
