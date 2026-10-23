"""Prepare the UCI Bank Marketing data for descriptive analysis."""

import pandas as pd
import zipfile
import io
from pathlib import Path


# 1. Read the original UCI ZIP saved beside this script.
# Install pandas once: python -m pip install pandas
# Run this file: python bank_marketing_data_preparation.py
folder = Path(__file__).resolve().parent
zip_path = folder / "bank+marketing.zip"
if not zip_path.is_file():
    raise FileNotFoundError(
        "Place the original bank+marketing.zip in the same folder as this script."
    )
outer = zipfile.ZipFile(zip_path)
inner = zipfile.ZipFile(io.BytesIO(
    outer.read("bank-additional.zip")
))

csv_name = next(
    name for name in inner.namelist()
    if name.endswith("/bank-additional-full.csv")
)

raw = pd.read_csv(
    io.BytesIO(inner.read(csv_name)),
    sep=";"
)

assert raw.shape == (41188, 21)
assert set(raw["y"].unique()) == {"yes", "no"}

# 2. Preserve records and document quality issues.
df = raw.copy()
df.columns = df.columns.str.replace(".", "_", regex=False)

df.insert(0, "record_id", range(1, len(df) + 1))
df["repeated_row_flag"] = raw.duplicated().astype(int)

# Keep unknown values visible rather than guessing replacements.
text_columns = raw.select_dtypes(include="object").columns
df["unknown_field_count"] = (
    raw[text_columns].eq("unknown").sum(axis=1)
)

# 3. Create analysis fields.
df["subscribed"] = df["y"].map({"yes": 1, "no": 0})

# UCI defines 999 as "not previously contacted".
df["previously_contacted"] = df["pdays"].ne(999).astype(int)
df["days_since_previous_contact"] = (
    df["pdays"].replace(999, pd.NA)
)

month_order = {
    "jan": 1, "feb": 2, "mar": 3, "apr": 4,
    "may": 5, "jun": 6, "jul": 7, "aug": 8,
    "sep": 9, "oct": 10, "nov": 11, "dec": 12
}
df["month_number"] = df["month"].map(month_order)

df["campaign_contact_band"] = pd.cut(
    df["campaign"],
    bins=[0, 1, 2, 3, 5, float("inf")],
    labels=["1", "2", "3", "4–5", "6+"]
).astype("string")

# 4. Summarize outcomes by business dimension.
def summarize(column):
    result = (
        df.groupby(column, dropna=False)
          .agg(
              records=("record_id", "count"),
              subscriptions=("subscribed", "sum")
          )
          .reset_index()
    )
    result["subscription_rate"] = (
        result["subscriptions"] / result["records"]
    )
    return result

output = folder / "bank_marketing_outputs"
output.mkdir(exist_ok=True)

df.to_csv(output / "bank_marketing_clean.csv", index=False)

dimensions = [
    "job", "education", "contact", "month",
    "campaign_contact_band", "poutcome"
]
for column in dimensions:
    summarize(column).to_csv(
        output / f"analysis_by_{column}.csv",
        index=False
    )

# 5. Export a quality report and headline metrics.
quality = pd.DataFrame({
    "field": raw.columns,
    "blank_values": raw.isna().sum().values,
    "unknown_values": [
        raw[column].eq("unknown").sum()
        for column in raw.columns
    ]
})
quality.to_csv(output / "data_quality_report.csv", index=False)

metrics = pd.DataFrame([{
    "total_records": len(df),
    "subscriptions": int(df["subscribed"].sum()),
    "subscription_rate": df["subscribed"].mean(),
    "repeated_rows_flagged": int(
        df["repeated_row_flag"].sum()
    )
}])
metrics.to_csv(output / "headline_metrics.csv", index=False)

print("Preparation completed.")
print(metrics.to_string(index=False))
print("\nSubscription rate by contact method:")
print(summarize("contact").to_string(index=False))

# 6. Save all outputs together as a ZIP.
archive_name = folder / "bank_marketing_outputs.zip"
with zipfile.ZipFile(
    archive_name, "w", zipfile.ZIP_DEFLATED
) as archive:
    for path in output.glob("*.csv"):
        archive.write(path, arcname=path.name)

print(f"\nCSV files saved to: {output}")
print(f"ZIP saved to: {archive_name}")