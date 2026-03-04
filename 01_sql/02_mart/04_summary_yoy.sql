CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.persalinan_yoy_summary` AS

WITH base AS (
  SELECT
    EXTRACT(YEAR FROM tgl_pulang) AS year,
    provider_name,
    jenis_persalinan,
    biayaverifikasi,
    interval_days,
    nokapst
  FROM `bpjs-kediri.mart_prod.persalinan_sequence`
),

yearly AS (
  SELECT
    year,
    COUNT(*) AS total_persalinan,
    COUNT(DISTINCT nokapst) AS total_pasien,
    SAFE_DIVIDE(
  SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END),
  COUNT(*)
) AS sc_rate,
    AVG(biayaverifikasi) AS rata_biaya,
    APPROX_QUANTILES(interval_days, 2)[OFFSET(1)] AS median_interval
  FROM base
  GROUP BY year
),

with_growth AS (
  SELECT
    *,
    LAG(total_persalinan) OVER (ORDER BY year) AS prev_total,
    LAG(sc_rate) OVER (ORDER BY year) AS prev_sc_rate,
    LAG(rata_biaya) OVER (ORDER BY year) AS prev_biaya
  FROM yearly
)

SELECT
  year,
  total_persalinan,
  total_pasien,
  sc_rate * 100 AS sc_rate_percent,
  rata_biaya,
  median_interval,
  SAFE_DIVIDE(total_persalinan - prev_total, prev_total) * 100 AS yoy_volume_growth_pct,
  SAFE_DIVIDE(sc_rate - prev_sc_rate, prev_sc_rate) * 100 AS yoy_sc_growth_pct,
  SAFE_DIVIDE(rata_biaya - prev_biaya, prev_biaya) * 100 AS yoy_cost_growth_pct
FROM with_growth
ORDER BY year;