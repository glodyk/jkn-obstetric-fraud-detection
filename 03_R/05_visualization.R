library(dplyr)
library(ggplot2)

overall_rate <- sum(provider_data$total_sc) /
  sum(provider_data$total_delivery)

provider_data <- provider_data %>%
  filter(total_delivery >= 30)

provider_data <- provider_data %>%
  mutate(
    se = sqrt((overall_rate * (1 - overall_rate)) / total_delivery),
    upper_95 = overall_rate + 1.96 * se,
    lower_95 = overall_rate - 1.96 * se
  ) %>%
  arrange(total_delivery)

ggplot(provider_data, aes(x = total_delivery, y = sc_rate)) +
  geom_point(aes(color = outlier), size = 3) +
  geom_line(aes(y = upper_95), linetype = "dashed") +
  geom_line(aes(y = lower_95), linetype = "dashed") +
  geom_hline(yintercept = overall_rate) +
  theme_minimal()

