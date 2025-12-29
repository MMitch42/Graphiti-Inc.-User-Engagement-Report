-- Volume Share of Top Wallets (having traded $10,000 or more in the past 90 days)

WITH wallet_spend AS (
    SELECT 
        t.tx_from AS wallet
        , SUM(t.amount_usd) AS total_spent
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

, volume_segments AS (
    SELECT
        CASE 
            WHEN total_spent >= 10000 THEN '$10K+ Wallets'
            ELSE 'Other Wallets'
        END AS segment
        , SUM(total_spent) AS volume_usd
        , COUNT(DISTINCT wallet) AS wallet_count
    FROM wallet_spend
    GROUP BY 1
)

SELECT
    segment AS "Wallet Segment"
    , volume_usd AS "Trading Volume" 
FROM volume_segments
ORDER BY volume_usd DESC;
