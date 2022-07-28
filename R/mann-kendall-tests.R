############################
#### Unadjusted MK-Test ####
############################

run_mk_test <- function(model_df) {
  ## filter tmdl sites with sufficient pre and post data
  tmdl_sites <- model_df %>%
    dplyr::select(ActivityStartDate, Flow, MonitoringLocationIdentifier, geometry, ResultMeasureValue, Impaired, TMDL, Completion_Date) %>%
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "pre-tmdl",
      Completion_Date < ActivityStartDate ~ "post-tmdl",
      is.na(Completion_Date) ~ "pre-tmdl"
    ),
    year = lubridate::year(ActivityStartDate))  %>%
    group_by(MonitoringLocationIdentifier, tmdl_status, Completion_Date) %>%
    nest() |> 
    mutate(n = purrr::map_dbl(data, ~length(.x$ResultMeasureValue)),
           start_date = purrr::map(data, ~min(.x$ActivityStartDate)),
           end_date = purrr::map(data, ~max(.x$ActivityStartDate))) |>
    unnest(c(start_date, end_date)) |>
    mutate(years = as.numeric((end_date - start_date)/365)) |>
    filter(years >= 7) |>
    mutate(n = purrr::map_dbl(data,
                              ~{
                                .x |> 
                                  group_by(year) |> 
                                  summarize(n = n()) |> 
                                  ungroup() |> 
                                  summarize(n = as.numeric(median(n))) |> 
                                  pull(n)
                              })) |> 
    filter(n>=3) |> 
    filter(!is.na(Completion_Date)) 
  
  ## filter non-tmdl sites with sufficient data
  non_tmdl_sites <- model_df %>%
    dplyr::select(ActivityStartDate, Flow, MonitoringLocationIdentifier, geometry, ResultMeasureValue, Impaired, TMDL, Completion_Date) %>%
    dplyr::filter(ActivityStartDate >= as.Date("2015-01-01")) |> 
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "pre-tmdl",
      Completion_Date < ActivityStartDate ~ "post-tmdl",
      is.na(Completion_Date) ~ "pre-tmdl"),
      year = lubridate::year(ActivityStartDate))  %>%
    dplyr::filter(is.na(Completion_Date)) %>%
    group_by(MonitoringLocationIdentifier, tmdl_status, Completion_Date) %>%
    nest() |> 
    mutate(n = purrr::map_dbl(data, ~length(.x$ResultMeasureValue)),
           start_date = purrr::map(data, ~min(.x$ActivityStartDate)),
           end_date = purrr::map(data, ~max(.x$ActivityStartDate))) |>
    unnest(c(start_date, end_date)) |> 
    mutate(years = round(as.numeric((end_date - start_date)/365),0)) |>
    filter(years >= 6) |>
    mutate(n = purrr::map_dbl(data,
                              ~{
                                .x |> 
                                  group_by(year) |> 
                                  summarize(n = n()) |> 
                                  ungroup() |> 
                                  summarize(n = as.numeric(median(n))) |> 
                                  pull(n)
                              })) |> 
    filter(n>=3)
  
  
  ## runs test
  df <- model_df %>%
    dplyr::filter(MonitoringLocationIdentifier %in% c(tmdl_sites$MonitoringLocationIdentifier,
                                                      non_tmdl_sites$MonitoringLocationIdentifier)) |>
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "Pre-TMDL",
      Completion_Date < ActivityStartDate ~ "Post-TMDL",
      is.na(Completion_Date) ~ "Pre-TMDL"
    )) |> 
    dplyr::filter(!is.na(Completion_Date) |
                    is.na(Completion_Date) & ActivityStartDate >= as.Date("2015-01-01")) |> 
    group_by(MonitoringLocationIdentifier, tmdl_status) |> 
    nest(data = c(ActivityStartDate, Flow, ResultMeasureValue)) %>%
    mutate(n_med = purrr::map_dbl(data,
                                  ~{
                                    .x |> 
                                      mutate(year = lubridate::year(ActivityStartDate)) |> 
                                      group_by(year) |> 
                                      summarize(n = n()) |> 
                                      ungroup() |> 
                                      summarize(n_med = as.numeric(median(n))) |> 
                                      pull(n_med)}
    )) |> 
    filter(n_med>=3) |> 
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
    dplyr::select(-c(data, seaken, n_med)) |> 
    mutate(tmdl_status = case_when(
      TMDL == 1 ~ tmdl_status,
      TMDL == 0 ~ "No-TMDL"))
    
  
  
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
  
  ## tmdl sites
  tmdl_sites <- model_df %>%
    as_tibble() %>%
    filter(!is.na(Flow)) %>%
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "pre-tmdl",
      Completion_Date < ActivityStartDate ~ "post-tmdl",
      is.na(Completion_Date) ~ "pre-tmdl"
    ),
    year = lubridate::year(ActivityStartDate))  %>%
    group_by(MonitoringLocationIdentifier, tmdl_status, Completion_Date) %>%
    nest() |> 
    mutate(n = purrr::map_dbl(data, ~length(.x$ResultMeasureValue)),
           start_date = purrr::map(data, ~min(.x$ActivityStartDate)),
           end_date = purrr::map(data, ~max(.x$ActivityStartDate))) |>
    unnest(c(start_date, end_date)) |>
    mutate(years = as.numeric((end_date - start_date)/365)) |>
    filter(years >= 7) |>
    mutate(n = purrr::map_dbl(data,
                              ~{
                                .x |> 
                                  group_by(year) |> 
                                  summarize(n = n()) |> 
                                  ungroup() |> 
                                  summarize(n = as.numeric(median(n))) |> 
                                  pull(n)
                              })) |> 
    filter(n>=3) |> 
    filter(!is.na(Completion_Date))
  
  non_tmdl_sites <- model_df |> 
    filter(!is.na(Flow)) |> 
    dplyr::select(ActivityStartDate, Flow, MonitoringLocationIdentifier, geometry, ResultMeasureValue, Impaired, TMDL, Completion_Date) |> 
    dplyr::filter(ActivityStartDate >= as.Date("2015-01-01")) |> 
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "pre-tmdl",
      Completion_Date < ActivityStartDate ~ "post-tmdl",
      is.na(Completion_Date) ~ "pre-tmdl"),
      year = lubridate::year(ActivityStartDate))  |> 
    dplyr::filter(is.na(Completion_Date)) |> 
    group_by(MonitoringLocationIdentifier, tmdl_status, Completion_Date) |> 
    nest() |> 
    mutate(n = purrr::map_dbl(data, ~length(.x$ResultMeasureValue)),
           start_date = purrr::map(data, ~min(.x$ActivityStartDate)),
           end_date = purrr::map(data, ~max(.x$ActivityStartDate))) |>
    unnest(c(start_date, end_date)) |> 
    mutate(years = round(as.numeric((end_date - start_date)/365),0)) |>
    filter(years >= 6) |>
    mutate(n = purrr::map_dbl(data,
                              ~{
                                .x |> 
                                  group_by(year) |> 
                                  summarize(n = n()) |> 
                                  ungroup() |> 
                                  summarize(n = as.numeric(median(n))) |> 
                                  pull(n)
                              })) |> 
    filter(n>=3)
  
  
  ## runs test
  df <- model_df |> 
  ## TCEQMAIN-12185 has lots of negative flows, remove it from the flow
  ## normalization pool because the generated resiuals aren't valid (probably tidal)
  filter(MonitoringLocationIdentifier != "TCEQMAIN-12185") |> 
    filter(!is.na(Flow)) |> 
    mutate(Flow = case_when(
      Flow < 0 ~ 0,
      Flow >=0 ~ Flow
    )) |> 
    dplyr::filter(MonitoringLocationIdentifier %in% c(tmdl_sites$MonitoringLocationIdentifier,
                                                      non_tmdl_sites$MonitoringLocationIdentifier)) |>
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "Pre-TMDL",
      Completion_Date < ActivityStartDate ~ "Post-TMDL",
      is.na(Completion_Date) ~ "Pre-TMDL"
    )) |> 
    dplyr::filter(!is.na(Completion_Date) |
                    is.na(Completion_Date) & ActivityStartDate >= as.Date("2015-01-01")) |> 
    group_by(MonitoringLocationIdentifier, tmdl_status) |> 
    nest(data = c(ActivityStartDate, Flow, ResultMeasureValue)) %>%
    mutate(n_med = purrr::map_dbl(data,
                                  ~{
                                    .x |> 
                                      mutate(year = lubridate::year(ActivityStartDate)) |> 
                                      group_by(year) |> 
                                      summarize(n = n()) |> 
                                      ungroup() |> 
                                      summarize(n_med = as.numeric(median(n))) |> 
                                      pull(n_med)}
    )) |> 
    filter(n_med>=3) |> 
    mutate(data = purrr::map(data, ~{
      .x %>%
        mutate(decdate = dectime(ActivityStartDate)) |> 
        arrange(decdate) |> 
        group_by(ActivityStartDate, decdate, Flow) |> 
        summarize(ResultMeasureValue = DescTools::Gmean(ResultMeasureValue),
                  .groups = "drop")
    })) |> 
    mutate(start_date = purrr::map(data, ~min(.x$ActivityStartDate)),
           end_date = purrr::map(data, ~max(.x$ActivityStartDate))) |>
    unnest(c(start_date, end_date)) |> 
    mutate(years = round(as.numeric((end_date - start_date)/365),0)) |>
    filter(years >= 6) |> 
    mutate(seaken = purrr::map(data,
                               ~kensen.test(log(.x$ResultMeasureValue),
                                            .x$decdate,
                                            n.min = Inf))) |> 
    mutate(fa_seaken = map2(data, MonitoringLocationIdentifier,
                            ~{fa_seaken(.x)}),
           fa_pvalue = purrr::map_dbl(fa_seaken, "p.value"),
           fa_kendallsTau = purrr::map_dbl(fa_seaken, "statistic"),
           fa_slope = purrr::map_dbl(map(fa_seaken, "estimate"), "slope"),
           fa_n = purrr::map_dbl(map(fa_seaken, "estimate"), "n")) |> 
    dplyr::ungroup() |> 
    dplyr::select(-c(data, seaken, fa_seaken, n_med, start_date, end_date, years)) |> 
    mutate(tmdl_status = case_when(
      TMDL == 1 ~ tmdl_status,
      TMDL == 0 ~ "No-TMDL"))
  
}

##############################
#### Summarize MK results ####
##############################

apply_t_test <- function(x, y) {
  df <- x %>%
    dplyr::select(MonitoringLocationIdentifier, tmdl_status, slope) %>%
    right_join(y %>% select(MonitoringLocationIdentifier, tmdl_status, fa_slope)) %>%
    filter(tmdl_status == "Post-TMDL")
  
  t.test(Pair(slope, fa_slope) ~ 1,
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