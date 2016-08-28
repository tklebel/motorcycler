#' @export
#' @noRd
get_page_numbers <- function(html_page) {
  html_page %>%
    rvest::html_node(".jumplistalt") %>%
    rvest::html_text() %>%
    stringr::str_count("\\d")
}

#' @export
#' @noRd
extract_inserat <- function(link, css = ".normalinserat") {
  page <- xml2::read_html(link)

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


