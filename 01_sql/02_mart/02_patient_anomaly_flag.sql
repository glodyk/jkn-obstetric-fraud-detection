CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.patient_anomaly` AS
SELECT *,
  CASE
    WHEN interval_days IS NULL THEN 'FIRST_DELIVERY'
    WHEN interval_days < 150 THEN 'IMPOSSIBLE'
    WHEN interval_days BETWEEN 150 AND 179 THEN 'EXTREME'
    WHEN interval_days BETWEEN 180 AND 239 THEN 'SUSPICIOUS'
    ELSE 'NORMAL'
  END AS anomaly_flag
FROM `bpjs-kediri.mart_prod.persalinan_sequence`;