SELECT
    license_record_id,
    license_number,
    COALESCE(doing_business_as_name, legal_name) AS business_name,
    legal_name,
    address,
    city,
    state,
    zip_code,
    community_area_name,
    neighborhood,
    application_type,
    license_status,
    license_start_date,
    expiration_date
FROM {{ ref('stg_business_licenses') }}
