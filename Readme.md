Readme
================

    ## [1] "Time of last build: 2020-10-27 22:41:25"

## Introduction

`R` files associated with data acquisition and cleaning for … This
project uses the `drake` package to manage workflow and promote
reproducibility.

### Requirements

  - **NHD Plus**: This project utilizes the NHD National Seamless
    geodatabase. This is not included in the repository due to size. If
    you have a local copy, the source code can be modified to point to
    it. Otherwise, use `nhdplusTools` to download a copy.

<!-- end list -->

``` r
nhdplusTools::download_nhdplusV2(outdir = here::here("data"))
```

### Set local paths

The `make.R` file should be updated with the appropriate file paths to
`gdal v2.3.3` directory, the NHD geodatabase location, and NLCD data
location.

``` r
###########################
#### set local options ####
###########################
# gdal v2.3.3 or greater must be installed
# specify the path that gdal_warp.exe can be found
gdal_directory <- "C:\\Users\\User.Name\\AppData\\Local\\Continuum\\anaconda3\\Library"
# specify path to your nhdplus database
nhd_data <- here::here("data/NHDPlusV21_NationalData_Seamless_Geodatabase_Lower48_07/NHDPlusNationalData/NHDPlusV21_National_Seamless_Flattened_Lower48.gdb")
```

## Building the project

### Check for evidence of reproducibility

``` r
make(plan)
config <- drake_config(plan)
outdated(config)
```

### Replicate the project

``` r
clean()
source("R/packages.R")
source("R/download_data.R")
source("R/plan.R")

#######################
#### Local options ####
#######################

## specify path to your nhdplus database
nhd_data <- "E:\\TWRI\\Data-Resources\\NHDPlusV21_NationalData_Seamless_Geodatabase_Lower48_07\\NHDPlusNationalData\\NHDPlusV21_National_Seamless_Flattened_Lower48.gdb"

##########################################################
#### You shouldn't need to modify anything after this ####
##########################################################

nhdplus_path(nhd_data)
make(plan)
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
    ## [1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252   
    ## [3] LC_MONETARY=English_United States.1252 LC_NUMERIC=C                          
    ## [5] LC_TIME=English_United States.1252    
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] tidyselect_1.1.0    smwrStats_0.7.6     smwrGraphs_1.1.4    smwrBase_1.1.5      lubridate_1.7.4    
    ##  [6] sf_0.9-5            knitr_1.29          nhdplusTools_0.3.15 dataRetrieval_2.7.6 forcats_0.4.0      
    ## [11] stringr_1.4.0       dplyr_1.0.2         purrr_0.3.4         readr_1.3.1         tidyr_1.1.2        
    ## [16] tibble_3.0.3        ggplot2_3.2.1       tidyverse_1.3.0     drake_7.9.0        
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] nlme_3.1-143       fs_1.3.1           filelock_1.0.2     httr_1.4.2         tools_3.6.2       
    ##  [6] backports_1.1.5    utf8_1.1.4         R6_2.4.1           KernSmooth_2.23-16 DBI_1.1.0         
    ## [11] lazyeval_0.2.2     colorspace_1.4-1   withr_2.1.2        sp_1.4-2           curl_4.3          
    ## [16] compiler_3.6.2     cli_2.0.2          rvest_0.3.5        xml2_1.3.2         randtests_1.0     
    ## [21] scales_1.1.0       classInt_0.4-3     digest_0.6.25      foreign_0.8-75     txtq_0.2.0        
    ## [26] rmarkdown_2.3      rio_0.5.16         htmltools_0.5.0    pkgconfig_2.0.3    akima_0.6-2       
    ## [31] dbplyr_1.4.2       rlang_0.4.7        readxl_1.3.1       rstudioapi_0.10    generics_0.0.2    
    ## [36] jsonlite_1.7.0     zip_2.0.4          car_3.0-6          magrittr_1.5       leaps_3.1         
    ## [41] Rcpp_1.0.5         munsell_0.5.0      fansi_0.4.1        abind_1.4-5        lifecycle_0.2.0   
    ## [46] yaml_2.2.0         stringi_1.4.6      carData_3.0-3      storr_1.2.1        grid_3.6.2        
    ## [51] parallel_3.6.2     crayon_1.3.4       lattice_0.20-38    haven_2.2.0        hms_0.5.3         
    ## [56] pillar_1.4.6       igraph_1.2.5       base64url_1.4      reprex_0.3.0       glue_1.4.2        
    ## [61] evaluate_0.14      packrat_0.5.0      data.table_1.12.8  modelr_0.1.5       vctrs_0.3.4       
    ## [66] cellranger_1.1.0   gtable_0.3.0       RANN_2.6.1         assertthat_0.2.1   xfun_0.15         
    ## [71] openxlsx_4.1.4     broom_0.5.4        e1071_1.7-3        class_7.3-15       memoise_1.1.0     
    ## [76] units_0.6-7        ellipsis_0.3.1
