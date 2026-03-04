CREATE OR REPLACE TABLE `bpjs-kediri.staging.non_kapitasi_stg1` AS

SELECT
  s.*,

  -- =========================
  -- FLAG LAYANAN (multi-label)
  -- =========================

  REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'PERSALINAN\b|KEGUGURAN\b') AS flag_persalinan,
  REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'RAWAT[-\s/:]*INAP') AS flag_rawat_inap,
  REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'PRA[-\s/:]*RUJUKAN') AS flag_prarujukan,
  REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'ANC\b|PELAYANAN[-\s/:]*ANC') AS flag_anc,
  REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'PNC\b|PELAYANAN[-\s/:]*PNC') AS flag_pnc,
  REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'AMBULANS|AMBULANCE|EVAKUASI') AS flag_ambulans,
  REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'PROTESA[-\s/:]*GIGI') AS flag_protesa_gigi,
  REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'KB\b|IUD\b|IMPLANT\b') AS flag_kb,
  REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'HBA1C\b|TRIGLISERIDA\b|PRB[-\s/:]*PROLANIS|UREUM\b|KREATININ\b|KOLESTEROL\b|MICROALBUMINURIA\b') AS flag_prolanis,
  REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'SKRINING\b|IVA\b|KRIO[-\s/:]*TERAPI|PAP\s*SMEAR|PAPSMEAR\b') AS flag_skrining,

  -- =========================
  -- KLASIFIKASI UTAMA
  -- =========================

  CASE

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'PERSALINAN\b|KEGUGURAN\b')
    THEN 'Persalinan'

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'RAWAT[-\s/:]*INAP')
    THEN 'Rawat Inap'

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'PRA[-\s/:]*RUJUKAN')
    THEN 'Pra-Rujukan'

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'ANC\b|PELAYANAN[-\s/:]*ANC')
       AND REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'PNC\b|PELAYANAN[-\s/:]*PNC')
    THEN 'ANC dan PNC'

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'ANC\b|PELAYANAN[-\s/:]*ANC')
    THEN 'ANC'

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'PNC\b|PELAYANAN[-\s/:]*PNC')
    THEN 'PNC'

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'SKRINING\b|IVA\b|KRIO[-\s/:]*TERAPI|PAP\s*SMEAR|PAPSMEAR\b')
    THEN 'Skrining Sekunder'

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'KB\b|IUD\b|IMPLANT\b')
    THEN 'KB'

  WHEN UPPER(TRIM(IFNULL(s.nmtkp,''))) = 'PROMOTIF'
    THEN 'Prolanis'

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'HBA1C\b|TRIGLISERIDA\b|PRB[-\s/:]*PROLANIS|UREUM\b|KREATININ\b|KOLESTEROL\b|MICROALBUMINURIA\b')
    THEN 'Prolanis'

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'PROTESA[-\s/:]*GIGI')
    THEN 'Protesa Gigi'

  WHEN REGEXP_CONTAINS(UPPER(IFNULL(s.nmtindakan,'')), r'AMBULANS|AMBULANCE|EVAKUASI')
    THEN 'Ambulans'

  ELSE 'Salah klasifikasi'

  END AS klasifikasi_kunjungan

FROM `bpjs-kediri.staging.non_kapitasi_stg` s;