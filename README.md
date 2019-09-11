
<!-- README.md is generated from README.Rmd. Please edit that file -->

# methcon5

<!-- badges: start -->

<!-- badges: end -->

The goal of methcon5 is to …

## Installation

~~You can install the released version of methcon5 from
[CRAN](https://CRAN.R-project.org) with:~~

``` r
install.packages("methcon5")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("EmilHvitfeldt/methcon5")
```

## Example

``` r
library(methcon5)
n <- 500

genes <- sample(1:10, n, replace = TRUE)

sample_data <- data.frame(gene = rep(as.character(1:n), times = genes),
                          meth = runif(sum(genes)), stringsAsFactors = FALSE)
```

``` r
sample_ii <- sample_data %>%
  ii_summarize(gene, meth) 

sample_ii
#> # A tibble: 500 x 3
#>    gene  value length
#>    <chr> <dbl>  <int>
#>  1 1     0.349      3
#>  2 10    0.517      3
#>  3 100   0.698      2
#>  4 101   0.606      9
#>  5 102   0.477      5
#>  6 103   0.280      6
#>  7 104   0.585      3
#>  8 105   0.458      5
#>  9 106   0.637      4
#> 10 107   0.286      1
#> # … with 490 more rows
```

``` r
ddd <- boot_index(sample_data, gene, meth, 100)
hist(ddd$pvalue, breaks = 100)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
