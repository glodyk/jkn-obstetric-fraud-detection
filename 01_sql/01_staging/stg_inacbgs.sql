CREATE OR REPLACE TABLE `bpjs-kediri.staging.inacbgs_stg`
PARTITION BY bulan_klaim
CLUSTER BY nosjp
AS

WITH base AS (
    SELECT
        t.*,
        TRIM(CAST(nosjp AS STRING)) AS nosjp_clean
    FROM `bpjs-kediri.raw.inacbgs_ext` t
),

dedup AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY nosjp_clean
            ORDER BY 
                SAFE_CAST(tglplgsjp AS DATE) DESC,
                SAFE_CAST(tglstjkeu AS DATE) DESC
        ) AS rn
    FROM base
)

SELECT
    CAST(nokapst AS STRING) AS nokapst,
    nosjp_clean AS nosjp,

    `bpjs-kediri.util.clean_str`(CAST(jkpst AS STRING)) AS jkpst,
    SAFE_CAST(`bpjs-kediri.util.clean_str`(CAST(umur AS STRING)) AS INT64) AS umur,

    `bpjs-kediri.util.clean_str`(CAST(kelashak AS STRING)) AS kelashak,
    `bpjs-kediri.util.clean_str`(CAST(klsrawat AS STRING)) AS klsrawat,
    `bpjs-kediri.util.clean_str`(CAST(kelasrsmenkes AS STRING)) AS kelasrsmenkes,

    `bpjs-kediri.util.clean_str`(CAST(kdppklayan AS STRING)) AS kdppklayan,
    `bpjs-kediri.util.clean_str`(CAST(kdppkperujuk AS STRING)) AS kdppkperujuk,
    `bpjs-kediri.util.clean_str`(CAST(nmtkp AS STRING)) AS nmtkp,
    `bpjs-kediri.util.clean_str`(CAST(nmppklayan AS STRING)) AS nmppklayan,
    `bpjs-kediri.util.clean_str`(CAST(nmppkperujuk AS STRING)) AS nmppkperujuk,
    `bpjs-kediri.util.clean_str`(CAST(politujsjp AS STRING)) AS politujsjp,
    `bpjs-kediri.util.clean_str`(CAST(nmdati2layan AS STRING)) AS nmdati2layan,
    `bpjs-kediri.util.clean_str`(CAST(namadpjp AS STRING)) AS namadpjp,

    tgldtgsjp,
    tglplgsjp,
    SAFE_CAST(tglplgsjp AS DATE) AS tgl_pulang,
    tglstjkeu,
    
    `bpjs-kediri.util.clean_str`(CAST(kddiagprimer AS STRING)) AS kddiagprimer,
    `bpjs-kediri.util.clean_str`(CAST(nmdiagprimer AS STRING)) AS nmdiagprimer,
    `bpjs-kediri.util.clean_str`(CAST(diagsekunder AS STRING)) AS diagsekunder,
    `bpjs-kediri.util.clean_str`(CAST(procedure AS STRING)) AS prosedur,
    `bpjs-kediri.util.clean_str`(CAST(kdinacbgs AS STRING)) AS kdinacbgs,
    `bpjs-kediri.util.clean_str`(CAST(nminacbgs AS STRING)) AS nminacbgs,

    `bpjs-kediri.util.clean_str`(CAST(kdsa AS STRING)) AS kdsa,
    `bpjs-kediri.util.clean_str`(CAST(kdsd AS STRING)) AS kdsd,
    `bpjs-kediri.util.clean_str`(CAST(kdsi AS STRING)) AS kdsi,
    `bpjs-kediri.util.clean_str`(CAST(kdsp AS STRING)) AS kdsp,
    `bpjs-kediri.util.clean_str`(CAST(kdsr AS STRING)) AS kdsr,
    `bpjs-kediri.util.clean_str`(CAST(deskripsisd AS STRING)) AS deskripsisd,
    `bpjs-kediri.util.clean_str`(CAST(deskripsisi AS STRING)) AS deskripsisi,
    `bpjs-kediri.util.clean_str`(CAST(deskripsisp AS STRING)) AS deskripsisp,
    `bpjs-kediri.util.clean_str`(CAST(deskripsisr AS STRING)) AS deskripsisr,
    `bpjs-kediri.util.clean_str`(CAST(nmjnspulang AS STRING)) AS nmjnspulang,

    SAFE_CAST(biayaverifikasi AS NUMERIC) AS biayaverifikasi,
    SAFE_CAST(biayars AS NUMERIC) AS biayars,

    tglpelayanan AS bulan_klaim

FROM dedup
WHERE rn = 1;