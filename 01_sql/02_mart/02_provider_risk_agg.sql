CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.provider_risk_agg` AS

SELECT
    kabupaten,
    provider_id,
    provider_name,
    EXTRACT(YEAR FROM tgl_pulang) AS tahun,
    COUNT(*) AS total_delivery,
    SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END) AS total_sc,
    SAFE_DIVIDE(
        SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END),
        COUNT(*)
    ) AS sc_rate
FROM `bpjs-kediri.mart_prod.persalinan_all`
GROUP BY 1,2,3,4;