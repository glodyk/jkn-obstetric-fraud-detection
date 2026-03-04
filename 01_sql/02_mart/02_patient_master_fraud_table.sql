CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.agg_patient_anomaly` AS
SELECT
  a.*,
  b.flag_multi_delivery_year,
  c.flag_double_claim

FROM `bpjs-kediri.mart_prod.patient_anomaly` a
LEFT JOIN `bpjs-kediri.mart_prod.anomali_multi_delivery_year` b
USING(nokapst, nosjp, tgl_pulang)
LEFT JOIN `bpjs-kediri.mart_prod.persalinan_double_claim` c
USING(nokapst, nosjp, tgl_pulang);