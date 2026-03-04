library(bigrquery)
library(DBI)

project_id <- "bpjs-kediri"

bq_auth()  # atau service account

con <- dbConnect(
  bigquery(),
  project = project_id,
  dataset = "mart_prod",
  billing = project_id
)

con