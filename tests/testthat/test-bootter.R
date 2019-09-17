
data <- data.frame(x = c(1, 1, 1, 2, 2, 3, 3, 3, 3, 4),
                   y = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 0),
                   z = c(0, 9, 8, 7, 6, 5, 4, 3, 2, 1))

test_that("multiplication works", {

  for (i in 1:3) {
    res_sum <- data %>%
      ii_summarize(x, y)
    res_boot <- res_sum %>%
      bootter(data, y, x, 10, method = i)

    expect_equal(nrow(res_sum), nrow(res_boot))
    expect_equal(ncol(res_sum) + 1, ncol(res_boot))
  }
})
