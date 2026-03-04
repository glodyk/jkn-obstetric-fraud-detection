CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.persalinan_provider_risk_final` AS
WITH regional AS (
  SELECT
    AVG(impossible_rate) AS mean_rate,
    STDDEV(impossible_rate) AS sd_rate
  FROM `bpjs-kediri.mart_prod.persalinan_provider_risk`
)

SELECT
  p.*,
  (p.impossible_rate - r.mean_rate) / r.sd_rate AS z_score
FROM `bpjs-kediri.mart_prod.persalinan_provider_risk` p
CROSS JOIN regional r;