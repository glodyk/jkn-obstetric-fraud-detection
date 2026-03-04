CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.baseline_kc_kediri` AS
SELECT
  COUNT(*) AS total_interval,
  AVG(interval_days) AS mean_interval,
  STDDEV(interval_days) AS sd_interval,
  APPROX_QUANTILES(interval_days, 10) AS decile_distribution,
  MIN(interval_days) AS min_interval,
  MAX(interval_days) AS max_interval
FROM `bpjs-kediri.mart_prod.persalinan_sequence`
WHERE interval_days IS NOT NULL;