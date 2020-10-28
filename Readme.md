Readme
================

    ## [1] "Time of last build: 2020-10-27 20:38:40"

## Introduction

`R` files associated with data analysis and writing for this project.
This project uses the `drake` package to manage workflow and promote
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

  - **Water Quality Data**: Water quality data was obtained from the
    Water Quality Portal (<https://www.waterqualitydata.us/portal/>) and
    is stored as a `.tsv` file under the `data/STORET` directory. The
    source data can be downloaded directly using the following URL:
    <https://www.waterqualitydata.us/portal/#organization=TCEQMAIN&characteristicName=Escherichia%20coli&mimeType=tsv>

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
clean() # removes author's results
source("R/packages.R")  # loads packages
source("R/dataRetrieval_functions.R")
source("R/exploratory_report_functions.R")
source("R/plan.R")      # creates the drake plan
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
    ## [1] LC_COLLATE=English_United States.1252 
    ## [2] LC_CTYPE=English_United States.1252   
    ## [3] LC_MONETARY=English_United States.1252
    ## [4] LC_NUMERIC=C                          
    ## [5] LC_TIME=English_United States.1252    
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_3.6.2  magrittr_1.5    tools_3.6.2     htmltools_0.5.0
    ##  [5] yaml_2.2.0      stringi_1.4.6   rmarkdown_2.3   knitr_1.29     
    ##  [9] stringr_1.4.0   xfun_0.15       digest_0.6.25   rlang_0.4.7    
    ## [13] evaluate_0.14
