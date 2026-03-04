CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.sc_monitoring_kabupaten` AS

-- =========================================
-- 1️⃣ BASE AGREGASI
-- =========================================
WITH base AS (
  SELECT
      kabupaten,
      EXTRACT(YEAR FROM tgl_pulang) AS tahun,
      COUNT(*) AS total_persalinan,
      SUM(CASE WHEN jenis_persalinan = 'SC' THEN 1 ELSE 0 END) AS total_sc
  FROM `bpjs-kediri.mart_prod.persalinan_all`
  GROUP BY 1,2
),

-- =========================================
-- 2️⃣ HITUNG RATE
-- =========================================
rate_calc AS (
  SELECT
      kabupaten,
      tahun,
      total_persalinan,
      total_sc,
      SAFE_DIVIDE(total_sc, total_persalinan) AS sc_rate
  FROM base
),

-- =========================================
-- 3️⃣ HITUNG MEAN & SD PER TAHUN
-- =========================================
year_stats AS (
  SELECT
      tahun,
      AVG(sc_rate) AS mean_sc_rate,
      STDDEV_POP(sc_rate) AS sd_sc_rate
  FROM rate_calc
  GROUP BY tahun
)

-- =========================================
-- 4️⃣ FINAL DATASET
-- =========================================
SELECT
    r.kabupaten,
    r.tahun,
    r.total_persalinan,
    r.total_sc,
    r.sc_rate,

    -- WHO Benchmark
    CASE 
        WHEN r.sc_rate < 0.10 THEN 'Below WHO (Underuse)'
        WHEN r.sc_rate BETWEEN 0.10 AND 0.15 THEN 'Within WHO Target'
        WHEN r.sc_rate > 0.15 THEN 'Above WHO (Potential Overuse)'
    END AS who_flag,

    -- Statistik Populasi
    y.mean_sc_rate,
    y.sd_sc_rate,

    -- Z-Score (aman dari pembagi nol)
    SAFE_DIVIDE(
        r.sc_rate - y.mean_sc_rate,
        NULLIF(y.sd_sc_rate,0)
    ) AS z_score,

    -- Outlier Flag (|z| ≥ 2)
    CASE
        WHEN ABS(
            SAFE_DIVIDE(
                r.sc_rate - y.mean_sc_rate,
                NULLIF(y.sd_sc_rate,0)
            )
        ) >= 2 THEN 'Outlier'
        ELSE 'Normal'
    END AS outlier_flag,

    -- Control Chart Limits
    y.mean_sc_rate + (3 * y.sd_sc_rate) AS ucl_3sd,
    y.mean_sc_rate - (3 * y.sd_sc_rate) AS lcl_3sd

FROM rate_calc r
LEFT JOIN year_stats y
ON r.tahun = y.tahun

-- Filter volume minimum supaya stabil
WHERE r.total_persalinan >= 3000;