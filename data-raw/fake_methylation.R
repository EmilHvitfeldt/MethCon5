library(dplyr)
set.seed(1234)
n <- 500

genes <- sample(1:10, n, replace = TRUE)

fake_methylation <- tibble(gene = rep(seq_len(n), times = genes),
                      cons_level = rep(sample(c("low", "medium", "high"), n, TRUE), times = genes)) %>%
  group_by(cons_level) %>%
  mutate(meth = case_when(cons_level == "low" ~ rbeta(n(), 2, 5),
                          cons_level == "medium" ~ rbeta(n(), 2, 2),
                          cons_level == "high" ~ rbeta(n(), 5, 2))) %>%
  ungroup()

usethis::use_data(fake_methylation, overwrite = TRUE)
