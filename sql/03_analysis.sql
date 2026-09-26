-- How did inspection volume and failures change by month in 2025?
SELECT
    dates.month_number,
    dates.month_name,
    COUNT(*) AS total_inspections,
    COUNT_IF(inspections.result = 'Fail') AS failed_inspections
FROM CHICAGO_RESTAURANT_DB.DBT_DEV_GOLD.FACT_INSPECTIONS AS inspections
JOIN CHICAGO_RESTAURANT_DB.DBT_DEV_GOLD.DIM_DATE AS dates
    ON inspections.inspection_date = dates.date_day
GROUP BY dates.month_number, dates.month_name
ORDER BY dates.month_number;

-- Which ZIP codes had the most failed inspections in 2025?
SELECT
    locations.zip_code,
    COUNT(*) AS total_inspections,
    COUNT_IF(inspections.result = 'Fail') AS failed_inspections
FROM CHICAGO_RESTAURANT_DB.DBT_DEV_GOLD.FACT_INSPECTIONS AS inspections
JOIN CHICAGO_RESTAURANT_DB.DBT_DEV_GOLD.DIM_LOCATION AS locations
    ON inspections.location_key = locations.location_key
WHERE locations.zip_code IS NOT NULL
GROUP BY locations.zip_code
ORDER BY failed_inspections DESC
LIMIT 10;

-- Which matched businesses had the most failed inspections in 2025?
SELECT
    licenses.license_number,
    licenses.business_name,
    COUNT(*) AS total_inspections,
    COUNT_IF(inspections.result = 'Fail') AS failed_inspections
FROM CHICAGO_RESTAURANT_DB.DBT_DEV_GOLD.FACT_INSPECTIONS AS inspections
JOIN CHICAGO_RESTAURANT_DB.DBT_DEV_GOLD.DIM_LICENSE_RECORD AS licenses
    ON inspections.license_record_id = licenses.license_record_id
GROUP BY licenses.license_number, licenses.business_name
HAVING COUNT_IF(inspections.result = 'Fail') > 0
ORDER BY failed_inspections DESC, total_inspections DESC
LIMIT 10;

-- How are inspection results distributed across risk categories in 2025?
SELECT
    inspections.risk,
    inspections.result,
    COUNT(*) AS total_inspections
FROM CHICAGO_RESTAURANT_DB.DBT_DEV_GOLD.FACT_INSPECTIONS AS inspections
GROUP BY inspections.risk, inspections.result
ORDER BY inspections.risk, total_inspections DESC;

-- Which inspection types had the most failed inspections in 2025?
SELECT
    inspections.inspection_type,
    COUNT(*) AS total_inspections,
    COUNT_IF(inspections.result = 'Fail') AS failed_inspections
FROM CHICAGO_RESTAURANT_DB.DBT_DEV_GOLD.FACT_INSPECTIONS AS inspections
GROUP BY inspections.inspection_type
ORDER BY failed_inspections DESC, total_inspections DESC
LIMIT 10;
