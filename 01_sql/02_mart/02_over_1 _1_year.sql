CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.anomali_multi_delivery_year` AS
SELECT
  *,
  COUNT(*) OVER (
    PARTITION BY nokapst, EXTRACT(YEAR FROM tgl_pulang)
  ) AS delivery_in_year,

  CASE
    WHEN COUNT(*) OVER (
      PARTITION BY nokapst, EXTRACT(YEAR FROM tgl_pulang)
    ) > 1 THEN 1
    ELSE 0
  END AS flag_multi_delivery_year

FROM `bpjs-kediri.mart_prod.persalinan_sequence`;