#' Bootsrapped randomly samples values
#'
#' @param data a data.frame
#' @param id variable name, to be aggregated around
#' @param value variable name, contains the value to take mean over
#' @param reps Number of reps, defaults to 1000
#'
#' @return a data.frame
#' @export
boot_index <- function(data, id, value, reps = 1000) {
  ddd <- data %>%
    ii_summarize({{id}}, {{value}})

  sample_mean <- function(n, value, data, replicates = reps) {
    mean(value < replicate(replicates, mean(sample(data, n))))
  }

  ddd$pvalue <- purrr::map2_dbl(ddd$length, ddd$value,
                         ~ sample_mean(.x, .y, dplyr::pull(sample_data, {{value}})))

  ddd
}
