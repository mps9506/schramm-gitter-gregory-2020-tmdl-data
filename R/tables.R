
################
#### Tables ####
################

## note these are texreg objects formatted for ms word

## Data Summary
summarize_data <- function(cleaned_data) {
  
  ## unadjusted sites
  tmdl_sites <- cleaned_data |> 
    dplyr::select(ActivityStartDate, Flow, MonitoringLocationIdentifier, geometry, ResultMeasureValue, Impaired, TMDL, Completion_Date) |> 
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "Pre-TMDL",
      Completion_Date < ActivityStartDate ~ "Post-TMDL",
      is.na(Completion_Date) ~ "No-TMDL"),
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
  
  non_tmdl_sites <- cleaned_data %>%
    dplyr::select(ActivityStartDate, Flow, MonitoringLocationIdentifier, geometry, ResultMeasureValue, Impaired, TMDL, Completion_Date) %>%
    dplyr::filter(ActivityStartDate >= as.Date("2015-01-01")) |> 
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "Pre-TMDL",
      Completion_Date < ActivityStartDate ~ "Post-TMDL",
      is.na(Completion_Date) ~ "No-TMDL"),
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
  
  
  full_data <- cleaned_data |> 
    dplyr::filter(MonitoringLocationIdentifier %in% c(tmdl_sites$MonitoringLocationIdentifier,
                                                      non_tmdl_sites$MonitoringLocationIdentifier)) |>
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "Pre-TMDL",
      Completion_Date < ActivityStartDate ~ "Post-TMDL",
      is.na(Completion_Date) ~ "No-TMDL"
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
    })) |> 
    unnest(data) |> 
    ungroup() |> 
    group_by(MonitoringLocationIdentifier, tmdl_status) |>
    summarize(value = DescTools::Gmean(ResultMeasureValue),
              n_samples = n(),
              .groups = "drop") |> 
    group_by(tmdl_status) |>
    summarize(n = n(),
              samples_per_station = round(mean(n_samples), 2),
              mean = round(DescTools::Gmean(value), 2),
              sd = round(DescTools::Gsd(value), 2),
              .groups = "drop")
  
  
  # flow adjusted sites
  tmdl_sites <- cleaned_data |> 
    as_tibble() %>%
    filter(!is.na(Flow)) %>%
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "Pre-TMDL",
      Completion_Date < ActivityStartDate ~ "Post-TMDL",
      is.na(Completion_Date) ~ "No-TMDL"),
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
  
  non_tmdl_sites <- cleaned_data |> 
    filter(!is.na(Flow)) |> 
    dplyr::select(ActivityStartDate, Flow, MonitoringLocationIdentifier, geometry, ResultMeasureValue, Impaired, TMDL, Completion_Date) %>%
    dplyr::filter(ActivityStartDate >= as.Date("2015-01-01")) |> 
    mutate(tmdl_status = case_when(
      Completion_Date >= ActivityStartDate ~ "Pre-TMDL",
      Completion_Date < ActivityStartDate ~ "Post-TMDL",
      is.na(Completion_Date) ~ "No-TMDL"),
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
  
  
  fa_data <- cleaned_data |> 
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
      is.na(Completion_Date) ~ "No-TMDL"
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
    })) |> 
    mutate(start_date = purrr::map(data, ~min(.x$ActivityStartDate)),
           end_date = purrr::map(data, ~max(.x$ActivityStartDate))) |>
    unnest(c(start_date, end_date)) |> 
    mutate(years = round(as.numeric((end_date - start_date)/365),0)) |>
    filter(years >= 6) |> 
    unnest(data) |> 
    ungroup() |> 
    group_by(MonitoringLocationIdentifier, tmdl_status) |>
    summarize(value = DescTools::Gmean(ResultMeasureValue),
              n_samples = n(),
              .groups = "drop") |> 
    group_by(tmdl_status) |>
    summarize(n = n(),
              samples_per_station = round(mean(n_samples), 2),
              mean = round(DescTools::Gmean(value), 2),
              sd = round(DescTools::Gsd(value), 2),
              .groups = "drop")
  
  full_data <- full_data |> mutate(group_label = "Unadjusted Data")
  fa_data <- fa_data |> mutate(group_label = "Flow-Adjusted Data")
  out_df <- bind_rows(full_data, fa_data)
  
  out_df |> 
    gt(rowname_col = "tmdl_status",
       groupname_col = "group_label") |> 
    cols_label(
      n = html("SWQM Stations<br>(n)"),
      samples_per_station = html("Mean <i>E. coli</i><br>Samples per Station<br>(n)"),
      mean = html("Geometric Mean<br><i>E. coli</i> Concentration<br>(MPN/100 mL)"),
      sd = html("Geometric SD<br><i>E. coli</i> Concentration<br>(MPN/100 mL)")
    )
  
}



