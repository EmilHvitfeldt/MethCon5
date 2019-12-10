
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MethCon5

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/EmilHvitfeldt/methcon5.svg?branch=master)](https://travis-ci.org/EmilHvitfeldt/methcon5)
[![Codecov test
coverage](https://codecov.io/gh/EmilHvitfeldt/methcon5/branch/master/graph/badge.svg)](https://codecov.io/gh/EmilHvitfeldt/methcon5?branch=master)
<!-- badges: end -->

The goal of methcon5 is to identify and rank CpG DNA methylation
conservation along the human genome. Specifically it includes
bootstrapping methods to provide ranking which should adjust for the
differences in length as without it short regions tend to get higher
conservation scores.

The following
[repository](https://github.com/EmilHvitfeldt/Epigenetic-Conservation-Is-A-Beacon-Of-Function)
includes analysis in which this package was used.

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
set.seed(1234)
n <- 500

genes <- sample(1:10, n, replace = TRUE)

sample_data <- tibble(gene = rep(seq_len(n), times = genes),
                      cons_level = rep(sample(c("low", "medium", "high"), n, TRUE), times = genes)) %>%
  group_by(cons_level) %>%
  mutate(meth = case_when(cons_level == "low" ~ rbeta(n(), 2, 5),
                          cons_level == "medium" ~ rbeta(n(), 2, 2),
                          cons_level == "high" ~ rbeta(n(), 5, 2)))
sample_data
#> # A tibble: 2,771 x 3
#> # Groups:   cons_level [3]
#>     gene cons_level  meth
#>    <int> <chr>      <dbl>
#>  1     1 medium     0.144
#>  2     1 medium     0.727
#>  3     1 medium     0.398
#>  4     1 medium     0.811
#>  5     1 medium     0.391
#>  6     1 medium     0.462
#>  7     1 medium     0.405
#>  8     1 medium     0.452
#>  9     1 medium     0.463
#> 10     1 medium     0.833
#> # … with 2,761 more rows
```

First we apply the `ii_summarize` function. This will take the columns
specified in `value` and and apply the `fun` stratified according to
`id`. In this case we want to calculate the mean meth value within each
gene.

``` r
sample_ii <- sample_data %>%
  ii_summarize(id = gene, value = meth, fun = mean) 

sample_ii
#> # A tibble: 500 x 3
#>     gene  meth     n
#>  * <int> <dbl> <int>
#>  1     1 0.509    10
#>  2     2 0.817     6
#>  3     3 0.577     5
#>  4     4 0.279     9
#>  5     5 0.318     5
#>  6     6 0.427     6
#>  7     7 0.736     4
#>  8     8 0.546     2
#>  9     9 0.328     7
#> 10    10 0.202     6
#> # … with 490 more rows
```

Next we use the `bootter` function. This will take the summarized
data.frame calculated earlier along with the original dataset. The
function with return the original data.frame with the new column
attached to the end, which makes it ideal for piping to apply different
methods to the same data.

``` r
adjusted <- sample_ii %>%
  bootter(reps = 100) %>%
  bootter(reps = 100, method = "perm_v2") %>%
  bootter(reps = 100, method = "perm_v3")
adjusted
#> # A tibble: 500 x 6
#>     gene  meth     n meth_perm_v1 meth_perm_v2 meth_perm_v3
#>  * <int> <dbl> <int>        <dbl>        <dbl>        <dbl>
#>  1     1 0.509    10         0.43         0.46         0.35
#>  2     2 0.817     6         0            0            0   
#>  3     3 0.577     5         0.27         0.35         0.45
#>  4     4 0.279     9         1            0.93         0.87
#>  5     5 0.318     5         0.98         0.86         0.8 
#>  6     6 0.427     6         0.74         0.65         0.65
#>  7     7 0.736     4         0.02         0.16         0.12
#>  8     8 0.546     2         0.37         0.44         0.42
#>  9     9 0.328     7         0.99         0.84         0.8 
#> 10    10 0.202     6         1            0.99         0.99
#> # … with 490 more rows
```

``` r
library(ggplot2)

ggplot(adjusted, aes(meth_perm_v1, meth_perm_v2, color = n)) +
  geom_point() +
  scale_color_viridis_c() +
  theme_minimal()
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

## Funding acknowledgements

We gratefully acknowledge funding from NIH awards 1P01CA196569 and R21
CA226106.
