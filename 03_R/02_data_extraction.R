library(dplyr)
library(dbplyr)

source("R/01_connect_bigquery.R")

persalinan_all <- tbl(con, "persalinan_all") %>% collect()
sequence_data  <- tbl(con, "persalinan_sequence") %>% collect()
provider_data  <- tbl(con, "provider_risk_agg") %>% collect()

saveRDS(provider_data, "data/processed/provider_data.rds")
