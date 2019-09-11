#' Aggregated
#'
#' @param data a data.frame
#' @param id variable name, to be aggregated around
#' @param value variable name, contains the value to take mean over
#'
#' @return data.frame
#' @export
ii_summarize <- function(data, id, value) {
  data %>%
    dplyr::filter(!is.na({{id}})) %>%
    dplyr::group_by({{id}}) %>%
    dplyr::summarise(value = mean({{value}}),
                     length = dplyr::n())
}
