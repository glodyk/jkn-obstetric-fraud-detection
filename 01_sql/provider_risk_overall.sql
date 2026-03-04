CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.provider_risk_overall` AS

SELECT
    provider_id,
    provider_name,
    kabupaten,
    COUNT(*) AS total_delivery,
    SUM(CASE WHEN metode_clean = 'SC' THEN 1 ELSE 0 END) AS total_sc,
    SAFE_DIVIDE(
        SUM(CASE WHEN metode_clean = 'SC' THEN 1 ELSE 0 END),
        COUNT(*)
    ) AS sc_rate
FROM `bpjs-kediri.mart_prod.persalinan_clean`
GROUP BY 1,2,3;