CREATE OR REPLACE VIEW `bpjs-kediri.enriched.inacbgs_enriched` AS

-- =========================================================
-- 1. REMOVE DUPLICATE CLAIM (PENTING SEKALI)
-- =========================================================
WITH dedup_claim AS (
SELECT *
FROM (
    SELECT
        k.*,
        ROW_NUMBER() OVER(
            PARTITION BY k.nosjp
            ORDER BY 
                tgldtgsjp DESC,
                tglplgsjp DESC
        ) AS rn
    FROM `bpjs-kediri.staging.inacbgs_stg` k
)
WHERE rn = 1
),


-- ================= BASE =================
base AS (
SELECT
    k.*,
    `bpjs-kediri.reference.norm_icd`(k.kddiagprimer) AS diag_primer_clean
FROM `bpjs-kediri.staging.inacbgs_stg` k
),

-- ================= DIAGNOSIS PRIMER =================
diag_primer AS (
SELECT
    b.*,
    d.icd10 AS diag_primer_kode,
    d.title AS diag_primer_nama,
    d.chapter_title AS diag_primer_chapter,
    d.block_title AS diag_primer_group
    
FROM base b
LEFT JOIN `bpjs-kediri.reference.icd10_map` d
  ON d.match_code = b.diag_primer_clean

-- pilih ICD paling spesifik (hindari duplikasi baris)
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY b.nosjp
    ORDER BY LENGTH(d.icd10) DESC NULLS LAST
) = 1
),

-- ================= DIAGNOSIS SEKUNDER =================
diag_secondary AS (
SELECT
    p.nosjp,

    -- kode komorbid
    ARRAY_AGG(DISTINCT d.icd10 IGNORE NULLS) AS diag_sekunder_kode,
    ARRAY_AGG(DISTINCT d.title IGNORE NULLS) AS diag_sekunder_nama

FROM diag_primer p
LEFT JOIN UNNEST(SPLIT(p.diagsekunder,';')) AS sec ON TRUE

-- ambil kode sebelum " - "
LEFT JOIN `bpjs-kediri.reference.icd10_map` d
  ON d.match_code =
     `bpjs-kediri.reference.norm_icd`(
         TRIM(SPLIT(sec,'-')[SAFE_OFFSET(0)])
     )

GROUP BY p.nosjp
),

-- ================= PROSEDUR =================
procedure_map AS (
SELECT
    p.nosjp,

    -- kode tindakan
    ARRAY_AGG(DISTINCT r.icd9cm IGNORE NULLS) AS prosedur_kode,
    ARRAY_AGG(DISTINCT r.LONG_DESC IGNORE NULLS) AS prosedur_nama

FROM diag_primer p

LEFT JOIN UNNEST(SPLIT(p.prosedur,';')) AS proc ON TRUE

-- ambil kode sebelum " - "
LEFT JOIN `bpjs-kediri.reference.icd9cm` r
  ON r.icd9cm =
     `bpjs-kediri.reference.norm_icd`(
        TRIM(SPLIT(proc,'-')[SAFE_OFFSET(0)])
     )

GROUP BY p.nosjp
)

-- ================= FINAL =================
SELECT
    p.*,
    s.diag_sekunder_kode,
    s.diag_sekunder_nama,
    pr.prosedur_kode,
    pr.prosedur_nama
FROM diag_primer p
LEFT JOIN diag_secondary s USING(nosjp)
LEFT JOIN procedure_map pr USING(nosjp);