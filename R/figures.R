
theme_ms <- function(axis = FALSE,
                     axis_title_just = "c",
                     plot_margin = margin(10, 10, 10, 10),
                     base_family = "Open Sans", 
                     base_size = 11,
                     ticks = TRUE,
                     ...) {
  theme_ipsum(axis = axis,
              axis_title_just = axis_title_just,
              plot_margin = plot_margin,
              base_family = base_family, 
              base_size = base_size,
              strip_text_family = "Open Sans",
              ...) +
    theme(text = element_text(family = "Open Sans", color = "#22211d"),
          panel.border = element_rect(color = "black",
                                      fill = NA,
                                      size = .25))
}

plot_cume_dist <- function(fa_results, 
                           unadj_results,
                           file_name,
                           width,
                           height,
                           units,
                           res) {
  p1 <- unadj_results %>%
    left_join(fa_results) %>%
    tidyr::pivot_longer(cols = c("slope", "fa_slope"), names_to = "flow_adjustment", values_to = "slope") %>%
    mutate(pvalue = case_when(
      flow_adjustment == "slope" ~ pvalue,
      flow_adjustment == "fa_slope" ~ fa_pvalue
    )) %>%
    mutate(TMDL = forcats::fct_recode(as_factor(TMDL), "No TMDL" = "0", "TMDL" = "1"),
           flow_adjustment = forcats::fct_recode(as_factor(flow_adjustment), "Unadjusted Mann-Kendall" = "slope", "Flow-Adjusted Mann-Kendall" = "fa_slope")) %>%
    filter(!is.na(pvalue)) %>%
    group_by(flow_adjustment, TMDL) %>%
    mutate(slope_cdf = cume_dist(slope)) %>%
    ggplot() +
    facet_grid(TMDL~flow_adjustment) +
    geom_point(aes(slope, slope_cdf, color = pvalue), size = 1) +
    geom_vline(xintercept = 0, linetype = 2) +
    scale_color_viridis_c(option = "plasma", name = expression(paste("modified Mann-Kendall ",italic("p"), "-value")),
                          guide = guide_colourbar(barheight = grid::unit(1/8, "in"))) +
    coord_cartesian(xlim = c(-0.8, 0.8)) +
    labs(x = "Slope\n[log(MPN/100 mL)/year]",
         y = "Cumulative Distribution") +
    theme_ms() +
    theme(legend.position = "bottom")
  agg_png(file_name,
          width = width,
          height = height,
          units = units,
          res = res)
  plot(p1)
  invisible(dev.off())
  
}


plot_mk_map <- function(fa_results, 
                        unadj_results, 
                        file_name,
                        width,
                        height,
                        units,
                        res) {
  
  tx <- st_read("https://opendata.arcgis.com/datasets/19506ce7231346ed809a384a5fc211b1_0.geojson")
  
  p1 <- unadj_results %>%
    left_join(fa_results) %>%
    tidyr::pivot_longer(cols = c("slope", "fa_slope"), names_to = "flow_adjustment", values_to = "slope") %>%
    mutate(pvalue = case_when(
      flow_adjustment == "slope" ~ pvalue,
      flow_adjustment == "fa_slope" ~ fa_pvalue
    )) %>%
    mutate(TMDL = forcats::fct_recode(as_factor(TMDL), "No TMDL" = "0", "TMDL" = "1"),
           flow_adjustment = forcats::fct_recode(as_factor(flow_adjustment), "Unadjusted Mann-Kendall" = "slope", "Flow-Adjusted Mann-Kendall" = "fa_slope")) %>%
    filter(!is.na(pvalue)) %>%
    mutate(trend_direction = case_when(
      slope < 0 & pvalue <= 0.10 ~ "Significant Decrease",
      slope < 0 & pvalue >= 0.10 ~ "No Trend",
      slope > 0 & pvalue >= 0.10 ~ "No Trend",
      slope > 0 & pvalue <= 0.10 ~ "Significant Increase"
    ))  %>%
    st_as_sf() %>%
    st_set_crs(4326)  %>%
    ggplot() +
    geom_sf(data = tx) +
    geom_sf(data = . %>% filter(trend_direction != "Significant Decrease"), 
            aes(shape = trend_direction,
                fill = trend_direction), alpha = 0.35) +
    geom_sf(data = . %>% filter(trend_direction == "Significant Decrease"), 
            aes(shape = trend_direction,
                fill = trend_direction), alpha = 0.7) +
    scale_shape_manual(values = c("Significant Decrease" = 25, 
                                  "Significant Increase" = 24, 
                                  "No Trend" = 21)) +
    scale_fill_manual(values = c("Significant Decrease" = "#67a9cf", 
                                 "Significant Increase" = "#ef8a62", 
                                 "No Trend" = "#ef8a62")) + 
    facet_grid(TMDL~flow_adjustment) +
    theme_ms(axis_text_size = 7) +
    theme(legend.position = "bottom",
          legend.title = element_blank())
  
  agg_png(file_name,
          width = width,
          height = height,
          units = units,
          res = res)
  plot(p1)
  invisible(dev.off())
    
}

