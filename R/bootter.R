#' Bootsrapped randomly samples values
#'
#' @param data a data.frame with data summaries by a variable.
#' @param data_full a data.frame which is the unsummaried version of data. The
#'  assumption that data_full is sorted is taken.
#' @param id variable name, to be aggregated around
#' @param value variable name, contains the value to take mean over
#' @param reps Number of reps, defaults to 1000
#' @param method Integer, determining which method to use.
#'
#' @return a data.frame
#' @importFrom rlang :=
#' @export
bootter <- function(data, data_full,
                    value, id, reps, method = 1) {

  lengths <- sort(unique(data$n))

  big_data <- data_full %>%
    dplyr::filter(!is.na({{id}}))

  varname <- paste0(rlang::as_name(rlang::ensym(value)), "_v", method)

  if(method == 1) {
    values <- perm_v1(pwd = dplyr::pull(data, {{value}}),
                      n = data$n,
                      full_sites = dplyr::pull(data_full, {{value}}),
                      n_rep = reps,
                      lengths = lengths)
  }
  if(method == 2) {
    values <- perm_v2(pwd = dplyr::pull(data, {{value}}),
                      n = data$n,
                      full_sites = dplyr::pull(data_full, {{value}}),
                      n_rep = reps,
                      lengths = lengths)
  }
  if(method == 3) {
    values <- perm_v3(pwd = dplyr::pull(data, {{value}}),
                      n = data$n,
                      full_sites = data_full,
                      n_rep = reps,
                      lengths = lengths,
                      id = {{id}},
                      value = {{value}})
  }

  data %>%
    dplyr::mutate(
      !!varname := values
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


perm_v2_inner <- function(n, n_rep, data) {
  replicate(
    n =  n_rep,
    expr = mean(data[sample(length(data) - n, 1) + seq_len(n)])
  )
}

#' @importFrom purrr map2_dbl
perm_v2 <- function(pwd, n, full_sites, n_rep, lengths) {
  names(lengths) <- lengths
  res <- lapply(lengths, perm_v2_inner, n_rep = n_rep, data = full_sites)
  map2_dbl(pwd, n, ~ mean(.x < res[[as.character(.y)]]))
}

perm_v3_inner <- function(n, n_rep, data, id, value) {
  perm3_data <- data %>%
    dplyr::group_by({{id}}) %>%
    dplyr::mutate(left = dplyr::n() - dplyr::row_number() + 1)
  starting_index <- sample(which(n <= perm3_data$left), n_rep, replace = TRUE)
  purrr::map_dbl(starting_index, ~ mean(dplyr::pull(perm3_data, {{value}})[.x + seq_len(n) - 1]))
}

#' @importFrom purrr map2_dbl
perm_v3 <- function(pwd, n, full_sites, n_rep, lengths, id, value) {
  names(lengths) <- lengths
  res <- lapply(lengths, perm_v3_inner, n_rep = n_rep, data = full_sites,
                id = {{id}}, value = {{value}})
  map2_dbl(pwd, n, ~ mean(.x < res[[as.character(.y)]]))
}
