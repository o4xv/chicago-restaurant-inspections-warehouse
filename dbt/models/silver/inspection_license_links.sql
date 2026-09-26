WITH candidate_matches AS (
    SELECT
        inspections.inspection_id,
        licenses.license_record_id,
        ROW_NUMBER() OVER (
            PARTITION BY inspections.inspection_id
            ORDER BY
                licenses.license_start_date DESC NULLS LAST,
                licenses.license_record_id DESC NULLS LAST
        ) AS match_rank
    FROM {{ ref('stg_inspections') }} AS inspections
    LEFT JOIN {{ ref('stg_business_licenses') }} AS licenses
        ON inspections.license_number = licenses.license_number
        AND inspections.inspection_date BETWEEN licenses.license_start_date
                                            AND licenses.expiration_date
)

SELECT
    inspection_id,
    license_record_id
FROM candidate_matches
WHERE match_rank = 1
