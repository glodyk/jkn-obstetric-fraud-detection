SELECT
  column_name,
  ordinal_position
FROM `bpjs-kediri.mart_prod`.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'persalinan_rs'
ORDER BY ordinal_position;