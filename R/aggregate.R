#' Calculate region wise summary statistics
#'
#' Will take a data.frame and apply a function (`fun`) to `value` within the
#' groups defined by the `id` column.
#'
#' Please note the ordering of the data will matter depending on the choice of
#' aggregation function.
#'
#' @param data a data.frame.
#' @param id variable name, to be aggregated around.
#' @param value variable name, contains the value to take mean over. Must be
#'     a single column.
#' @param fun function, summary statistic function to be calculated. Defaults
#'     to `mean`.
#' @param ... Additional arguments for the function given to the argument fun.
#'
#' @importFrom rlang .data
#' @return A methcon object. Contains the aggregated data along with original
#'     data.frame and variable selections.
#' @examples
#' meth_aggregate(fake_methylation, id = gene, value = meth, fun = mean)
#'
#' meth_aggregate(fake_methylation, id = gene, value = meth, fun = var)
#'
#' # custom functions can be used as well
#' mean_diff <- function(x) {
#'   mean(diff(x))
#' }
#'
#' meth_aggregate(fake_methylation, id = gene, value = meth, fun = mean_diff)
#' @export
meth_aggregate <- function(data, id, value, fun = mean, ...) {
  grouped_data <- data %>%
    dplyr::filter(!is.na({{id}})) %>%
    dplyr::group_by({{id}})

  structure(
    dplyr::bind_cols(
      dplyr::summarise_at(grouped_data, dplyr::vars({{value}}), fun, ...),
      dplyr::count(grouped_data) %>% dplyr::ungroup() %>% dplyr::select(.data$n)
    ),
    class = c("methcon", "tbl_df", "tbl", "data.frame"),
    .full_data = data,
    .id = rlang::ensym(id),
    .value = rlang::ensym(value)
  )
}
