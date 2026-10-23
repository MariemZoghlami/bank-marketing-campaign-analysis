USE bank_marketing;

-- Clear the incomplete import.
TRUNCATE TABLE bank_marketing_clean;

-- Import the CSV and convert blank days to NULL.
LOAD DATA LOCAL INFILE
'C:/Users/MariemZoghlami/Downloads/bank_marketing_outputs/bank_marketing_clean.csv'
INTO TABLE bank_marketing_clean
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    record_id,
    age,
    job,
    marital,
    education,
    `default`,
    housing,
    loan,
    contact,
    month,
    day_of_week,
    duration,
    campaign,
    pdays,
    previous,
    poutcome,
    emp_var_rate,
    cons_price_idx,
    cons_conf_idx,
    euribor3m,
    nr_employed,
    y,
    repeated_row_flag,
    unknown_field_count,
    subscribed,
    previously_contacted,
    @previous_days,
    month_number,
    campaign_contact_band
)
SET days_since_previous_contact = NULLIF(@previous_days, '');

SHOW WARNINGS LIMIT 10;

SELECT
    COUNT(*) AS total_records,
    SUM(subscribed) AS subscriptions
FROM bank_marketing_clean;