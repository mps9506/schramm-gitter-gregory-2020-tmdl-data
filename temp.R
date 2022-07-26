x <- readd(unadjusted_mk_results)
y <- readd(flow_adjusted_mk_results)

df <- x %>%
  dplyr::select(MonitoringLocationIdentifier, tmdl_status, slope) %>%
  right_join(y %>% select(MonitoringLocationIdentifier, tmdl_status, fa_slope)) %>%
  filter(tmdl_status == "Post-TMDL")

t.test(Pair(slope, fa_slope) ~ 1,
       data = df)
