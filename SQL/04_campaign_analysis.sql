USE bank_marketing;

-- Question 1: What was the overall subscription rate?
SELECT
    COUNT(*) AS total_records,
    SUM(subscribed) AS subscriptions,
    COUNT(*) - SUM(subscribed) AS non_subscriptions,
    ROUND(100.0 * AVG(subscribed), 2) AS subscription_rate_pct
FROM bank_marketing_clean;

-- Question 2: How did results differ by contact method?
SELECT
    contact AS contact_method,
    COUNT(*) AS total_records,
    SUM(subscribed) AS subscriptions,
    ROUND(100.0 * AVG(subscribed), 2) AS subscription_rate_pct
FROM bank_marketing_clean
GROUP BY contact
ORDER BY subscription_rate_pct DESC;

-- Question 3: How did subscription rates differ by occupation?
SELECT
    job,
    COUNT(*) AS total_records,
    SUM(subscribed) AS subscriptions,
    ROUND(100.0 * AVG(subscribed), 2) AS subscription_rate_pct
FROM bank_marketing_clean
GROUP BY job
ORDER BY subscription_rate_pct DESC;

-- Question 4: How did subscription rates differ by education?
SELECT
    education,
    COUNT(*) AS total_records,
    SUM(subscribed) AS subscriptions,
    ROUND(100.0 * AVG(subscribed), 2) AS subscription_rate_pct
FROM bank_marketing_clean
GROUP BY education
ORDER BY subscription_rate_pct DESC;

-- Question 5: How did results differ by campaign contact frequency?
SELECT
    campaign_contact_band,
    COUNT(*) AS total_records,
    SUM(subscribed) AS subscriptions,
    ROUND(100.0 * AVG(subscribed), 2) AS subscription_rate_pct
FROM bank_marketing_clean
GROUP BY campaign_contact_band
ORDER BY MIN(campaign);

-- Question 6: How did previous campaign outcomes relate to subscriptions?
SELECT
    poutcome AS previous_campaign_outcome,
    COUNT(*) AS total_records,
    SUM(subscribed) AS subscriptions,
    ROUND(100.0 * AVG(subscribed), 2) AS subscription_rate_pct
FROM bank_marketing_clean
GROUP BY poutcome
ORDER BY subscription_rate_pct DESC;