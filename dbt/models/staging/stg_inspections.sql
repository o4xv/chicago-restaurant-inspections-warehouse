SELECT
    RAW_RECORD:inspection_id::STRING AS inspection_id,
    TRIM(RAW_RECORD:dba_name::STRING) AS dba_name,
    TRIM(RAW_RECORD:aka_name::STRING) AS aka_name,
    RAW_RECORD:license_::STRING AS license_number,
    RAW_RECORD:facility_type::STRING AS facility_type,
    RAW_RECORD:risk::STRING AS risk,
    TRIM(RAW_RECORD:address::STRING) AS address,
    TRIM(RAW_RECORD:city::STRING) AS city,
    TRIM(RAW_RECORD:state::STRING) AS state,
    TRIM(RAW_RECORD:zip::STRING) AS zip_code,
    MD5(
        COALESCE(TRIM(RAW_RECORD:address::STRING), '') || '|' ||
        COALESCE(TRIM(RAW_RECORD:city::STRING), '') || '|' ||
        COALESCE(TRIM(RAW_RECORD:state::STRING), '') || '|' ||
        COALESCE(TRIM(RAW_RECORD:zip::STRING), '')
    ) AS location_key,
    TRY_TO_DATE(LEFT(RAW_RECORD:inspection_date::STRING, 10)) AS inspection_date,
    RAW_RECORD:inspection_type::STRING AS inspection_type,
    RAW_RECORD:results::STRING AS result,
    RAW_RECORD:violations::STRING AS violations,
    TRY_TO_DOUBLE(RAW_RECORD:latitude::STRING) AS latitude,
    TRY_TO_DOUBLE(RAW_RECORD:longitude::STRING) AS longitude
FROM {{ source('chicago', 'INSPECTIONS_RAW') }}
