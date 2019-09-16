
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MethCon5

<!-- badges: start -->

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
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
set.seed(1234)
n <- 500

genes <- sample(1:10, n, replace = TRUE)

sample_data <- tibble(gene = rep(seq_len(n), times = genes),
                      cons_level = rep(sample(c("low", "medium", "high"), n, TRUE), times = genes)) %>%
  group_by(cons_level) %>%
  mutate(meth = case_when(cons_level == "low" ~ rbeta(n(), 2, 5),
                          cons_level == "medium" ~ rbeta(n(), 2, 2),
                          cons_level == "high" ~ rbeta(n(), 5, 2)))
```

First we apply the `ii_summarize` function. This will take the columns
specified in `value` and and apply the `fun` stratified according to
`id`. In this case we want to calculate the mean meth value wihin each
gene.

``` r
sample_ii <- sample_data %>%
  ii_summarize(id = gene, value =  meth, fun = mean) 

sample_ii
#> # A tibble: 500 x 3
#>     gene  meth     n
#>    <int> <dbl> <int>
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
data.frame caclulated earlier along with the original dataset. The
function with return the original data.frame with the new coloumn
attached to the end, which makes it ideal for piping to apply different
methods to the same data.

``` r
adjusted <- bootter(data = sample_ii, 
                    data_full =  sample_data,
                    value =  meth,
                    id = gene, reps = 100) %>%
            bootter(data_full =  sample_data,
                    value =  meth,
                    id = gene, reps = 100, method = 2)
```

``` r
library(ggplot2)

ggplot(adjusted, aes(meth_v1, meth_v2, color = n)) +
  geom_point() +
  scale_color_viridis_c() +
  theme_minimal()
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

## Funding acknowledgements

We gratefully acknowledge funding from NIH awards 1P01CA196569 and R21
CA226106.
