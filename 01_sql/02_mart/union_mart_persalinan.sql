CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.persalinan_all` AS

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
  jenis_faskes,
  diag_primer_clean,
  diag_sekunder_kode,
  prosedur_kode,
  nmjnspulang,
  biayaverifikasi,
  jenis_persalinan,
  tipe_kehamilan
FROM `bpjs-kediri.mart_prod.persalinan_rs`
WHERE DATE(tgl_pulang) >= DATE '2023-01-01'

UNION ALL

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
  jenis_faskes,
  diag_primer_clean,
  diag_sekunder_kode,
  prosedur_kode,
  nmjnspulang,
  biayaverifikasi,
  jenis_persalinan,
  tipe_kehamilan
FROM `bpjs-kediri.mart_prod.persalinan_fktp_match_rs`
WHERE DATE(tgl_pulang) >= DATE '2023-01-01';