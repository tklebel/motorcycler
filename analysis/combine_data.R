library(dplyr)
library(readr)
library(purrr)

files <- list.files("../data-chunks/", full.names = T)

combined_data <- map(files, read_rds) %>%
  bind_rows()

write_rds(combined_data, "../data-combined/combined_data.rds")

