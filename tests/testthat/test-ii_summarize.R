
data <- data.frame(x = c(1, 1, 1, 2, 2, 3, 3, 3, 3, 4),
                   y = c(1, 2, 3, 4, 5, 6, 7, 8, NA, 0),
                   z = c(0, 9, 8, 7, 6, 5, 4, 3, 2, 1))

test_that("Base function work", {
  data_sum <- ii_summarize(data, x, y)

  expect_equal(dim(data_sum), c(length(unique(data$x)), 3))
  expect_equal(data_sum$n, tabulate(data$x))
  expect_equal(data_sum$y, vapply(split(data$y, data$x), mean,
                                  FUN.VALUE = numeric(1), USE.NAMES = FALSE))
})

test_that("works with multiple selections", {
  data_sum <- ii_summarize(data, x, y:z)

  expect_equal(dim(data_sum), c(length(unique(data$x)), 4))
  expect_equal(data_sum$n, tabulate(data$x))
  expect_equal(data_sum$y, vapply(split(data$y, data$x), mean,
                                  FUN.VALUE = numeric(1), USE.NAMES = FALSE))
  expect_equal(data_sum$z, vapply(split(data$z, data$x), mean,
                                  FUN.VALUE = numeric(1), USE.NAMES = FALSE))
})

test_that("works with custom functions", {
  data_sum <- ii_summarize(data, x, y, fun = min)

  expect_equal(dim(data_sum), c(length(unique(data$x)), 3))
  expect_equal(data_sum$y, vapply(split(data$y, data$x), min,
                                  FUN.VALUE = numeric(1), USE.NAMES = FALSE))

  data_sum <- ii_summarize(data, x, y, fun = min, na.rm = TRUE)

  expect_equal(dim(data_sum), c(length(unique(data$x)), 3))
  expect_equal(data_sum$y, vapply(split(data$y, data$x), min,
                                  FUN.VALUE = numeric(1),
                                  na.rm = TRUE, USE.NAMES = FALSE))
})
