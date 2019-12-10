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
  purrr::map_dbl(
    starting_index,
    ~ mean(dplyr::pull(perm3_data, {{value}})[.x + seq_len(n) - 1])
  )
}

#' @importFrom purrr map2_dbl
perm_v3 <- function(pwd, n, full_sites, n_rep, lengths, id, value) {
  names(lengths) <- lengths
  res <- lapply(lengths, perm_v3_inner, n_rep = n_rep, data = full_sites,
                id = {{id}}, value = {{value}})
  map2_dbl(pwd, n, ~ mean(.x < res[[as.character(.y)]]))
}
