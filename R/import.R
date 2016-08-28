#' @export
#' @noRd
get_page_numbers <- function(link) {
  link %>%
    xml2::read_html() %>%
    rvest::html_node(".jumplistalt") %>%
    rvest::html_text() %>%
    stringr::str_count("\\d")
}

#' @export
#' @noRd
extract_inserat <- function(page, css = ".normalinserat") {
  page %>%
    rvest::html_nodes(css = css)
}

#' @export
#' @noRd
extract_css <- function(inserat, css) {
  inserat %>%
    html_node(css) %>%
    html_text()
}


scrape_page <- function(link) {
  number_of_pages <- get_page_numbers(link)

  # create links
  links <- paste0(hornet_link, "/seite/", seq_len(number_of_pages))
  pages <- map(links, xml2::read_html)

  pages
}

extract_stats <- function(page) {

  normalinserat <- page %>%
    rvest::html_nodes(".normalinserat")

  id <- find_ids(normalinserat)
  seller <- find_seller(normalinserat)
  bundesland <- find_bundesland(normalinserat)
  preis <- find_price(normalinserat)
  km <- find_km(normalinserat)
  ez <- find_erstzulassung(normalinserat)
  premium <- FALSE

  normal_daten <- dplyr::data_frame(id, seller, bundesland, preis, km, ez,
                                    premium)

  # Premiuminserat
  premiuminserat <- page %>%
    rvest::html_nodes(".premiuminserat")

  # check, if there is something to collect
  if (length(premiuminserat) > 0) {
    id <- find_ids(premiuminserat)
    seller <- find_seller(premiuminserat, premium = T)
    bundesland <- find_bundesland(premiuminserat, premium = T)
    preis <- find_price(premiuminserat, css = ".premiumprice")
    km <- find_km(premiuminserat, premium = T)
    ez <- find_erstzulassung(premiuminserat, premium = T)
    premium <- TRUE

    premium_daten <- dplyr::data_frame(id, seller,
                                       bundesland, preis,
                                       km, ez, premium)
  } else {
    premium_daten <- NULL
  }


  # bind data together
  dplyr::bind_rows(premium_daten, normal_daten)
}
