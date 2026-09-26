SELECT
    RAW_RECORD:id::STRING AS license_record_id,
    RAW_RECORD:license_number::STRING AS license_number,
    RAW_RECORD:account_number::STRING AS account_number,
    RAW_RECORD:site_number::STRING AS site_number,
    TRIM(RAW_RECORD:legal_name::STRING) AS legal_name,
    TRIM(RAW_RECORD:doing_business_as_name::STRING) AS doing_business_as_name,
    TRIM(RAW_RECORD:address::STRING) AS address,
    TRIM(RAW_RECORD:city::STRING) AS city,
    RAW_RECORD:state::STRING AS state,
    RAW_RECORD:zip_code::STRING AS zip_code,
    TRIM(RAW_RECORD:community_area_name::STRING) AS community_area_name,
    TRIM(RAW_RECORD:neighborhood::STRING) AS neighborhood,
    RAW_RECORD:application_type::STRING AS application_type,
    RAW_RECORD:license_status::STRING AS license_status,
    TRY_TO_DATE(LEFT(RAW_RECORD:license_start_date::STRING, 10)) AS license_start_date,
    TRY_TO_DATE(LEFT(RAW_RECORD:expiration_date::STRING, 10)) AS expiration_date,
    TRY_TO_DATE(LEFT(RAW_RECORD:date_issued::STRING, 10)) AS date_issued
FROM {{ source('chicago', 'BUSINESS_LICENSES_RAW') }}
