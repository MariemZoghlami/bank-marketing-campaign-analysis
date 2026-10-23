USE bank_marketing;

-- Check totals and subscription rate.
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT record_id) AS unique_record_ids,
    SUM(subscribed) AS subscriptions,
    ROUND(100.0 * AVG(subscribed), 2) AS subscription_rate_pct,
    SUM(repeated_row_flag) AS repeated_rows_flagged
FROM bank_marketing_clean;

-- Check that the subscription flag matches the original outcome.
SELECT COUNT(*) AS incorrect_subscription_flags
FROM bank_marketing_clean
WHERE subscribed IS NULL
   OR subscribed NOT IN (0, 1)
   OR y IS NULL
   OR y NOT IN ('yes', 'no')
   OR (y = 'yes' AND subscribed <> 1)
   OR (y = 'no' AND subscribed <> 0);

-- Check that previous-contact days imported correctly.
SELECT COUNT(*) AS incorrect_previous_contact_days
FROM bank_marketing_clean
WHERE (pdays = 999 AND days_since_previous_contact IS NOT NULL)
   OR (pdays <> 999 AND days_since_previous_contact IS NULL)
   OR (pdays <> 999 AND days_since_previous_contact <> pdays);