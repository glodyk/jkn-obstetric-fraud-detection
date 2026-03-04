CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.persalinan_clean` AS

SELECT
    *,
    CASE
        WHEN jenis_persalinan = 'Persalinan'
             OR jenis_persalinan = 'Persalinan Normal'
        THEN 'SPONTAN'

        WHEN jenis_persalinan = 'SC'
        THEN 'SC'

        WHEN jenis_persalinan = 'Vacuum/Forceps'
        THEN 'OPERATIF_VAGINAL'

        ELSE 'LAINNYA'
    END AS metode_clean
FROM `bpjs-kediri.mart_prod.persalinan_all`;