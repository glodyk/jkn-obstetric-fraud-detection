CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.persalinan_fktp` AS

-- ================= BASE DATA =================
WITH base AS (
SELECT *
FROM `bpjs-kediri.staging.non_kapitasi_stg1`
WHERE klasifikasi_kunjungan = 'Persalinan'
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
                DATE(tglpulang) DESC,
                biaya DESC
        ) AS rn
    FROM base
)
WHERE rn = 1
)

-- ================= FINAL MART =================
SELECT
  -- Identitas episode
  nosjp,
  nokapst,
  umur,
  jkpst,
  nmtkp,

  -- Lokasi & provider
  nmdati2layan AS kabupaten,
  kdppklayan AS provider_id,
  nmppklayan AS provider_name,

  -- Jenis fasilitas
  jenisppklayan AS jenis_faskes,

  -- Diagnosis
  kddiagnosa AS kddiagprimer,
  nmdiagnosa AS nmdiagprimer,
  NULL AS diagsekunder,

  -- Tindakan (FKTP tidak punya ICD9CM → pakai nama tindakan)
  nmtindakan AS prosedur,

  -- Tanggal pelayanan
  DATE(tglkunjungan) AS tgl_masuk,
  DATE(tglpulang) AS tgl_pulang,

  -- Status pulang
  nmstatuspulang AS nmjnspulang,

  -- Biaya
  biaya AS biayaverifikasi,

  -- FKTP tidak punya INA-CBG
  NULL AS kdinacbgs,
  NULL AS nminacbgs,

  -- Jenis persalinan
  klasifikasi_kunjungan AS jenis_persalinan

FROM dedup_nosjp;