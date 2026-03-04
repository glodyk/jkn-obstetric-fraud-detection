CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.persalinan_double_claim` AS
WITH ordered AS (
SELECT
  *,
  LAG(jenis_faskes) OVER(PARTITION BY nokapst ORDER BY tgl_pulang) AS prev_faskes,
  LAG(tgl_pulang) OVER(PARTITION BY nokapst ORDER BY tgl_pulang) AS prev_delivery
FROM `bpjs-kediri.mart_prod.persalinan_sequence`
)

SELECT *,
  DATE_DIFF(tgl_pulang, prev_delivery, DAY) AS diff_days,

  CASE
    WHEN prev_faskes IS NOT NULL
     AND jenis_faskes <> prev_faskes
     AND DATE_DIFF(tgl_pulang, prev_delivery_date, DAY) <= 3
    THEN 1
    ELSE 0
  END AS flag_double_claim

FROM ordered;