-- External RAW layer (Cloud Storage connector)
CREATE OR REPLACE EXTERNAL TABLE `bpjs-kediri.raw.nonkapitasi_ext`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://bpjs-kediri/raw/non_kapitasi/raw/*']
);