## Logistic Regression results

tabulate_lr <- function(x) {
  mr <- texreg::matrixreg(list(x[[1]], x[[2]]),
                          custom.coef.names = c("Intercept", "TMDL"),
                          custom.header = list("Unadjusted" = 1, "Flow-Adjusted" = 2),
                          custom.model.names = c("GLM", "GLM"),
                          single.row = TRUE, 
                          include.bic = FALSE,
                          include.deviance = TRUE,
                          caption = "(\\#tab:modsum1) GLM model summaries.", 
                          output.type = "ascii", include.attributes = FALSE)
  ft <- flextable::flextable(as.data.frame(mr))
  ft <- width(ft,
              width = 1)
  
  ft <- hline(ft, i = 1, j = c("V1","V2","V3"),
              border = officer::fp_border(width = 1))
  ft <- hline(ft, i = 3, j = c("V1","V2","V3"),
              border = officer::fp_border(width = 0.5))
  ft <- set_header_labels(ft,
                          values = c(V1 = "",
                                     V2 = "Unadjusted",
                                     V3 = "Flow-Adjusted"))
  ft <- hline(ft, i = 1, j = c("V1"),
              border = officer::fp_border(width = 0),
              part = "header")
  ft <- hline(ft, i = 1, j = c("V2","V3"),
              border = officer::fp_border(width = 0.5),
              part = "header")
  ft <- merge_h(ft, part = "header")
  ft <- fontsize(ft, size = 9, part = "all")
  ft <- align(ft, j = c("V2","V3"),
              align = "center", part = "all")
  ft <- autofit(ft)
  ft <- add_footer(ft, values = c(V1 = "*** p < 0.001; ** p < 0.01;  * p < 0.05"))
  ft <- merge_at(ft, j = 1:3, part = "footer")
  # ft
  ft
}


tabulate_lr(readd(lr_results))


## cross classification table and Odds ratio

# unadjusted odds ratios
# x = unadjust mk results
cc_tab_1 <- function(x) {
  unadj_results <- x %>%
    mutate(TMDL = as.factor(TMDL),
           outcome = case_when(
             slope < 0 & pvalue < 0.10 ~ 1,
             !(slope < 0 & pvalue < 0.10) ~ 0
           ),
           outcome = as.numeric(outcome)) %>%
    dplyr::select(MonitoringLocationIdentifier,
                  TMDL,
                  tmdl_status,
                  outcome) |> 
    mutate(predictor = as_factor(tmdl_status)) |> 
    mutate(predictor = fct_relevel(predictor, "Post-TMDL", "Pre-TMDL", "No-TMDL"))
  
  m1_unadj <- glm(outcome ~ predictor,
                  family = binomial,
                  data = unadj_results)
  
  or <- or_glm(unadj_results, m1_unadj)
  
  
  
  
  ## make a cross-classification table
  
  unadj_results |> 
    group_by(predictor, outcome) |> 
    summarise(value = as.character(n())) |> 
    ungroup() |> 
    mutate(outcome = case_when(
      outcome == 0 ~ "No Improvement",
      outcome == 1 ~ "Improvement"
    ))-> ct1
  
  or |> 
    mutate(`95% CI` = paste0("(",`ci_low (2.5)`, ", ", `ci_high (97.5)`,")")) |> 
    select(-c(`ci_low (2.5)`, `ci_high (97.5)`, increment)) |>
    dplyr::rename(`Odds Ratio` = oddsratio) |> 
    mutate(`Odds Ratio` = as.character(`Odds Ratio`),
           `95% CI` = as.character(`95% CI`)) |> 
    pivot_longer(cols = c(`Odds Ratio`, `95% CI`), names_to = "outcome") |> 
    bind_rows(tibble(predictor = names(coefficients(m1_unadj)[2:3]),
                     outcome = "Log Odds",
                     value = as.character(round(coefficients(m1_unadj), 2)[2:3]))) |> 
    mutate(predictor = str_sub(predictor, start = 10)) |> 
    bind_rows(tibble(predictor = c("Post-TMDL", "Post-TMDL", "Post-TMDL"),
                     outcome = c("Odds Ratio", "95% CI", "Log Odds"),
                     value = c("1", "—", "0.00"))) -> ct2
  
  ct1 |> 
    bind_rows(ct2) -> summarytab
  
  summarytab |> 
    pivot_wider(names_from = predictor, values_from = value) |> 
    gt() |> 
    tab_row_group(label = "", 
                  id = "outcomes",
                  rows = outcome %in% c("No Improvement", "Improvement")) |> 
    summary_rows(groups = c("outcomes"), fns = list(Total = ~sum(as.numeric(.))))
  
}

