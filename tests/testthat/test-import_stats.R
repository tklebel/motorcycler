context("Test scraping of www.1000ps.at")
suppressPackageStartupMessages(library(dplyr))

# Import test-page once
hornet_link <- "http://www.1000ps.at/gebrauchte-motorraeder/marke/Honda/modell/Honda-CB-600-F-Hornet"


collected_data <- combine_collection(hornet_link, "Hornet 600")

test_that("price is scraped", {
  missing <- collected_data %>%
    dplyr::summarise_at("preis", funs(sum(is.na(.))))

  expect_false(identical(length(missing), length(collected_data$preis)))
  expect_type(collected_data$preis, "double")
})

test_that("ez is scraped", {
  missing <- collected_data %>%
    dplyr::summarise_at("ez", funs(sum(is.na(.))))

  expect_false(identical(length(missing), length(collected_data$ez)))
  expect_type(collected_data$ez, "double")
})

test_that("km is scraped", {
  missing <- collected_data %>%
    dplyr::summarise_at("km", funs(sum(is.na(.))))

  expect_false(identical(length(missing), length(collected_data$km)))
  expect_type(collected_data$km, "double")
})

test_that("Händler is scraped", {
  missing <- collected_data %>%
    dplyr::summarise_at("seller", funs(sum(is.na(.))))

  expect_false(identical(length(missing), length(collected_data$seller)))
  expect_type(collected_data$seller, "character")
  expect_match(collected_data$seller, "Händler|Privat")
})

test_that("bundesland is scraped", {
  missing <- collected_data %>%
    dplyr::summarise_at("bundesland", funs(sum(is.na(.))))
  bundesländer <- "Wien|Niederösterreich|Oberösterreich|Steiermark|Kärnten|Salzburg|Tirol|Vorarlberg"

  expect_false(identical(length(missing), length(collected_data$bundesland)))
  expect_type(collected_data$bundesland, "character")
  expect_match(collected_data$bundesland, bundesländer, all = F)
})

test_that("number of pages is correct", {
  kawa_link <- "http://www.1000ps.at/gebrauchte-motorraeder/marke/Kawasaki/modell/Kawasaki-ZR-7"

  expect_gt(get_page_numbers(hornet_link), 2)
  expect_equal(get_page_numbers(kawa_link), 1)
})


