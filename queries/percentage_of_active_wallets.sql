-- Percentage of Active Wallets (in the past seven days) 

WITH total_wallets AS (
    SELECT COUNT(DISTINCT evm_address) AS total_count
    FROM dune.mmitch.dataset_evm_addresses
),
active_wallets AS (
    SELECT COUNT(DISTINCT t.tx_from) AS active_count
    FROM dex.trades t
    JOIN sample_dataset adds ON adds.evm_address = t.tx_from -- replace with appropriate dataset 
    WHERE t.block_time >= date_trunc('day', NOW()) - INTERVAL '7' DAY
        AND t.block_time < date_trunc('day', NOW())
)
SELECT 
    'Active Wallets' AS wallet_type,
    active_wallets.active_count AS counts
FROM total_wallets, active_wallets

UNION ALL

SELECT 
    'Inactive Wallets' AS wallet_type,
    total_wallets.total_count - active_wallets.active_count AS counts
FROM total_wallets, active_wallets;
