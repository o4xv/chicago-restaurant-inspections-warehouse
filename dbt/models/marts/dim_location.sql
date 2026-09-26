SELECT DISTINCT
    location_key,
    address,
    city,
    state,
    zip_code
FROM {{ ref('stg_inspections') }}
