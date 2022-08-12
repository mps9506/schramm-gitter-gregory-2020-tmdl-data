## plan

plan <- drake_plan(
  
  ##################################
  #### Data import and cleaning ####
  ##################################
  
  ## tceq assessment units
  au = download_au(url = "https://opendata.arcgis.com/datasets/175c3cb32f2840eca2bf877b93173ff9_4.zip?outSR=%7B%22falseM%22%3A-100000%2C%22xyTolerance%22%3A8.98315284119521e-9%2C%22mUnits%22%3A10000%2C%22zUnits%22%3A1%2C%22latestWkid%22%3A4269%2C%22zTolerance%22%3A2%2C%22wkid%22%3A4269%2C%22xyUnits%22%3A11258999068426.24%2C%22mTolerance%22%3A0.001%2C%22falseX%22%3A-400%2C%22falseY%22%3A-400%2C%22falseZ%22%3A0%7D",
                   rel_path = "/Surface_Water.shp"),
  
  ## find sites
  site_info = find_sites(au),
  ecoli_data = get_ecoli(site_info),
  
  
  ## list of sites with sufficent E. coli data
  swqm_sites = clean_SWQM_with_ecoli(site_info, ecoli_data),
  
  
  ## setup NHDPlusTools
  nhd_plus_path = target(setup_nhd_tools()),
  flowline = setup_nhd_flowlines(nhd_plus_path),

  ## pair WQP sites with closest NWIS stream gage
  nldi_data = query_nldi(site_info, swqm_sites),
  nwis_wqp_data = setup_wqp_sites(nldi_data, flowline),

  ## next step is to get the flow record for each NWIS stream gage
  streamflow_record = download_streamflows(nwis_wqp_data),

  ## join everything
  cleaned_full_data = join_final_data(ecoli_data,
                                      swqm_sites,
                                      nwis_wqp_data,
                                      streamflow_record),
  
  #####################################
  #### Modified Mann-Kendall Tests ####
  #####################################

  unadjusted_mk_results = run_mk_test(cleaned_full_data),
  flow_adjusted_mk_results = run_fa_mk_test(cleaned_full_data),
  t_test_results = apply_t_test(unadjusted_mk_results, 
                                flow_adjusted_mk_results),
  

  ################
  #### Tables ####
  ################
  
  data_summary_table = summarize_data(cleaned_full_data,
                                      filename = file_out("tables/table_1.html")),
  
  cross_table_unadj = cc_tab_1(unadjusted_mk_results,
                               filename = file_out("tables/table_2.html")),
  cross_table_adj = cc_tab_2(flow_adjusted_mk_results,
                             filename = file_out("tables/table_3.html")),
  
  #################
  #### Figures ####
  #################
  # fig_1 = plot_data_summary(cleaned_full_data,
  #                           streamflow_record,
  #                           file_name = file_out("figures/fig_1.png"),
  #                           width = 140,
  #                           height = 95,
  #                           units = "mm",
  #                           res = 300),
  # 
  fig_2 = plot_cume_dist(flow_adjusted_mk_results,
                         unadjusted_mk_results,
                         file_name = file_out("figures/fig_1.pdf"),
                         width = 190,
                         height = 142.5,
                         units = "mm",
                         res = 300),

  fig_3 = plot_mk_map(flow_adjusted_mk_results,
                      unadjusted_mk_results,
                      file_name = file_out("figures/fig_2.pdf"),
                      width = 190,
                      height = 190,
                      units = "mm",
                      res = 300),

  #####################
  #### Export Data ####
  #####################

  
  ###########################
  #### Render Manuscript ####
  ###########################

  # manuscript = rmarkdown::render(
  #   knitr_in("C:/Data-Analysis-Projects/schramm-gitter-gregory-2020-tmdl-data/manuscript/jcwre-manuscript.Rmd"),
  #   output_file = file_out("C:/Data-Analysis-Projects/schramm-gitter-gregory-2020-tmdl-data/manuscript/jcwre-manuscript.docx")
  # ),

  
  #######################
  #### Render Readme ####
  #######################
  
  readme = rmarkdown::render(
    knitr_in("Readme.Rmd"),
    output_file = file_out("Readme.md"),
    quiet = TRUE
  )
)
