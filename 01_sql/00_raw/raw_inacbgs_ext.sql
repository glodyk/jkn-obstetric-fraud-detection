CREATE OR REPLACE EXTERNAL TABLE `bpjs-kediri.raw.inacbgs_ext`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://bpjs-kediri/raw/inacbgs/raw/*']
);