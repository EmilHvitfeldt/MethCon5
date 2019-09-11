
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MethCon5

<!-- badges: start -->

<!-- badges: end -->

The goal of methcon5 is to identify and rank CpG DNA methylation
conservation along the human genome. Specifically it includes
bootstrapping methods to provide ranking which should adjust for the
differences in length as without it short regions tend to get higher
conservation scores.

## Installation

Please note that the name of the package is in all lowercase.

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

Below is some sample data where we have created 500 genes with 1 to 10
sites each. Then

``` r
library(methcon5)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
n <- 500

genes <- sample(1:10, n, replace = TRUE)

sample_data <- tibble(gene = rep(seq_len(n), times = genes),
                      cons_level = rep(sample(c("low", "medium", "high"), n, TRUE), times = genes)) %>%
  group_by(cons_level) %>%
  mutate(meth = case_when(cons_level == "low" ~ rbeta(n(), 2, 5),
                          cons_level == "medium" ~ rbeta(n(), 2, 2),
                          cons_level == "high" ~ rbeta(n(), 5, 2)))
```

``` r
sample_ii <- sample_data %>%
  ii_summarize(gene, meth) 

sample_ii
#> # A tibble: 500 x 3
#>     gene value length
#>    <int> <dbl>  <int>
#>  1     1 0.574      8
#>  2     2 0.769      6
#>  3     3 0.500      6
#>  4     4 0.891      3
#>  5     5 0.493     10
#>  6     6 0.698      9
#>  7     7 0.119      3
#>  8     8 0.519      9
#>  9     9 0.291      9
#> 10    10 0.541      7
#> # … with 490 more rows
```

``` r
ddd <- boot_index(sample_data, gene, meth, 100)
hist(ddd$pvalue, breaks = 100)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
