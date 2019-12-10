#' Simple simulated methylation dataset
#'
#' @details This dataset is for example use only. It contains 500 genes
#' identified by \code{gene} each with one of 3 types of conservation levels
#' "low", "medium" and "high". The methylation values are independent randomly
#' distributed within each gene. Thus no spacial correlation is assumed.
#'
#' @format A data frame with 2771 rows and 3 variables: \code{gene},
#' \code{cons_level} and \code{meth}.
"fake_methylation"
