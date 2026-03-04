CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.kunjungan` AS
SELECT
    nokapst,
    nosjp,
    tgldtgsjp,
    tglplgsjp,
    nmdati2layan,
    nmtkp,
    kelashak,
    jkpst,
    umur,
    nmppklayan,
    politujsjp,
    kddiagprimer,
    nmdiagprimer,
    diagsekunder,
    prosedur,
    kdinacbgs,
    nminacbgs,
    klsrawat,
    kelasrsmenkes,
    namadpjp,
    nmjnspulang,
    biayars,
    biayaverifikasi,
    (biayars - biayaverifikasi) AS selisih_klaim
FROM `bpjs-kediri.staging.inacbgs_stg`
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY nosjp
    ORDER BY tglplgsjp DESC, tgldtgsjp DESC
) = 1;