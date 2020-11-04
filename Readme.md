Readme
================

[![License: CC
BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

    ## [1] "Time of last build: 2020-11-04 17:01:53"

## Introduction

This project uses the `drake` package to manage workflow and promote
reproducibility.

Research data and metadata are located in:

    data/cleaned_data.csv
    data/flow_adjusted_mk_results.csv
    data/unadjusted_mk_results.csv
    data/metadata/

## Reproduce the Project

If you would like to reproduce the project please follow the suggested
guidelines below. The required R packages are detailed at the end.

### Requirements

  - **NHD Plus**: This project utilizes the NHD National Seamless
    geodatabase. This is not included in the repository due to size. If
    you have a local copy, the source code can be modified to point to
    it. Otherwise, use `nhdplusTools` to download a copy.

<!-- end list -->

``` r
nhdplusTools::download_nhdplusV2(outdir = here::here("data"))
```

## Building the project

### Check for evidence of reproducibility

``` r
library(drake)
make(plan)
config <- drake_config(plan)
outdated(config)
```

### Replicate the project

``` r
clean()
source("R/packages.R")  
source("R/download_data.R")
source("R/mann-kendall-tests.R")
source("R/logistic_regression.R")
source("R/figures.R")
source("R/tables.R")
source("R/plan.R")  

###########################
#### set local options ####
###########################

# specify path to your nhdplus database
nhd_data <- "E:\\TWRI\\Data-Resources\\NHDPlusV21_NationalData_Seamless_Geodatabase_Lower48_07\\NHDPlusNationalData\\NHDPlusV21_National_Seamless_Flattened_Lower48.gdb"

##########################################################
#### You shouldn't need to modify anything after this ####
##########################################################

nhdplus_path(nhd_data)

make(
  plan
)
```

## Info

### System config

``` r
sessionInfo()
```

    ## R version 3.6.2 (2019-12-12)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows 10 x64 (build 18363)
    ## 
    ## Matrix products: default
    ## 
    ## locale:
    ## [1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252    LC_MONETARY=English_United States.1252
    ## [4] LC_NUMERIC=C                           LC_TIME=English_United States.1252    
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] shiny_1.4.0         dataspice_1.0.0     texreg_1.37.5       Cairo_1.5-10        tidyselect_1.1.0    flextable_0.5.10   
    ##  [7] officedown_0.2.0    officer_0.3.15      bookdown_0.20       patchwork_1.0.0     ggstance_0.3.4      ragg_0.4.0         
    ## [13] here_0.1            extrafont_0.17      hrbrthemes_0.8.0    emmeans_1.4.7       smwrStats_0.7.6     smwrGraphs_1.1.4   
    ## [19] smwrBase_1.1.5      lubridate_1.7.4     archive_1.0.0       sf_0.9-5            knitr_1.29          nhdplusTools_0.3.15
    ## [25] dataRetrieval_2.7.6 rvest_0.3.6         xml2_1.3.2          forcats_0.4.0       stringr_1.4.0       dplyr_1.0.2        
    ## [31] purrr_0.3.4         readr_1.3.1         tidyr_1.1.2         tibble_3.0.3        ggplot2_3.3.2       tidyverse_1.3.0    
    ## [37] drake_7.9.0        
    ## 
    ## loaded via a namespace (and not attached):
    ##   [1] utf8_1.1.4          htmlwidgets_1.5.1   grid_3.6.2          devtools_2.2.2      munsell_0.5.0       base64url_1.4      
    ##   [7] units_0.6-7         withr_2.1.2         colorspace_1.4-1    filelock_1.0.2      highr_0.8           uuid_0.1-4         
    ##  [13] rstudioapi_0.10     leaps_3.1           DescTools_0.99.32   Rttf2pt1_1.3.8      labeling_0.3        git2r_0.26.1       
    ##  [19] farver_2.0.3        txtq_0.2.0          rprojroot_1.3-2     coda_0.19-3         vctrs_0.3.4         generics_0.0.2     
    ##  [25] xfun_0.15           R6_2.4.1            ggbeeswarm_0.6.0    assertthat_0.2.1    promises_1.1.0      scales_1.1.0       
    ##  [31] beeswarm_0.2.3      gtable_0.3.0        processx_3.4.3      rlang_0.4.7         akima_0.6-2         systemfonts_0.3.2  
    ##  [37] splines_3.6.2       extrafontdb_1.0     selectr_0.4-2       broom_0.5.4         yaml_2.2.0          abind_1.4-5        
    ##  [43] modelr_0.1.5        backports_1.1.5     httpuv_1.5.2        tools_3.6.2         usethis_1.6.1       ellipsis_0.3.1     
    ##  [49] sessioninfo_1.1.1   Rcpp_1.0.5          base64enc_0.1-3     classInt_0.4-3      ps_1.3.0            prettyunits_1.1.1  
    ##  [55] haven_2.2.0         fs_1.3.1            magrittr_1.5        data.table_1.12.8   openxlsx_4.1.4      reprex_0.3.0       
    ##  [61] RANN_2.6.1          mvtnorm_1.0-11      whisker_0.4         packrat_0.5.0       storr_1.2.1         pkgload_1.0.2      
    ##  [67] hms_0.5.3           mime_0.9            evaluate_0.14       xtable_1.8-4        rio_0.5.16          readxl_1.3.1       
    ##  [73] testthat_2.3.1      compiler_3.6.2      maps_3.3.0          KernSmooth_2.23-16  crayon_1.3.4        htmltools_0.5.0    
    ##  [79] mgcv_1.8-31         later_1.1.0.1       expm_0.999-4        DBI_1.1.0           dbplyr_1.4.2        MASS_7.3-51.5      
    ##  [85] boot_1.3-24         Matrix_1.2-18       car_3.0-6           cli_2.0.2           parallel_3.6.2      igraph_1.2.5       
    ##  [91] pkgconfig_2.0.3     foreign_0.8-75      sp_1.4-2            vipor_0.4.5         estimability_1.3    rvg_0.2.4          
    ##  [97] callr_3.4.1         digest_0.6.25       rmarkdown_2.3       cellranger_1.1.0    gdtools_0.2.1       curl_4.3           
    ## [103] lifecycle_0.2.0     nlme_3.1-143        jsonlite_1.7.0      carData_3.0-3       desc_1.2.0          fansi_0.4.1        
    ## [109] pillar_1.4.6        lattice_0.20-38     fastmap_1.0.1       httr_1.4.2          pkgbuild_1.0.6      glue_1.4.2         
    ## [115] remotes_2.1.0       zip_2.1.1           png_0.1-7           rhandsontable_0.3.7 class_7.3-15        stringi_1.4.6      
    ## [121] textshaping_0.1.2   randtests_1.0       memoise_1.1.0       e1071_1.7-3
