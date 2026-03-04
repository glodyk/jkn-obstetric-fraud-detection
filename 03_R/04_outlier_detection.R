library(dplyr)

provider_data <- tbl(con, "provider_risk_overall") %>%
  collect()

mean_sc <- mean(provider_data$sc_rate, na.rm = TRUE)
sd_sc   <- sd(provider_data$sc_rate, na.rm = TRUE)

provider_data <- provider_data %>%
  mutate(
    z_score = (sc_rate - mean_sc) / sd_sc,
    outlier = abs(z_score) > 2
  )