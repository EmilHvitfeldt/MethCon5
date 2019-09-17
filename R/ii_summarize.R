#' Aggregated
#'
#' @param data a data.frame
#' @param id variable name, to be aggregated around
#' @param value variable name, contains the value to take mean over
#' @param fun function, summary statistic function  to be calculated. Defaults
#' to `mean`.
#' @param ... Additional arguments for the function given to the argument fun.
#'
#' @importFrom rlang .data
#' @return data.frame
#' @export
ii_summarize <- function(data, id, value, fun = mean, ...) {
  grouped_data <- data %>%
    dplyr::filter(!is.na({{id}})) %>%
    dplyr::group_by({{id}})

  dplyr::bind_cols(
    dplyr::summarise_at(grouped_data, dplyr::vars({{value}}), fun, ...),
    dplyr::count(grouped_data) %>% dplyr::ungroup() %>% dplyr::select(.data$n)
  )
}
