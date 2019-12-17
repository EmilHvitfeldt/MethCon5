#' @export
print.methcon <- function(x, ...) {
  cat("# Methcon object\n")
  cat("# .id:", attr(x, ".id"), "\n")
  cat("# .value:", attr(x, ".value"), "\n")

  class(x) <- setdiff(class(x), "methcon")
  print(x)
}
