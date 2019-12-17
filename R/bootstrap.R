#' Bootstrapped randomly samples values
#'
#' "perm_v1" (the default method) will sample the variables the rows
#' independently. "perm_v2" will sample regions of same size while allowing
#' overlap between different regions. "perm_v3" will sample regions under the
#' constraint that all sampled regions are contained in the region they are
#' sampled in.
#'
#' Note that you can apply `meth_bootstrap` multiple times to get values for
#' different methods.
#'
#' @param data a methcon data.frame output from `meth_bootstrap`.
#' @param reps Number of reps, defaults to 1000.
#' @param method Character, determining which method to use. See details for
#'   information about methods. Defaults to "perm_v1".
#'
#' @importFrom rlang :=
#' @return A methcon object. Contains the aggregated data along with original
#'     data.frame and variable selections and bootstrapped values.
#' @examples
#' # Note that you likely want to do more than 10 repitions.
#' # rep = 10 was chosen to have the examples run fast.
#'
#' fake_methylation %>%
#'   meth_aggregate(id = gene, value = meth, fun = mean) %>%
#'   meth_bootstrap(10)
#'
#' fake_methylation %>%
#'   meth_aggregate(id = gene, value = meth, fun = mean) %>%
#'   meth_bootstrap(10, method = "perm_v2")
#'
#' # Get multiple bootstraps
#' fake_methylation %>%
#'   meth_aggregate(id = gene, value = meth, fun = mean) %>%
#'   meth_bootstrap(10, method = "perm_v1") %>%
#'   meth_bootstrap(10, method = "perm_v2") %>%
#'   meth_bootstrap(10, method = "perm_v3")
#' @export
meth_bootstrap <- function(data, reps,
                    method = c("perm_v1", "perm_v2", "perm_v3")) {
  UseMethod("meth_bootstrap")
}

#' @export
meth_bootstrap.methcon <- function(data, reps,
                            method = c("perm_v1", "perm_v2", "perm_v3")) {

  lengths <- sort(unique(data$n))

  data_full <- attr(data, ".full_data")
  value <- attr(data, ".value")
  id <- attr(data, ".id")

  method <- match.arg(method)
  varname <- paste0(rlang::as_name(rlang::ensym(value)), "_", method)

  if (method == "perm_v1") {
    values <- perm_v1(pwd = data[[value]],
                      n = data$n,
                      full_sites = data_full[[value]],
                      n_rep = reps,
                      lengths = lengths)
  }
  if (method == "perm_v2") {
    values <- perm_v2(pwd = data[[value]],
                      n = data$n,
                      full_sites = data_full[[value]],
                      n_rep = reps,
                      lengths = lengths)
  }
  if (method == "perm_v3") {
    values <- perm_v3(pwd = data[[value]],
                      n = data$n,
                      full_sites = data_full,
                      n_rep = reps,
                      lengths = lengths,
                      id = {{id}},
                      value = {{value}})
  }

  data[[varname]] <- values
  data
}

#' @export
meth_bootstrap.default <- function(data, reps,
                            method = c("perm_v1", "perm_v2", "perm_v3")) {
  stop("`data` must be a `methcon` object.")
}
