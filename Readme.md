Total Maximum Daily Loads and Escherichia coli trends in Texas
freshwater streams
================

[![License: CC
BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![DOI](https://zenodo.org/badge/307874510.svg)](https://zenodo.org/badge/latestdoi/307874510)

    ## [1] "Time of last build: 2020-12-17 10:26:58"

This repository contains the data and code for Schramm, Gitter, and
Gregory, “Total Maximum Daily Loads and *Escherichia coli* trends in
Texas freshwater streams.” Manuscript is currently in submission.

## Introduction

This project uses R and the `drake` package to manage workflow and
promote reproducibility. Research data and metadata are located in:

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

Code and data are shared un the CC By 4.0 license. If you use the code
or data, please cite this source per the DOI and the DOI of the paper
(in submission).

### System config

    ## - Session info -----------------------------------------------------------------------------------------------------------------
    ##  setting  value                       
    ##  version  R version 3.6.2 (2019-12-12)
    ##  os       Windows 10 x64              
    ##  system   x86_64, mingw32             
    ##  ui       RStudio                     
    ##  language (EN)                        
    ##  collate  English_United States.1252  
    ##  ctype    English_United States.1252  
    ##  tz       America/Chicago             
    ##  date     2020-12-17                  
    ## 
    ## - Packages ---------------------------------------------------------------------------------------------------------------------
    ##  package       * version  date       lib source                              
    ##  abind           1.4-5    2016-07-21 [1] CRAN (R 3.6.0)                      
    ##  akima           0.6-2    2016-12-20 [1] CRAN (R 3.6.2)                      
    ##  archive       * 1.0.0    2020-10-09 [1] Github (jimhester/archive@0a05060)  
    ##  assertthat      0.2.1    2019-03-21 [1] CRAN (R 3.6.2)                      
    ##  backports       1.1.5    2019-10-02 [1] CRAN (R 3.6.1)                      
    ##  base64enc       0.1-3    2015-07-28 [1] CRAN (R 3.6.0)                      
    ##  base64url       1.4      2018-05-14 [1] CRAN (R 3.6.2)                      
    ##  beeswarm        0.2.3    2016-04-25 [1] CRAN (R 3.6.0)                      
    ##  bookdown      * 0.21     2020-10-13 [1] CRAN (R 3.6.3)                      
    ##  boot            1.3-24   2019-12-20 [1] CRAN (R 3.6.2)                      
    ##  broom           0.7.2    2020-10-20 [1] CRAN (R 3.6.3)                      
    ##  Cairo         * 1.5-10   2019-03-28 [1] CRAN (R 3.6.0)                      
    ##  car             3.0-6    2019-12-23 [1] CRAN (R 3.6.2)                      
    ##  carData         3.0-3    2019-11-16 [1] CRAN (R 3.6.1)                      
    ##  cellranger      1.1.0    2016-07-27 [1] CRAN (R 3.6.2)                      
    ##  class           7.3-15   2019-01-01 [1] CRAN (R 3.6.2)                      
    ##  classInt        0.4-3    2020-04-07 [1] CRAN (R 3.6.3)                      
    ##  cli             2.2.0    2020-11-20 [1] CRAN (R 3.6.3)                      
    ##  coda            0.19-3   2019-07-05 [1] CRAN (R 3.6.2)                      
    ##  colorspace      1.4-1    2019-03-18 [1] CRAN (R 3.6.1)                      
    ##  crayon          1.3.4    2017-09-16 [1] CRAN (R 3.6.2)                      
    ##  curl            4.3      2019-12-02 [1] CRAN (R 3.6.2)                      
    ##  data.table      1.12.8   2019-12-09 [1] CRAN (R 3.6.2)                      
    ##  dataRetrieval * 2.7.6    2020-03-11 [1] CRAN (R 3.6.3)                      
    ##  DBI             1.1.0    2019-12-15 [1] CRAN (R 3.6.2)                      
    ##  dbplyr          1.4.2    2019-06-17 [1] CRAN (R 3.6.2)                      
    ##  DescTools       0.99.32  2020-01-17 [1] CRAN (R 3.6.2)                      
    ##  digest          0.6.27   2020-10-24 [1] CRAN (R 3.6.3)                      
    ##  dplyr         * 1.0.2    2020-08-18 [1] CRAN (R 3.6.3)                      
    ##  drake         * 7.9.0    2020-01-08 [1] CRAN (R 3.6.2)                      
    ##  e1071           1.7-3    2019-11-26 [1] CRAN (R 3.6.2)                      
    ##  ellipsis        0.3.1    2020-05-15 [1] CRAN (R 3.6.3)                      
    ##  emmeans       * 1.4.7    2020-05-25 [1] CRAN (R 3.6.3)                      
    ##  estimability    1.3      2018-02-11 [1] CRAN (R 3.6.0)                      
    ##  evaluate        0.14     2019-05-28 [1] CRAN (R 3.6.2)                      
    ##  expm            0.999-4  2019-03-21 [1] CRAN (R 3.6.2)                      
    ##  extrafont     * 0.17     2014-12-08 [1] CRAN (R 3.6.2)                      
    ##  extrafontdb     1.0      2012-06-11 [1] CRAN (R 3.6.0)                      
    ##  fansi           0.4.1    2020-01-08 [1] CRAN (R 3.6.2)                      
    ##  filelock        1.0.2    2018-10-05 [1] CRAN (R 3.6.2)                      
    ##  flextable     * 0.5.10   2020-05-15 [1] CRAN (R 3.6.3)                      
    ##  forcats       * 0.5.0    2020-03-01 [1] CRAN (R 3.6.3)                      
    ##  foreign         0.8-75   2020-01-20 [1] CRAN (R 3.6.2)                      
    ##  fs              1.5.0    2020-07-31 [1] CRAN (R 3.6.3)                      
    ##  gdtools         0.2.1    2019-10-14 [1] CRAN (R 3.6.2)                      
    ##  generics        0.1.0    2020-10-31 [1] CRAN (R 3.6.3)                      
    ##  ggbeeswarm      0.6.0    2017-08-07 [1] CRAN (R 3.6.2)                      
    ##  ggplot2       * 3.3.2    2020-06-19 [1] CRAN (R 3.6.3)                      
    ##  ggstance      * 0.3.4    2020-04-02 [1] CRAN (R 3.6.3)                      
    ##  glue            1.4.2    2020-08-27 [1] CRAN (R 3.6.3)                      
    ##  gtable          0.3.0    2019-03-25 [1] CRAN (R 3.6.2)                      
    ##  haven           2.2.0    2019-11-08 [1] CRAN (R 3.6.2)                      
    ##  here          * 0.1      2017-05-28 [1] CRAN (R 3.6.3)                      
    ##  hms             0.5.3    2020-01-08 [1] CRAN (R 3.6.2)                      
    ##  hrbrthemes    * 0.8.0    2020-03-06 [1] CRAN (R 3.6.3)                      
    ##  htmltools       0.5.0    2020-06-16 [1] CRAN (R 3.6.3)                      
    ##  httr            1.4.2    2020-07-20 [1] CRAN (R 3.6.3)                      
    ##  igraph          1.2.5    2020-03-19 [1] CRAN (R 3.6.3)                      
    ##  jsonlite        1.7.2    2020-12-09 [1] CRAN (R 3.6.3)                      
    ##  KernSmooth      2.23-16  2019-10-15 [1] CRAN (R 3.6.2)                      
    ##  knitr         * 1.30     2020-09-22 [1] CRAN (R 3.6.3)                      
    ##  lattice         0.20-38  2018-11-04 [1] CRAN (R 3.6.2)                      
    ##  leaps           3.1      2020-01-16 [1] CRAN (R 3.6.2)                      
    ##  lifecycle       0.2.0    2020-03-06 [1] CRAN (R 3.6.3)                      
    ##  lubridate     * 1.7.9.2  2020-11-13 [1] CRAN (R 3.6.3)                      
    ##  magrittr        2.0.1    2020-11-17 [1] CRAN (R 3.6.3)                      
    ##  MASS            7.3-51.5 2019-12-20 [1] CRAN (R 3.6.2)                      
    ##  Matrix          1.2-18   2019-11-27 [1] CRAN (R 3.6.2)                      
    ##  memoise         1.1.0    2017-04-21 [1] CRAN (R 3.6.2)                      
    ##  mgcv            1.8-31   2019-11-09 [1] CRAN (R 3.6.2)                      
    ##  modelr          0.1.5    2019-08-08 [1] CRAN (R 3.6.2)                      
    ##  munsell         0.5.0    2018-06-12 [1] CRAN (R 3.6.2)                      
    ##  mvtnorm         1.0-11   2019-06-19 [1] CRAN (R 3.6.0)                      
    ##  nhdplusTools  * 0.3.15   2020-09-07 [1] Github (USGS-R/nhdplusTools@efe512f)
    ##  nlme            3.1-143  2019-12-10 [1] CRAN (R 3.6.2)                      
    ##  officedown    * 0.2.0    2020-06-29 [1] CRAN (R 3.6.3)                      
    ##  officer       * 0.3.15   2020-11-01 [1] CRAN (R 3.6.2)                      
    ##  openxlsx        4.1.4    2019-12-06 [1] CRAN (R 3.6.2)                      
    ##  packrat         0.5.0    2018-11-14 [1] CRAN (R 3.6.2)                      
    ##  patchwork     * 1.0.0    2019-12-01 [1] CRAN (R 3.6.2)                      
    ##  pillar          1.4.7    2020-11-20 [1] CRAN (R 3.6.3)                      
    ##  pkgconfig       2.0.3    2019-09-22 [1] CRAN (R 3.6.2)                      
    ##  png             0.1-7    2013-12-03 [1] CRAN (R 3.6.0)                      
    ##  purrr         * 0.3.4    2020-04-17 [1] CRAN (R 3.6.3)                      
    ##  R6              2.5.0    2020-10-28 [1] CRAN (R 3.6.3)                      
    ##  ragg          * 0.4.0    2020-10-05 [1] CRAN (R 3.6.3)                      
    ##  randtests       1.0      2014-11-17 [1] CRAN (R 3.6.0)                      
    ##  RANN            2.6.1    2019-01-08 [1] CRAN (R 3.6.2)                      
    ##  Rcpp            1.0.5    2020-07-06 [1] CRAN (R 3.6.3)                      
    ##  readr         * 1.4.0    2020-10-05 [1] CRAN (R 3.6.3)                      
    ##  readxl          1.3.1    2019-03-13 [1] CRAN (R 3.6.2)                      
    ##  reprex          0.3.0    2019-05-16 [1] CRAN (R 3.6.3)                      
    ##  rio             0.5.16   2018-11-26 [1] CRAN (R 3.6.2)                      
    ##  rlang           0.4.9    2020-11-26 [1] CRAN (R 3.6.3)                      
    ##  rmarkdown       2.6      2020-12-14 [1] CRAN (R 3.6.2)                      
    ##  rprojroot       1.3-2    2018-01-03 [1] CRAN (R 3.6.2)                      
    ##  rstudioapi      0.10     2019-03-19 [1] CRAN (R 3.6.2)                      
    ##  Rttf2pt1        1.3.8    2020-01-10 [1] CRAN (R 3.6.2)                      
    ##  rvest         * 0.3.6    2020-07-25 [1] CRAN (R 3.6.3)                      
    ##  rvg             0.2.4    2020-02-17 [1] CRAN (R 3.6.3)                      
    ##  scales          1.1.0    2019-11-18 [1] CRAN (R 3.6.2)                      
    ##  sessioninfo     1.1.1    2018-11-05 [1] CRAN (R 3.6.2)                      
    ##  sf            * 0.9-5    2020-07-14 [1] CRAN (R 3.6.3)                      
    ##  smwrBase      * 1.1.5    2019-04-30 [1] local                               
    ##  smwrGraphs    * 1.1.4    2019-04-30 [1] local                               
    ##  smwrStats     * 0.7.6    2019-04-30 [1] local                               
    ##  sp              1.4-2    2020-05-20 [1] CRAN (R 3.6.3)                      
    ##  storr           1.2.1    2018-10-18 [1] CRAN (R 3.6.2)                      
    ##  stringi         1.5.3    2020-09-09 [1] CRAN (R 3.6.3)                      
    ##  stringr       * 1.4.0    2019-02-10 [1] CRAN (R 3.6.2)                      
    ##  systemfonts     0.3.2    2020-09-29 [1] CRAN (R 3.6.3)                      
    ##  texreg        * 1.37.5   2020-06-16 [1] local                               
    ##  textshaping     0.1.2    2020-10-08 [1] CRAN (R 3.6.3)                      
    ##  tibble        * 3.0.4    2020-10-12 [1] CRAN (R 3.6.3)                      
    ##  tidyr         * 1.1.2    2020-08-27 [1] CRAN (R 3.6.3)                      
    ##  tidyselect      1.1.0    2020-05-11 [1] CRAN (R 3.6.3)                      
    ##  tidyverse     * 1.3.0    2019-11-21 [1] CRAN (R 3.6.2)                      
    ##  txtq            0.2.0    2019-10-15 [1] CRAN (R 3.6.2)                      
    ##  units           0.6-7    2020-06-13 [1] CRAN (R 3.6.3)                      
    ##  uuid            0.1-4    2020-02-26 [1] CRAN (R 3.6.3)                      
    ##  vctrs           0.3.5    2020-11-17 [1] CRAN (R 3.6.3)                      
    ##  vipor           0.4.5    2017-03-22 [1] CRAN (R 3.6.2)                      
    ##  withr           2.3.0    2020-09-22 [1] CRAN (R 3.6.3)                      
    ##  xfun            0.19     2020-10-30 [1] CRAN (R 3.6.3)                      
    ##  xml2          * 1.3.2    2020-04-23 [1] CRAN (R 3.6.3)                      
    ##  xtable          1.8-4    2019-04-21 [1] CRAN (R 3.6.2)                      
    ##  yaml            2.2.1    2020-02-01 [1] CRAN (R 3.6.3)                      
    ##  zip             2.1.1    2020-08-27 [1] CRAN (R 3.6.3)                      
    ## 
    ## [1] C:/Users/michael.schramm/Documents/R/R-3.6.2/library
