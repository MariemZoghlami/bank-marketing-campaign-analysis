# Bank Marketing Campaign Analysis

Python · Pandas · MySQL · SQL · Power BI · DAX

## Project overview

I used a public bank marketing dataset to explore which groups of campaign records had higher term deposit subscription rates.

The project covers data preparation in Python, analysis and reporting views in MySQL, and an interactive Power BI report.

This is a personal portfolio project using historical data, not work completed for a bank.

## Dashboard

![Bank Marketing Campaign Performance dashboard](PBI/bank-marketing-dashboard.png)

[View the PDF report](PBI/Bank%20Marketing%20Campaign%20Analysis.pdf) · [Download the Power BI file](PBI/Bank%20Marketing%20Campaign%20Analysis.pbix)

## Business questions

- What was the overall subscription rate?
- How did subscription rates differ between cellular and telephone contacts?
- How did results vary by job and education?
- How did subscription rates vary with the number of campaign contacts?
- How did previous campaign outcomes relate to current subscriptions?

## Data source

[UCI Machine Learning Repository — Bank Marketing](https://archive.ics.uci.edu/dataset/222/bank+marketing)

I used `bank-additional-full.csv`, which contains 41,188 records and 21 original columns. The data relates to telephone marketing campaigns at a Portuguese bank between May 2008 and November 2010.

The dataset has no unique customer identifier, so I report record counts rather than unique customer counts.

## What I did

### Python

- Loaded the original dataset from the downloaded ZIP.
- Checked its size, missing values, unknown categories, and repeated rows.
- Standardized column names.
- Converted the subscription result into a numeric field for calculations.
- Created contact-count bands and previous-contact indicators.
- Exported prepared data, summary tables, and a data quality report.

I flagged 12 exact repeated rows and kept them because the available information did not establish whether they were incorrect duplicates.

The original `pdays` field uses 999 to indicate no previous contact. I kept that meaning separate from actual days since a previous contact.

### SQL

- Created the database and imported the prepared data.
- Checked row counts, subscription values, and derived fields.
- Answered the business questions using grouped counts and subscription rates.
- Created reporting views and exported the data used in Power BI.

The analysis uses one main table, so table joins were not needed.

### Power BI

- Created measures for total records, subscriptions, and subscription rate.
- Built charts comparing contact methods, jobs, contact-count bands, and previous campaign outcomes.
- Added education and contact-method slicers.
- Checked filtered totals against the analysis results.

Subscription rate is calculated as subscriptions divided by total records.

## Main findings

| Measure | Result |
|---|---:|
| Total records | 41,188 |
| Subscriptions | 4,640 |
| Overall subscription rate | 11.27% |
| Cellular subscription rate | 14.74% |
| Telephone subscription rate | 5.23% |

- Cellular contacts had a higher observed subscription rate than telephone contacts.
- Records with one campaign contact had a 13.04% subscription rate, compared with 5.49% for six or more contacts.
- Records with a successful previous campaign outcome had a 65.11% subscription rate, based on 1,373 records.

These comparisons show associations. They do not prove that changing the contact method or number of calls would cause better results.

## Project files

| Location | Contents |
|---|---|
| `Python/` | Data preparation script and original source ZIP |
| `SQL/` | Database setup, import, validation, analysis, and reporting view scripts |
| `PBI/` | Power BI report, PDF, and dashboard image |
| `campaign_reporting.csv` | Data used by the Power BI report |

## How to run or view the project

### Python

1. Install Python and Pandas.
2. Keep `bank+marketing.zip` beside `bank_marketing_data_preparation.py` in the `Python` folder.
3. Run the script.

The script creates a `bank_marketing_outputs` folder containing the prepared data and summaries.

### MySQL

1. Run the database setup and table creation scripts.
2. Update the CSV path in `02b_import_data.sql` to your local prepared CSV.
3. Run the import, validation, analysis, and reporting view scripts in order.

### Power BI

Open the `.pbix` file in Power BI Desktop to explore the saved report.

To refresh it, update the file path to your local `campaign_reporting.csv` through Data source settings.

The PDF and dashboard image provide previews without requiring Power BI Desktop.

## Limitations

- Historical results do not establish current marketing performance.
- The analysis measures subscriptions, not profit or campaign return on investment.
- Small groups should be assessed using record counts alongside percentages.
- Call duration is known after a call, so it should not be used to select customers before calling.
- No predictive model was built in this project.
- Missing previous-contact days may appear as text `NULL` after SQL export. This field is not used in the displayed report measures and needs normalization before further calculations.
