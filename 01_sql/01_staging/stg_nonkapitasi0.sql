-- =====================================================
-- STAGING NON KAPITASI
-- 1 baris = 1 kunjungan (nosjp)
-- =====================================================

CREATE OR REPLACE TABLE `bpjs-kediri.staging.non_kapitasi_stg`
PARTITION BY DATE_TRUNC(tgl_kunjungan, MONTH)
CLUSTER BY nosjp
AS

WITH agg AS (
SELECT
  nosjp,
  STRING_AGG(DISTINCT CAST(nokapst AS STRING), ';') AS nokapst,
  STRING_AGG(DISTINCT jkpst, ';') AS jkpst,
  MAX(umur) AS umur,
  STRING_AGG(DISTINCT rangeumur, ';') AS rangeumur,
  STRING_AGG(DISTINCT segmen, ';') AS segmen,
  STRING_AGG(DISTINCT nmpks, ';') AS nmpks,
  STRING_AGG(DISTINCT nmtkp, ';') AS nmtkp,
  STRING_AGG(DISTINCT nmdati2layan, ';') AS nmdati2layan,
  STRING_AGG(DISTINCT jenisppklayan, ';') AS jenisppklayan,
  STRING_AGG(DISTINCT typeppklayan, ';') AS typeppklayan,
  STRING_AGG(DISTINCT kdppklayan, ';') AS kdppklayan,
  STRING_AGG(DISTINCT nmppklayan, ';') AS nmppklayan,
  STRING_AGG(DISTINCT kddiagnosa, ';') AS kddiagnosa,
  STRING_AGG(DISTINCT nmdiagnosa, ';') AS nmdiagnosa,

  MIN(SAFE_CAST(tglpelayanan AS DATE)) AS tglpelayanan,
  MIN(SAFE_CAST(tglkunjungan AS DATE)) AS tglkunjungan,
  MAX(SAFE_CAST(tglpulang AS DATE)) AS tglpulang,
  MIN(SAFE_CAST(tgltindakan AS DATE)) AS tgltindakan,
  MIN(SAFE_CAST(tglbayar AS DATE)) AS tglbayar,
  MIN(SAFE_CAST(tglstjkeu AS DATE)) AS tglstjkeu,

  STRING_AGG(DISTINCT nmtindakan, ';') AS nmtindakan,
  STRING_AGG(DISTINCT jnsnakes, ';') AS jnsnakes,
  STRING_AGG(DISTINCT namanakes, ';') AS namanakes,
  STRING_AGG(DISTINCT nmstatuspulang, ';') AS nmstatuspulang,
  STRING_AGG(DISTINCT status_fpk, ';') AS status_fpk,

  MIN(lmstjklaim) AS lmstjklaim,
  SUM(SAFE_CAST(biaya AS NUMERIC)) AS biaya

FROM `bpjs-kediri.raw.nonkapitasi_ext`
WHERE tglstjkeu IS NOT NULL
  AND biaya IS NOT NULL
  AND SAFE_CAST(biaya AS FLOAT64) > 0
GROUP BY nosjp
),

final AS (
SELECT
  *,
  COALESCE(tglkunjungan, tglpelayanan, tglstjkeu) AS tgl_kunjungan
FROM agg
)

SELECT *
FROM final;