cc_tab_2 <- function(x) {
  
  adj_results <- x %>%
    mutate(TMDL = as.factor(TMDL),
           outcome = case_when(
             fa_slope < 0 & fa_pvalue < 0.10 ~ 1,
             !(fa_slope < 0 & fa_pvalue < 0.10) ~ 0
           ),
           outcome = as.numeric(outcome)) |> 
    dplyr::select(MonitoringLocationIdentifier,
                  TMDL,
                  tmdl_status,
                  outcome) |> 
    mutate(predictor = as_factor(tmdl_status)) |> 
    mutate(predictor = fct_relevel(predictor, "Post-TMDL", "Pre-TMDL", "No-TMDL"))
  
  m1_adj <- glm(outcome ~ predictor,
                family = binomial,
                data = adj_results)
  
  
  or <- or_glm(adj_results, m1_adj)
  
  
  ## make a cross-classification table
  
  
  adj_results |> 
    group_by(predictor, outcome) |> 
    summarise(value = as.character(n())) |> 
    ungroup() |> 
    mutate(outcome = case_when(
      outcome == 0 ~ "No Improvement",
      outcome == 1 ~ "Improvement"
    ))-> ct1
  
  or |> 
    mutate(`95% CI` = paste0("(",`ci_low (2.5)`, ", ", `ci_high (97.5)`,")")) |> 
    select(-c(`ci_low (2.5)`, `ci_high (97.5)`, increment)) |>
    dplyr::rename(`Odds Ratio` = oddsratio) |> 
    mutate(`Odds Ratio` = as.character(`Odds Ratio`),
           `95% CI` = as.character(`95% CI`)) |> 
    pivot_longer(cols = c(`Odds Ratio`, `95% CI`), names_to = "outcome") |> 
    bind_rows(tibble(predictor = names(coefficients(m1_adj)[2:3]),
                     outcome = "Log Odds",
                     value = as.character(round(coefficients(m1_adj), 2)[2:3]))) |> 
    mutate(predictor = str_sub(predictor, start = 10)) |> 
    bind_rows(tibble(predictor = c("Post-TMDL", "Post-TMDL", "Post-TMDL"),
                     outcome = c("Odds Ratio", "95% CI", "Log Odds"),
                     value = c("1", "—", "0.00"))) -> ct2
  
  ct1 |> 
    bind_rows(ct2) -> summarytab
  
  summarytab |> 
    pivot_wider(names_from = predictor, values_from = value) |> 
    gt() |> 
    tab_row_group(label = "", 
                  id = "outcomes",
                  rows = outcome %in% c("No Improvement", "Improvement")) |> 
    summary_rows(groups = c("outcomes"), fns = list(Total = ~sum(as.numeric(.))))
}

