library(rvest)
library(purrr)
library(stringr)
library(dplyr)
library(motorcycler)

links <- list("http://www.1000ps.at/gebrauchte-motorraeder/marke/Honda/modell/Honda-CB-600-F-Hornet",
              "http://www.1000ps.at/gebrauchte-motorraeder/marke/Suzuki/modell/Suzuki-Bandit-600",
              "http://www.1000ps.at/gebrauchte-motorraeder/marke/Yamaha/modell/Yamaha-FZ-6N",
              "http://www.1000ps.at/gebrauchte-motorraeder/marke/Yamaha/modell/Yamaha-XJ6",
              "http://www.1000ps.at/gebrauchte-motorraeder/marke/Kawasaki/modell/Kawasaki-ZR-7",
              "http://www.1000ps.at/gebrauchte-motorraeder/marke/Kawasaki/modell/Kawasaki-Z-750",
              "http://www.1000ps.at/gebrauchte-motorraeder/marke/Suzuki/modell/Suzuki-Bandit-650")


motorcycles <- list("Honda Hornet",
                   "Suzuki Bandit 600",
                   "Yamaha FZ-6N",
                   "Yamaha XJ6",
                   "Kawasaki ZR-7",
                   "Kawasaki Z750",
                   "Suzuki Bandit 650")


daten <- pmap(list(links, motorcycles), combine_collection)


gesammelte_daten <- dplyr::bind_rows(daten) %>%
  mutate(fetched = Sys.time())

path <- paste0("../data-chunks/", Sys.Date(), ".rds")
readr::write_rds(gesammelte_daten, path = path)
