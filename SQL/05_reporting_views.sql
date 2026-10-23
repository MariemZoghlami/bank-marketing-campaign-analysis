USE bank_marketing;

-- Detailed data for filtering and dashboard reporting.
CREATE OR REPLACE VIEW campaign_reporting_view AS
SELECT
    record_id,
    age,
    job,
    education,
    contact AS contact_method,
    campaign,
    campaign_contact_band,
    poutcome AS previous_campaign_outcome,
    previously_contacted,
    days_since_previous_contact,
    subscribed,
    repeated_row_flag
FROM bank_marketing_clean;

-- Reusable summary by contact method.
CREATE OR REPLACE VIEW contact_performance_view AS
SELECT
    contact AS contact_method,
    COUNT(*) AS total_records,
    SUM(subscribed) AS subscriptions,
    AVG(subscribed) AS subscription_rate
FROM bank_marketing_clean
GROUP BY contact;

-- Check both views.
SELECT COUNT(*) AS total_records
FROM campaign_reporting_view;

SELECT *
FROM contact_performance_view
ORDER BY subscription_rate DESC;