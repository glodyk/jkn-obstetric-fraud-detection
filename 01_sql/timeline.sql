CREATE OR REPLACE TABLE mart.persalinan_interval AS
SELECT
  *,
  LAG(tgl_pulang) OVER (PARTITION BY nokapst ORDER BY tgl_pulang) AS tgl_prev,
  DATE_DIFF(
      tgl_pulang,
      LAG(tgl_pulang) OVER (PARTITION BY nokapst ORDER BY tgl_pulang),
      DAY
  ) AS interval_days
FROM mart.persalinan_all;