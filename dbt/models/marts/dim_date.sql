WITH days AS (
    SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS day_offset
    FROM TABLE(GENERATOR(ROWCOUNT => 365))
),

calendar AS (
    SELECT DATEADD(DAY, day_offset, DATE '2025-01-01') AS date_day
    FROM days
)

SELECT
    date_day,
    YEAR(date_day) AS calendar_year,
    QUARTER(date_day) AS quarter_number,
    MONTH(date_day) AS month_number,
    MONTHNAME(date_day) AS month_name,
    DAY(date_day) AS day_of_month,
    DAYOFWEEKISO(date_day) AS weekday_number
FROM calendar
