#' Bootsrapped randomly samples values
#'
#' @param data a data.frame with data summaries by a variable.
#' @param data_full a data.frame which is the unsummaried version of data.
#' @param id variable name, to be aggregated around
#' @param value variable name, contains the value to take mean over
#' @param reps Number of reps, defaults to 1000
#'
#' @return a data.frame
#' @importFrom rlang :=
#' @export
bootter <- function(data, data_full,
                    value, id, reps) {

  lengths <- sort(unique(data$n))

  big_data <- data_full %>%
    dplyr::filter(!is.na({{id}}))

  varname <- paste(rlang::as_name(rlang::ensym(value)), "_v1")
  data %>%
    dplyr::mutate(
      !!varname := perm_v1(pwd = dplyr::pull(data, {{value}}),
                           n = data$n,
                           full_sites = dplyr::pull(data_full, {{value}}),
                           n_rep = reps,
                           lengths = lengths)
    )
}

perm_v1_inner <- function(n_sites, n_rep, data) {
  replicate(
    n = n_rep,
    expr = mean(sample(data, as.numeric(n_sites), TRUE))
  )
}

#' @importFrom purrr map2_dbl
perm_v1 <- function(pwd, n, full_sites, n_rep, lengths) {
  names(lengths) <- lengths
  res <- lapply(lengths, perm_v1_inner, n_rep = n_rep, data = full_sites)
  map2_dbl(pwd, n, ~ mean(.x < res[[as.character(.y)]]))
}

