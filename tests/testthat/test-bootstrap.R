data <- data.frame(x = c(1, 1, 1, 2, 2, 3, 3, 3, 3, 4),
                   y = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 0),
                   z = c(0, 9, 8, 7, 6, 5, 4, 3, 2, 1))

test_that("Output size for meth_bootstrap", {
  for (i in c("perm_v1", "perm_v2", "perm_v3")) {
    res_sum <- data %>%
      meth_aggregate(x, y)
    res_boot <- res_sum %>%
      meth_bootstrap(10, method = i)

    expect_equal(nrow(res_sum), nrow(res_boot))
    expect_equal(ncol(res_sum) + 1, ncol(res_boot))
  }
})

test_that("returns methcon object", {
  for (i in c("perm_v1", "perm_v2", "perm_v3")) {
    res <- data %>%
      meth_aggregate(x, y) %>%
      meth_bootstrap(10, method = i)

    expect_s3_class(res, "methcon")
  }
})

