CREATE OR REPLACE TABLE `bpjs-kediri.mart_prod.persalinan_all` AS

SELECT *
FROM `bpjs-kediri.mart_prod.persalinan_rs`
WHERE DATE(tgl_pulang) >= DATE '2023-01-01'

UNION ALL

SELECT *
FROM `bpjs-kediri.mart_prod.persalinan_fktp_match_rs`
WHERE DATE(tgl_pulang) >= DATE '2023-01-01';