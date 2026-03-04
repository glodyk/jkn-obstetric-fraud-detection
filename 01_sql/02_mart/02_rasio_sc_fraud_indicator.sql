-- WHO expected SC rate : 10–15%
-- Indonesia realistik : 20–35%

CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.provider_sc_rate` AS
SELECT
  provider_id,

  COUNT(*) AS total_delivery,

  SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END) AS total_sc,

  SAFE_DIVIDE(
    SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END),
    COUNT(*)
  ) AS sc_rate,

  CASE
    WHEN SAFE_DIVIDE(
      SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END),
      COUNT(*)
    ) >= 0.80 THEN 'EXTREME_OUTLIER'
    WHEN SAFE_DIVIDE(
      SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END),
      COUNT(*)
    ) >= 0.60 THEN 'HIGH'
    ELSE 'NORMAL'
  END AS sc_flag

FROM `bpjs-kediri.mart_prod.persalinan_sequence`
GROUP BY provider_id;