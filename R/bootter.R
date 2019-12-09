#' Bootstrapped randomly samples values
#'
#' "perm_v1" (the default method) will sample the variables the rows
#' independently. "perm_v2" will sample regions of same size while allowing
#' overlap between different regions. "perm_v3" will sample regions under the
#' constraint that all sampled regions are contained in the region they are
#' sampled in.
#'
#' @param data a data.frame with data summaries by a variable.
#' @param data_full a data.frame which is the unsummarized version of data. The
#'  assumption that data_full is sorted is taken.
#' @param id variable name, to be aggregated around
#' @param value variable name, contains the value to take mean over
#' @param reps Number of reps, defaults to 1000
#' @param method Character, determining which method to use. See details for
#'   information about methods. Defauls to "perm_v1".
#'
#' @return a data.frame
#' @importFrom rlang :=
#' @export
bootter <- function(data, data_full, value, id, reps,
                    method = c("perm_v1", "perm_v2", "perm_v3")) {

  lengths <- sort(unique(data$n))

  big_data <- data_full %>%
    dplyr::filter(!is.na({{id}}))

  method <- match.arg(method)
  varname <- paste0(rlang::as_name(rlang::ensym(value)), "_", method)

  if(method == "perm_v1") {
    values <- perm_v1(pwd = dplyr::pull(data, {{value}}),
                      n = data$n,
                      full_sites = dplyr::pull(data_full, {{value}}),
                      n_rep = reps,
                      lengths = lengths)
  }
  if(method == "perm_v2") {
    values <- perm_v2(pwd = dplyr::pull(data, {{value}}),
                      n = data$n,
                      full_sites = dplyr::pull(data_full, {{value}}),
                      n_rep = reps,
                      lengths = lengths)
  }
  if(method == "perm_v3") {
    values <- perm_v3(pwd = dplyr::pull(data, {{value}}),
                      n = data$n,
                      full_sites = data_full,
                      n_rep = reps,
                      lengths = lengths,
                      id = {{id}},
                      value = {{value}})
  }

  data %>%
    dplyr::mutate(!!varname := values)
}
