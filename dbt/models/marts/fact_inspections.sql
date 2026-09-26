SELECT
    inspections.inspection_id,
    inspections.inspection_date,
    inspections.location_key,
    links.license_record_id,
    inspections.license_number,
    inspections.dba_name,
    inspections.facility_type,
    inspections.risk,
    inspections.inspection_type,
    inspections.result,
    inspections.violations,
    inspections.latitude,
    inspections.longitude
FROM {{ ref('stg_inspections') }} AS inspections
LEFT JOIN {{ ref('inspection_license_links') }} AS links
    ON inspections.inspection_id = links.inspection_id
