library(dplyr)

combined_data <- readr::read_rds("../data-combined/combined_data.rds")

# find motorcycles with changed price
augmented <- combined_data %>%
  group_by(id) %>%
  mutate(preis_min = min(preis),
         preis_max = max(preis),
         preis_changed = !identical(preis_min, preis_max)) %>%
  ungroup()

# fix lazy description from first two days of data collection
augmented <- augmented %>%
  mutate(motorrad = recode(motorrad, `Honda Hornet` = "Honda Hornet 600",
                           .default = motorrad))

readr::write_rds(augmented, "../data-combined/augmented.rds")
