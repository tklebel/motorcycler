get_page_numbers <- function(link) {
  list <- link %>%
    xml2::read_html() %>%
    rvest::html_node(".jumplistalt")
  if (inherits(list, "xml_missing")) {
    return(1)
  } else {
    list %>%
      rvest::html_text() %>%
      stringr::str_count("\\d")
  }
}

extract_inserat <- function(page, css = ".normalinserat") {
  page %>%
    rvest::html_nodes(css = css)
}

extract_css <- function(inserat, css) {
  inserat %>%
    html_node(css) %>%
    html_text()
}


scrape_page <- function(link) {
  number_of_pages <- get_page_numbers(link)

  # create links
  links <- paste0(link, "/seite/", seq_len(number_of_pages))
  pages <- purrr::map(links, xml2::read_html)

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
    seller <- find_seller(premiuminserat)
    bundesland <- find_bundesland(premiuminserat)
    preis <- find_price(premiuminserat)
    km <- find_km(premiuminserat)
    ez <- find_erstzulassung(premiuminserat)
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

#' Download page collect statistics
#'
#' @param link URL of the desired page
#'
#' @param motorrad Character vector of length 1, containing the name of the
#' motorcycle
#'
#' @export
combine_collection <- function(link, motorrad) {
  pages <- scrape_page(link)

  stats <- pages %>%
    purrr::map(extract_stats) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(motorrad = motorrad)

  stats
}
