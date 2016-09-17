library(rvest)
library(purrr)
library(stringr)


# get first path for hornet

hornet_link <- "http://www.1000ps.at/gebrauchte-motorraeder/marke/Honda/modell/Honda-CB-600-F-Hornet"

normalinserat <- hornet_link %>%
  extract_inserat()

# get number of pages
pages <- get_page_numbers(hornet_link)

# create links
hornet_links <- paste0(hornet_link, "/seite/", 1:pages)


# need to repair extraction of stats
hornet_pages <- scrape_page(hornet_link)

map(hornet_pages, extract_stats)


# ID
find_ids(normalinserat)


# händler oder privat
find_seller(normalinserat)


# Bundesland
normalinserat %>%
  find_bundesland()

# preis
normalinserat %>%
  find_price()

# weitere daten
normalinserat %>%
  html_node(".techdata") %>%
  html_text()

# km
normalinserat %>%
  find_km()

# Erstzulassung
normalinserat %>%
  find_erstzulassung()

# combine functions -----
hornet_pages <- scrape_page(hornet_link)

hornet_stats <- hornet_pages %>%
  map(extract_stats) %>%
  dplyr::bind_rows() %>%
  dplyr::mutate(motorrad = "Honda Hornet")

combine_collection(hornet_link, "Honda Hornet")




# funktioniert mittlerweile schon -----
premiuminserat <- hornet_link %>%
  xml2::read_html() %>%
  extract_inserat(css = ".premiuminserat")


find_ids(premiuminserat)
find_price(premiuminserat, css = ".premiumprice")
find_km(premiuminserat, premium = T)
find_erstzulassung(premiuminserat, premium = T)
find_bundesland(premiuminserat, premium = T)
find_seller(premiuminserat, T)

hornet_pages[[2]] %>%
  extract_inserat(css = ".premiuminserat") %>% length()


# Ebene tiefer ----
# - Einstellungsdatum
# - Anzahl der Klicks
# - Adresse

# TODO ----
# Tests, mit automatischer Mail, falls eine unerwartet hohe Zahl an NAs auftritt
