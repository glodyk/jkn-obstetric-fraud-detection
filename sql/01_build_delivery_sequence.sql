-- =========================================================
-- JKN Obstetric Fraud Detection Project
-- File: 01_build_delivery_sequence.sql
-- Purpose: Construct patient-level delivery sequence
-- Author: Dody Goutama
-- Data Source: BPJS Kesehatan Claims (De-identified)
-- =========================================================

-- This script:
-- 1. Orders deliveries per patient
-- 2. Calculates inter-delivery interval
-- 3. Prepares anomaly detection dataset

CREATE OR REPLACE TABLE `bpjs-kediri.mart.delivery_sequence` AS
WITH seq AS (
SELECT
  *,
  
  ROW_NUMBER() OVER (
      PARTITION BY nokapst
      ORDER BY tgl_pulang
  ) AS delivery_order,

  LAG(tgl_pulang) OVER (
      PARTITION BY nokapst
      ORDER BY tgl_pulang
  ) AS prev_delivery_date

FROM `bpjs-kediri.mart.persalinan_all`
),

interval_calc AS (
SELECT
  *,
  DATE_DIFF(tgl_masuk, prev_delivery_date, DAY) AS interval_days
FROM seq
)

SELECT
  *,

  CASE
    WHEN interval_days IS NULL THEN 'FIRST DELIVERY'
    WHEN interval_days < 0 THEN 'IMPOSSIBLE'
    WHEN interval_days < 180 THEN 'BIOLOGICALLY IMPOSSIBLE'
    WHEN interval_days < 240 THEN 'EXTREME PRETERM SUSPICIOUS'
    WHEN interval_days < 300 THEN 'VERY SHORT INTERVAL'
    WHEN interval_days < 600 THEN 'SHORT BIRTH SPACING'
    WHEN interval_days < 900 THEN 'NORMAL'
    ELSE 'LONG INTERVAL'
  END AS kategori_interval

FROM interval_calc;