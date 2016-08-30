# erste Analysen -----
library(dplyr)
library(ggplot2)
library(GGally)
gesammelte_daten <- readr::read_rds("data-chunks/2016-08-28.rds")
with(gesammelte_daten, cor(preis, ez, use = "pairwise.complete.obs"))

hornet_stats %>%
  as.data.frame() %>%
  ggscatmat() +
  geom_smooth()


ggplot(gesammelte_daten, aes(ez, preis)) +
  geom_jitter(width = .4, height = .1) +
  geom_smooth(span = .8) +
  facet_wrap(~motorrad, scales = "free")

# explore combined data ------
# use joins to find data that changed?
library(ggplot2)
library(dplyr)
combined_data <- readr::read_rds("data-combined/combined_data.rds")

# gab es veränderungen im Preis?
ggplot(combined_data, aes(fetched, preis, group = id, colour = motorrad)) +
  geom_line()

combined_data %>%
  group_by(id) %>%
  mutate(changed = case_when(unique(.$preis) > 1 ~ "yes",
                             TRUE                ~ "no"))

augmented <- combined_data %>%
  group_by(id) %>%
  mutate(preis_min = min(preis),
         preis_max = max(preis),
         preis_changed = !identical(preis_min, preis_max)) %>%
  ungroup()

augmented %>%
  filter(preis_changed) %>%
  ggplot(aes(fetched, preis, group = id, colour = id)) +
  geom_line()

# Aktuellster Datensatz: augmented.rds
