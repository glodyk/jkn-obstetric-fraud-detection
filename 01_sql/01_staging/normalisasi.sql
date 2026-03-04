CREATE OR REPLACE FUNCTION `bpjs-kediri.reference.norm_icd`(code STRING)
RETURNS STRING
AS (
  UPPER(
    REPLACE(
      REGEXP_EXTRACT(TRIM(code), r'^[A-Za-z][0-9A-Za-z\.]*|^[0-9]+'),
      '.',
      ''
    )
  )
);