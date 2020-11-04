
################
#### Tables ####
################

## note these are texreg objects formatted for ms word

## Data Summary
summarize_data <- function(cleaned_data) {
  
  full_data <- cleaned_data %>%
    group_by(MonitoringLocationIdentifier, TMDL) %>%
    summarize(value = DescTools::Gmean(ResultMeasureValue),
              n_samples = n(),
              .groups = "drop") %>%
    group_by(TMDL) %>%
    summarize(n = n(),
              samples_per_station = round(mean(n_samples), 2),
              mean = round(DescTools::Gmean(value), 2),
              sd = round(DescTools::Gsd(value), 2),
              .groups = "drop") %>%
    mutate(data_type = "Unadjusted Data",
           TMDL = case_when(
             TMDL == 0 ~ "No TMDL",
             TMDL == 1 ~ "TMDL Present"
           ))
  
  
  #fa data
  keep_stations <- cleaned_data %>%
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
  
  
  fa_data <- cleaned_data %>%
    filter(MonitoringLocationIdentifier %in% keep_stations$MonitoringLocationIdentifier) %>%
    filter(!is.na(Flow)) %>%
    filter(MonitoringLocationIdentifier != "TCEQMAIN-12185") %>% ## manual filtering
    dplyr::select(ActivityStartDate, Flow, MonitoringLocationIdentifier, geometry, ResultMeasureValue, Impaired, TMDL) %>%
    filter(ActivityStartDate >= as.Date("2012-01-01")) %>%
    group_by(MonitoringLocationIdentifier, TMDL) %>%
    summarize(value = DescTools::Gmean(ResultMeasureValue),
              n_samples = n(),
              .groups = "drop") %>%
    group_by(TMDL) %>%
    summarize(n = n(),
              samples_per_station = round(mean(n_samples), 2),
              mean = round(DescTools::Gmean(value), 2),
              sd = round(DescTools::Gsd(value), 2),
              .groups = "drop") %>%
    mutate(data_type = "Flow-Adjusted Data",
           TMDL = case_when(
             TMDL == 0 ~ "No TMDL",
             TMDL == 1 ~ "TMDL Present"
           ))
  
  out_df <- bind_rows(full_data, fa_data)
  flextable::flextable(out_df,
                       col_keys = c("data_type", "TMDL", "n",
                                    "samples_per_station", "mean", "sd")) %>%
    set_header_labels(data_type = "",
                      TMDL = "",
                      n = "SWQM Stations (n)") %>%
    compose(part = "header",
            j = "samples_per_station",
            value = as_paragraph("Mean ", as_i("E. coli"), " Samples per Station (n)")) %>%
    compose(part = "header",
            j = "mean",
            value = as_paragraph("Geometric Mean ", as_i("E. coli"), " Concentration (MPN/100 mL)")) %>%
    compose(part = "header",
            j = "sd",
            value = as_paragraph("Geometric SD ", as_i("E. coli"), " Concentration (MPN/100 mL)")) %>%
    merge_v(j = ~data_type) %>%
    hline(i = 2, border = fp_border()) %>%
    set_table_properties(layout = "autofit",
                         width = 0.75)
  
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
