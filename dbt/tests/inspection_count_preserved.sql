SELECT 1
WHERE (
    SELECT COUNT(*) FROM {{ ref('inspection_license_links') }}
) <> (
    SELECT COUNT(*) FROM {{ ref('stg_inspections') }}
)
