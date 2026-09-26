import json
from pathlib import Path

import requests


inspections_url = "https://data.cityofchicago.org/resource/4ijn-s7e5.json"
licenses_url = "https://data.cityofchicago.org/resource/r5kz-chrr.json"

inspections_filter = (
    "facility_type = 'Restaurant' "
    "AND inspection_date >= '2025-01-01T00:00:00' "
    "AND inspection_date < '2026-01-01T00:00:00'"
)

licenses_filter = (
    "license_description = 'Retail Food Establishment' "
    "AND license_start_date < '2026-01-01T00:00:00' "
    "AND expiration_date >= '2025-01-01T00:00:00'"
)

page_size = 1000


def download_records(url, where_filter, order_by):
    response = requests.get(
        url,
        params={"$where": where_filter, "$select": "count(*)"},
        timeout=30,
    )
    response.raise_for_status()
    total = int(response.json()[0]["count"])

    records = []
    for offset in range(0, total, page_size):
        response = requests.get(
            url,
            params={
                "$where": where_filter,
                "$limit": page_size,
                "$offset": offset,
                "$order": order_by,
            },
            timeout=30,
        )
        response.raise_for_status()
        page = response.json()
        records.extend(page)
        print(f"Downloaded {len(page)} rows at offset {offset}")

    if len(records) != total:
        raise ValueError(f"Expected {total} records, got {len(records)}")

    return records


def save_jsonl(records, file_path):
    with file_path.open("w", encoding="utf-8") as file:
        for record in records:
            file.write(json.dumps(record, ensure_ascii=False) + "\n")

    print(f"Saved {len(records)} records to {file_path}")


raw_dir = Path(__file__).resolve().parent.parent / "data" / "raw"
raw_dir.mkdir(parents=True, exist_ok=True)

print("Downloading restaurant inspections...")
inspections = download_records(inspections_url, inspections_filter, "inspection_id ASC")

print("Downloading business licenses...")
licenses = download_records(licenses_url, licenses_filter, "id ASC")

save_jsonl(inspections, raw_dir / "inspections_2025.jsonl")
save_jsonl(licenses, raw_dir / "business_licenses_2025_overlap.jsonl")
