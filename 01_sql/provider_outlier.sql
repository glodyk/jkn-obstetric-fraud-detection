CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.provider_sc_outlier` AS

WITH base AS (
  SELECT
    EXTRACT(YEAR FROM tgl_pulang) AS year,
    jenis_faskes,
    jenis_persalinan,
  FROM `bpjs-kediri.mart_prod.persalinan_sequence`
),

provider_year AS (
  SELECT
    year,
    jenis_faskes,
    jenis_persalinan,
    COUNT(*) AS total_kasus,
    SAFE_DIVIDE(
  SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END),
  COUNT(*)
) AS sc_rate
  FROM base
  GROUP BY year, jenis_faskes, jenis_persalinan
),

stats AS (
  SELECT
    year,
    AVG(sc_rate) AS mean_sc,
    STDDEV(sc_rate) AS sd_sc
  FROM provider_year
  GROUP BY year
)

SELECT
  p.year,
  p.jenis_faskes,
  p.jenis_persalinan,
  p.total_kasus,
  p.sc_rate * 100 AS sc_rate_percent,
  (p.sc_rate - s.mean_sc) / s.sd_sc AS z_score,
  ABS((p.sc_rate - s.mean_sc) / s.sd_sc) > 2 AS is_outlier
FROM provider_year p
JOIN stats s USING (year)
ORDER BY year, sc_rate_percent DESC;