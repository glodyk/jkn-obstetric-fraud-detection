CREATE OR REPLACE VIEW `bpjs-kediri.mart_prod.persalinan_fktp_match_rs` AS
SELECT
  CAST(nosjp AS STRING) AS nosjp,
  CAST(nokapst AS STRING) AS nokapst,
  CAST(umur AS INT64) AS umur,
  CAST(jkpst AS STRING) AS jkpst,
  CAST(nmtkp AS STRING) AS nmtkp,
  CAST(kabupaten AS STRING) AS kabupaten,

  CAST(provider_id AS STRING) AS provider_id,
  CAST(provider_name AS STRING) AS provider_name,

  -- RS only → null
  CAST(NULL AS STRING) AS kdinacbgs,
  CAST(NULL AS STRING) AS nminacbgs,

  CAST(kddiagprimer AS STRING) AS kddiagprimer,
  CAST(nmdiagprimer AS STRING) AS nmdiagprimer,

  CAST(diagsekunder AS STRING) AS diagsekunder,
  ARRAY<STRING>[] AS diag_sekunder,

  CAST(prosedur AS STRING) AS prosedur,
  ARRAY<STRING>[] AS prosedur_kode,

  DATE(tgl_masuk) AS tgl_masuk,
  DATE(tgl_pulang) AS tgl_pulang,

  CAST(jenis_faskes AS STRING) AS jenis_faskes,

  CAST(NULL AS STRING) AS diag_primer_clean,
  ARRAY<STRING>[] AS diag_sekunder_kode,

  CAST(nmjnspulang AS STRING) AS nmjnspulang,

  CAST(biayaverifikasi AS NUMERIC) AS biayaverifikasi,

  CAST(jenis_persalinan AS STRING) AS jenis_persalinan,

  CAST(NULL AS STRING) AS tipe_kehamilan

FROM `bpjs-kediri.mart_prod.persalinan_fktp`;