
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MethCon5

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/EmilHvitfeldt/methcon5.svg?branch=master)](https://travis-ci.org/EmilHvitfeldt/methcon5)
[![Codecov test
coverage](https://codecov.io/gh/EmilHvitfeldt/methcon5/branch/master/graph/badge.svg)](https://codecov.io/gh/EmilHvitfeldt/methcon5?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/methcon5)](https://CRAN.R-project.org/package=methcon5)
[![DOI](https://zenodo.org/badge/207922502.svg)](https://zenodo.org/badge/latestdoi/207922502)
<!-- badges: end -->

The goal of methcon5 is to identify and rank CpG DNA methylation
conservation along the human genome. Specifically, it includes
bootstrapping methods to provide ranking which should adjust for the
differences in length as without it short regions tend to get higher
conservation scores.

The following
[repository](https://github.com/EmilHvitfeldt/Epigenetic-Conservation-Is-A-Beacon-Of-Function)
includes an analysis in which this package was used.

## Installation

Please note that the name of the package is in all lowercase.

You can install the released version of methcon5 from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("methcon5")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("EmilHvitfeldt/methcon5")
```

## License

Copyright (c) 2019 Emil Hvitfeldt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Example

First we apply the `meth_aggregate()` function to the included example
dataset `fake_methylation`. This will take the columns specified in
`value` and apply the `fun` stratified according to `id`. In this case,
we want to calculate the mean meth value within each gene.

``` r
library(methcon5)
sample_ii <- fake_methylation %>%
  meth_aggregate(id = gene, value = meth, fun = mean) 

sample_ii
#> # Methcon object
#> # .id: gene 
#> # .value: meth 
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

Next we use the `meth_bootstrap()` function. This will take the
summarized data.frame calculated earlier along with the original
dataset. The function with return the original data.frame with the new
column attached to the end, which makes it ideal for piping to apply
different methods to the same data.

``` r
adjusted <- sample_ii %>%
  meth_bootstrap(reps = 100) %>%
  meth_bootstrap(reps = 100, method = "perm_v2") %>%
  meth_bootstrap(reps = 100, method = "perm_v3")
adjusted
#> # Methcon object
#> # .id: gene 
#> # .value: meth 
#> # A tibble: 500 x 6
#>     gene  meth     n meth_perm_v1 meth_perm_v2 meth_perm_v3
#>  * <int> <dbl> <int>        <dbl>        <dbl>        <dbl>
#>  1     1 0.509    10         0.5          0.49         0.43
#>  2     2 0.817     6         0            0.01         0.01
#>  3     3 0.577     5         0.22         0.35         0.28
#>  4     4 0.279     9         0.99         0.93         0.85
#>  5     5 0.318     5         0.94         0.84         0.71
#>  6     6 0.427     6         0.8          0.6          0.71
#>  7     7 0.736     4         0.05         0.16         0.11
#>  8     8 0.546     2         0.41         0.42         0.41
#>  9     9 0.328     7         0.97         0.86         0.82
#> 10    10 0.202     6         1            1            1   
#> # … with 490 more rows
```

``` r
library(ggplot2)

ggplot(adjusted, aes(meth_perm_v1, meth_perm_v2, color = n)) +
  geom_point() +
  scale_color_viridis_c() +
  theme_minimal()
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

## Funding acknowledgments

We gratefully acknowledge funding from NIH awards 1P01CA196569 and R21
CA226106.
