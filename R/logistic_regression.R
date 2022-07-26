
####################################
#### Fits logisitic regressions ####
####################################

fit_lr_models <- function(fa_results, 
                          unadj_results) {
  
  ## unadjusted model
  unadj_results <- unadj_results %>%
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
    mutate(predictor = case_when(
      TMDL == 0 ~ "No-TMDL",
      TMDL == 1 & tmdl_status == "pre-tmdl" ~ "Pre-TMDL",
      tmdl_status == "post-tmdl" ~ "Post-TMDL"
    )) |> 
    mutate(predictor = as_factor(predictor)) |> 
    ## relevel so we can compare to pre-tmdl sites
    mutate(predictor = fct_relevel(predictor, "Pre-TMDL", "Post-TMDL", "No-TMDL"))
  
  m1_unadj <- glm(outcome ~ predictor,
                  family = binomial,
                  data = unadj_results)
  
  ## flow-adjusted model
  fa_results <- fa_results %>%
    mutate(TMDL = as.factor(TMDL),
           outcome = case_when(
             fa_slope < 0 & fa_pvalue < 0.10 ~ 1,
             !(fa_slope < 0 & fa_pvalue < 0.10) ~ 0
           ),
           outcome = as.numeric(outcome)) %>%
    dplyr::select(MonitoringLocationIdentifier,
                  TMDL,
                  outcome)
  
  m2_fa_adj <- glm(outcome ~ TMDL,
                  family = binomial,
                  data = fa_results)
  
  
  ## predict
  m1_predict <- emmeans::emmeans(m1_unadj, 
                                 specs = ~TMDL, 
                                 data = unadj_results, 
                                 type = "response") %>%
    summary() %>%
    mutate(model = "Model 1")
  
  m2_predict <- emmeans::emmeans(m2_fa_adj, 
                                 specs = ~TMDL, 
                                 data = fa_results, 
                                 type = "response") %>%
    summary() %>%
    mutate(model = "Model 2")
  
  
  p.data <- bind_rows(m1_predict, m2_predict)
  
  return(list(m1_unadj,
              m2_fa_adj,
              p.data))
  
}



