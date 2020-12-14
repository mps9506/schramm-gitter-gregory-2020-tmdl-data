############################
#### Unadjusted MK-Test ####
############################

run_mk_test <- function(model_df) {
  df <- model_df %>%
    dplyr::select(ActivityStartDate, Flow, MonitoringLocationIdentifier, geometry, ResultMeasureValue, Impaired, TMDL) %>%
    filter(ActivityStartDate >= as.Date("2012-01-01")) %>%
    group_by(MonitoringLocationIdentifier) %>%
    nest(data = c(ActivityStartDate, Flow, ResultMeasureValue)) %>%
    mutate(data = purrr::map(data, ~{
      .x %>%
        mutate(decdate = dectime(ActivityStartDate)) %>%
        arrange(decdate) %>%
        group_by(ActivityStartDate, decdate) %>%
        summarize(ResultMeasureValue = DescTools::Gmean(ResultMeasureValue),
                  .groups = "drop")
      })) %>%
    mutate(seaken = purrr::map(data,
                               ~kensen.test(log(.x$ResultMeasureValue),
                                            .x$decdate,
                                            n.min = Inf))) %>%
    mutate(pvalue = purrr::map_dbl(seaken, "p.value"),
           kendallsTau = purrr::map_dbl(seaken, "statistic"),
           slope = purrr::map_dbl(map(seaken, "estimate"), "slope"),
           n = purrr::map_dbl(map(seaken, "estimate"), "n")) %>%
    dplyr::ungroup() %>%
    dplyr::select(-c(data, seaken))
  return(df)
}


###############################
#### Flow-adjusted MK-Test ####
###############################

fa_seaken <- function(x) {
  df <- x
  
  m1 <- mgcv::gam(log(ResultMeasureValue) ~ s(log1p(Flow), k = 4),
                  data = df)
  df <- df %>%
    mutate(residuals = residuals(m1))
  
  kensen.test(df$residuals,
              df$decdate,
              n.min = Inf)
}


run_fa_mk_test <- function(model_df) {
  
  ## want to filter down to sites with 3 paired measurements annually
  keep_stations <- model_df %>%
    as_tibble() %>%
    filter(!is.na(Flow)) %>%
    mutate(year = lubridate::year(ActivityStartDate)) %>%
    group_by(MonitoringLocationIdentifier, year) %>%
    summarize(n = n(),
              .groups = "keep") %>%
    ungroup() %>%
    tidyr::complete(MonitoringLocationIdentifier, 
                    year = 2012:2019,
                    fill = list(n = 0)) %>%
    group_by(MonitoringLocationIdentifier) %>%
    summarize(n = median(n),
              .groups = "drop") %>%
    arrange(n) %>%
    filter(n >= 3)
  
  model_df %>%
    filter(MonitoringLocationIdentifier %in% keep_stations$MonitoringLocationIdentifier) %>%
    filter(!is.na(Flow)) %>%
    filter(MonitoringLocationIdentifier != "TCEQMAIN-12185") %>% ## manual filtering
    dplyr::select(ActivityStartDate, Flow, MonitoringLocationIdentifier, geometry, ResultMeasureValue, Impaired, TMDL) %>%
    filter(ActivityStartDate >= as.Date("2012-01-01")) %>%
    group_by(MonitoringLocationIdentifier) %>%
    nest(data = c(ActivityStartDate, Flow, ResultMeasureValue)) %>%
    mutate(data = purrr::map(data, ~{
      .x %>%
        mutate(decdate = dectime(ActivityStartDate)) %>%
        arrange(decdate) %>%
        group_by(ActivityStartDate, decdate, Flow) %>%
        summarize(ResultMeasureValue = DescTools::Gmean(ResultMeasureValue),
                  .groups = "drop")
    })) %>%
    mutate(fa_seaken = map2(data, MonitoringLocationIdentifier,
                            ~{fa_seaken(.x)}),
           fa_pvalue = purrr::map_dbl(fa_seaken, "p.value"),
           fa_kendallsTau = purrr::map_dbl(fa_seaken, "statistic"),
           fa_slope = purrr::map_dbl(map(fa_seaken, "estimate"), "slope"),
           fa_n = purrr::map_dbl(map(fa_seaken, "estimate"), "n")) %>%
    dplyr::ungroup() %>%
    dplyr::select(-c(data, fa_seaken))
  
}

##############################
#### Summarize MK results ####
##############################

apply_t_test <- function(x, y) {
  df <- x %>%
    dplyr::select(MonitoringLocationIdentifier, slope) %>%
    right_join(y %>% select(MonitoringLocationIdentifier, fa_slope)) %>%
    tidyr::pivot_longer(!MonitoringLocationIdentifier)
  
  t.test(value ~ name,
         paired = TRUE,
         alternative = "less",
         data = df)
  
}

summary_mk_unadj <- function(x) {
  x %>%
    mutate(outcome = case_when(
      slope < 0 & pvalue <= 0.1 ~ "improvement",
      !(slope < 0 & pvalue <= 0.1) ~ "no improvement"
    )) %>%
    group_by(outcome) %>%
    summarize(n = n(),
              .groups = "drop") %>%
    mutate(percent = n/sum(n) * 100)
  
  
  x %>%
    mutate(outcome = case_when(
      slope < 0 & pvalue <= 0.1 ~ "improvement",
      !(slope < 0 & pvalue <= 0.1) ~ "no improvement"
    )) %>%
    group_by(TMDL, outcome) %>%
    summarize(n = n(),
              .groups = "drop") %>%
    group_by(TMDL) %>%
    mutate(total = sum(n)) %>%
    mutate(percent = n/total * 100)
}


summary_mk_adj <- function(x) {
  x %>%
    mutate(outcome = case_when(
      fa_slope < 0 & fa_pvalue <= 0.1 ~ "improvement",
      !(fa_slope < 0 & fa_pvalue <= 0.1) ~ "no improvement"
    )) %>%
    group_by(outcome) %>%
    summarize(n = n(),
              .groups = "drop") %>%
    mutate(percent = n/sum(n) * 100)
  
  
  
  x %>%
    mutate(outcome = case_when(
      fa_slope < 0 & fa_pvalue <= 0.1 ~ "improvement",
      !(fa_slope < 0 & fa_pvalue <= 0.1) ~ "no improvement"
    )) %>%
    group_by(TMDL, outcome) %>%
    summarize(n = n(),
              .groups = "drop") %>%
    group_by(TMDL) %>%
    mutate(total = sum(n)) %>%
    mutate(percent = n/total * 100)
}