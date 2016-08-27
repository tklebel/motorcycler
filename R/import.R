get_page_numbers <- function(link) {
  page <- xml2::read_html(link)

  page %>%
    rvest::html_node(".jumplistalt") %>%
    rvest::html_text() %>%
    stringr::str_count("\\d")
}

extract_inserat <- function(link, css = ".normalinserat") {
  page <- xml2::read_html(link)

  page %>%
    rvest::html_nodes(css = css)
}

extract_css <- function(inserat, css) {
  inserat %>%
    html_node(css) %>%
    html_text()
}


prepare_preis <- function(inserat, css = ".preis") {
  inserat %>%
    extract_css(css = css) %>%
    str_extract_all("[\\d]") %>%
    at_depth(1, ~paste0(., collapse = "")) %>%
    at_depth(1, as.numeric) %>%
    unlist()
}
