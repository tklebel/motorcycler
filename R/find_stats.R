#' @export
#' @noRd
find_price <- function(inserat) {
  inserat %>%
    extract_css(css = ".dataright span") %>%
    str_extract_all("[\\d]") %>%
    at_depth(1, ~paste0(., collapse = "")) %>%
    at_depth(1, as.numeric) %>%
    unlist()
}

#' @export
#' @noRd
find_seller <- function(inserat) {
  inserat %>%
    rvest::html_node(".anbieter") %>%
    rvest::html_text() %>%
    stringr::str_replace_all("\\s", "")

}

#' @export
#' @noRd
find_bundesland <- function(inserat) {
  inserat %>%
    rvest::html_node(".region") %>%
    rvest::html_text() %>%
    stringr::str_replace_all(",", "")
}

#' @export
#' @noRd
find_km <- function(inserat) {
  inserat %>%
    extract_css(".dataleft p") %>%
    str_extract_all(".*(km)") %>%
    str_extract_all("[\\d]") %>%
    at_depth(1, ~paste0(., collapse = "")) %>%
    at_depth(1, as.numeric) %>%
    unlist()
}

#' @export
#' @noRd
find_erstzulassung <- function(inserat) {
  inserat %>%
    extract_css(".dataleft p") %>%
    str_extract_all("(BJ).*,") %>%
    str_extract_all("[\\d]") %>%
    at_depth(1, ~paste0(., collapse = "")) %>%
    at_depth(1, as.numeric) %>%
    unlist()
}

#' @export
#' @noRd
find_ids <- function(inserat) {

  # find all links within each inserat
  links <- inserat %>%
    html_nodes("a") %>%
    html_attr("href")

  # clean link to receive shorter ids
  id <- str_extract_all(links, ".*(?=\\?)") %>%
    map(~.[1]) %>%
    str_replace_all("/gebrauchtes-motorrad-", "")

  # create index to filter out unnecessary Snippet
  index <- str_detect(id, "Snippet")

  # apply index and reduce to unique ids
  id[!index] %>%
    unique()
}
