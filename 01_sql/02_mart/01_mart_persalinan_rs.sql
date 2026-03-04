CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.persalinan_rs` AS

WITH base AS (
SELECT
  nosjp,
  nokapst,
  umur,
  jkpst,
  nmtkp,
  nmdati2layan AS kabupaten,
  kdppklayan AS provider_id,
  nmppklayan AS provider_name,
  kdinacbgs,
  nminacbgs,
  kddiagprimer,
  nmdiagprimer,
  diagsekunder,
  diag_sekunder_kode AS diag_sekunder,
  ARRAY_TO_STRING(prosedur_kode, ',') AS prosedur,
  tgldtgsjp AS tgl_masuk,
  tglplgsjp AS tgl_pulang,
  diag_primer_clean,
  diag_sekunder_kode,
  prosedur_kode,
  nmjnspulang,
  SAFE_CAST(biayaverifikasi AS NUMERIC) AS biayaverifikasi,

  -- paksa jadi array (aman untuk string/array)
  SPLIT(
    REGEXP_REPLACE(TO_JSON_STRING(diag_sekunder_kode), r'[\[\]"]', ''),
    ','
  ) AS diagsek_array,

  SPLIT(
    REGEXP_REPLACE(TO_JSON_STRING(prosedur_kode), r'[\[\]"]', ''),
    ','
  ) AS prosedur_array

FROM `bpjs-kediri.enriched.inacbgs_enriched`
),

-- ================= DETEKSI DELIVERY EVENT =================
flag_persalinan AS (
SELECT *,

CASE
  WHEN EXISTS (
        SELECT 1
        FROM UNNEST(diagsek_array) d
        WHERE TRIM(d) LIKE 'Z37%'
  ) THEN 1

  WHEN EXISTS (
        SELECT 1
        FROM UNNEST(prosedur_array) p
        WHERE LEFT(TRIM(p),2) IN ('74','72')
  ) THEN 1

  ELSE 0
END AS is_persalinan

FROM base
),

-- ================= KLASIFIKASI =================
klasifikasi AS (
SELECT *,

-- ================= METODE PERSALINAN =================
CASE
  -- SC
  WHEN EXISTS (
        SELECT 1 FROM UNNEST(prosedur_array) p
        WHERE LEFT(TRIM(p),2) = '74'
  )
       OR diag_primer_clean LIKE 'O82%'
       OR EXISTS (
            SELECT 1 FROM UNNEST(diagsek_array) d
            WHERE TRIM(d) LIKE 'O82%'
         )
  THEN 'SC'

  -- Vacuum / Forceps
  WHEN EXISTS (
        SELECT 1 FROM UNNEST(prosedur_array) p
        WHERE LEFT(TRIM(p),2) = '72'
  )
       OR diag_primer_clean LIKE 'O81%'
       OR EXISTS (
            SELECT 1 FROM UNNEST(diagsek_array) d
            WHERE TRIM(d) LIKE 'O81%'
         )
  THEN 'Vacuum/Forceps'

  -- Default → Normal
  ELSE 'Persalinan Normal'
END AS klasifikasi,

-- ================= TIPE KEHAMILAN =================
CASE
  WHEN diag_primer_clean LIKE 'O84%'
       OR EXISTS (
            SELECT 1 FROM UNNEST(diagsek_array) d
            WHERE TRIM(d) LIKE 'O84%'
         )
  THEN 'Multiple'
  ELSE 'Singleton'
END AS tipe_kehamilan

FROM flag_persalinan
WHERE is_persalinan = 1
),

-- ================= REMOVE DUPLICATE BY NOSJP =================
dedup_nosjp AS (
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY nosjp
            ORDER BY 
                tgl_pulang DESC,
                biayaverifikasi DESC
        ) AS rn
    FROM klasifikasi
)
WHERE rn = 1
)

SELECT
  nosjp,
  nokapst,
  umur,
  jkpst,
  nmtkp,
  kabupaten,
  provider_id,
  provider_name,
  kdinacbgs,
  nminacbgs,
  kddiagprimer,
  nmdiagprimer,
  diagsekunder,
  diag_sekunder,
  prosedur,
  tgl_masuk,
  tgl_pulang,
  'RS' AS jenis_faskes,
  diag_primer_clean,
  diag_sekunder_kode,
  prosedur_kode,
  nmjnspulang,
  biayaverifikasi,
  klasifikasi AS jenis_persalinan,
  tipe_kehamilan
FROM dedup_nosjp;