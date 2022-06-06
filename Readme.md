Total Maximum Daily Loads and Escherichia coli trends in Texas
freshwater streams
================

[![License: CC BY
4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![DOI](https://zenodo.org/badge/307874510.svg)](https://zenodo.org/badge/latestdoi/307874510)

    ## [1] "Time of last build: 2022-06-03 10:52:51"

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

-   **NHD Plus**: This project utilizes the NHD National Seamless
    geodatabase. This is not included in the repository due to size. If
    you have a local copy, the source code can be modified to point to
    it. Otherwise, use `nhdplusTools` to download a copy.

``` r
nhdplusTools::download_nhdplusV2(outdir = here::here("data"))
```

## Building the project

### Check for evidence of reproducibility

``` r
renv::restore()
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

Code and data are shared under the CC By 4.0 license. If you use the
code or data, please cite this source per the DOI and the DOI of the
paper (in submission).

### System config

    ## - Session info ------------------------------------------------------------------------------------------------
    ##  setting  value
    ##  version  R version 4.1.3 (2022-03-10)
    ##  os       Windows 10 x64 (build 19044)
    ##  system   x86_64, mingw32
    ##  ui       RStudio
    ##  language (EN)
    ##  collate  English_United States.1252
    ##  ctype    English_United States.1252
    ##  tz       America/Chicago
    ##  date     2022-06-03
    ##  rstudio  2022.02.1+461 Prairie Trillium (desktop)
    ##  pandoc   2.17.1.1 @ C:/Program Files/RStudio/bin/quarto/bin/ (via rmarkdown)
    ## 
    ## - Packages ----------------------------------------------------------------------------------------------------
    ##  !  package       * version    date (UTC) lib source
    ##  P  abind           1.4-5      2016-07-21 [?] CRAN (R 4.1.1)
    ##  P  akima           0.6-2.3    2021-11-02 [?] CRAN (R 4.1.3)
    ##  PD archive       * 1.1.3      2021-11-30 [?] CRAN (R 4.1.2)
    ##  P  assertthat      0.2.1      2019-03-21 [?] CRAN (R 4.1.3)
    ##  P  backports       1.4.1      2021-12-13 [?] CRAN (R 4.1.2)
    ##  P  base64enc       0.1-3      2015-07-28 [?] CRAN (R 4.1.1)
    ##  P  base64url       1.4        2018-05-14 [?] CRAN (R 4.1.3)
    ##  P  beeswarm        0.4.0      2021-06-01 [?] CRAN (R 4.1.1)
    ##  P  bit             4.0.4      2020-08-04 [?] CRAN (R 4.1.3)
    ##  P  bit64           4.0.5      2020-08-30 [?] CRAN (R 4.1.3)
    ##  P  bookdown      * 0.24       2021-09-02 [?] CRAN (R 4.1.3)
    ##     boot            1.3-28     2021-05-03 [2] CRAN (R 4.1.3)
    ##  P  broom           0.7.11     2022-01-03 [?] CRAN (R 4.1.2)
    ##  P  cachem          1.0.6      2021-08-19 [?] CRAN (R 4.1.3)
    ##  P  car             3.0-12     2021-11-06 [?] CRAN (R 4.1.3)
    ##  P  carData         3.0-5      2022-01-06 [?] CRAN (R 4.1.3)
    ##  P  cellranger      1.1.0      2016-07-27 [?] CRAN (R 4.1.3)
    ##     class           7.3-20     2022-01-16 [2] CRAN (R 4.1.3)
    ##  P  classInt        0.4-3      2020-04-07 [?] CRAN (R 4.1.3)
    ##  P  cli             3.1.1      2022-01-20 [?] CRAN (R 4.1.2)
    ##  P  colorspace      2.0-2      2021-06-24 [?] CRAN (R 4.1.2)
    ##  P  crayon          1.4.2      2021-10-29 [?] CRAN (R 4.1.2)
    ##  P  curl            4.3.2      2021-06-23 [?] CRAN (R 4.1.3)
    ##  P  data.table      1.14.2     2021-09-27 [?] CRAN (R 4.1.3)
    ##  P  dataRetrieval * 2.7.10.1   2022-06-03 [?] Github (USGS-R/dataRetrieval@423204a)
    ##  P  DBI             1.1.2      2021-12-20 [?] CRAN (R 4.1.3)
    ##  P  dbplyr          2.1.1      2021-04-06 [?] CRAN (R 4.1.3)
    ##  P  DescTools       0.99.44    2021-11-23 [?] CRAN (R 4.1.3)
    ##  P  digest          0.6.29     2021-12-01 [?] CRAN (R 4.1.3)
    ##  P  dplyr         * 1.0.7      2021-06-18 [?] CRAN (R 4.1.2)
    ##  P  drake         * 7.13.3     2021-09-21 [?] CRAN (R 4.1.3)
    ##  P  e1071           1.7-9      2021-09-16 [?] CRAN (R 4.1.3)
    ##  P  ellipsis        0.3.2      2021-04-29 [?] CRAN (R 4.1.3)
    ##  P  emmeans       * 1.7.2      2022-01-04 [?] CRAN (R 4.1.3)
    ##  P  estimability    1.3        2018-02-11 [?] CRAN (R 4.1.1)
    ##  P  evaluate        0.14       2019-05-28 [?] CRAN (R 4.1.2)
    ##  P  Exact           3.1        2021-11-26 [?] CRAN (R 4.1.2)
    ##  P  expm            0.999-6    2021-01-13 [?] CRAN (R 4.1.3)
    ##  P  extrafont     * 0.17       2014-12-08 [?] CRAN (R 4.1.2)
    ##  P  extrafontdb     1.0        2012-06-11 [?] CRAN (R 4.1.1)
    ##  P  fansi           1.0.2      2022-01-14 [?] CRAN (R 4.1.3)
    ##  P  fastmap         1.1.0      2021-01-25 [?] CRAN (R 4.1.3)
    ##  P  filelock        1.0.2      2018-10-05 [?] CRAN (R 4.1.3)
    ##  P  flextable     * 0.6.10     2021-11-15 [?] CRAN (R 4.1.2)
    ##  P  forcats       * 0.5.1      2021-01-27 [?] CRAN (R 4.1.3)
    ##  P  fs              1.5.2      2021-12-08 [?] CRAN (R 4.1.3)
    ##  P  fst             0.9.4      2020-08-27 [?] CRAN (R 4.1.2)
    ##  P  gdtools         0.2.3      2021-01-06 [?] CRAN (R 4.1.2)
    ##  P  generics        0.1.1      2021-10-25 [?] CRAN (R 4.1.2)
    ##  P  ggbeeswarm      0.6.0      2017-08-07 [?] CRAN (R 4.1.3)
    ##  P  ggplot2       * 3.3.5      2021-06-25 [?] CRAN (R 4.1.3)
    ##  P  ggstance      * 0.3.5      2020-12-17 [?] CRAN (R 4.1.3)
    ##  P  gld             2.6.4      2021-12-16 [?] CRAN (R 4.1.3)
    ##  P  glue            1.6.0      2021-12-17 [?] CRAN (R 4.1.2)
    ##  P  gtable          0.3.0      2019-03-25 [?] CRAN (R 4.1.3)
    ##  P  haven           2.4.3      2021-08-04 [?] CRAN (R 4.1.3)
    ##  P  here          * 1.0.1      2020-12-13 [?] CRAN (R 4.1.3)
    ##  P  hms             1.1.1      2021-09-26 [?] CRAN (R 4.1.3)
    ##  P  hrbrthemes    * 0.8.0      2020-03-06 [?] CRAN (R 4.1.3)
    ##  P  htmltools       0.5.2      2021-08-25 [?] CRAN (R 4.1.3)
    ##  P  httr            1.4.2      2020-07-20 [?] CRAN (R 4.1.3)
    ##  P  igraph          1.2.11     2022-01-04 [?] CRAN (R 4.1.3)
    ##  P  jsonlite        1.7.3      2022-01-17 [?] CRAN (R 4.1.2)
    ##     KernSmooth      2.23-20    2021-05-03 [2] CRAN (R 4.1.3)
    ##  P  knitr         * 1.37       2021-12-16 [?] CRAN (R 4.1.3)
    ##     lattice         0.20-45    2021-09-22 [2] CRAN (R 4.1.3)
    ##  P  leaps           3.1        2020-01-16 [?] CRAN (R 4.1.3)
    ##  P  lifecycle       1.0.1      2021-09-24 [?] CRAN (R 4.1.3)
    ##  P  lmom            2.8        2019-03-12 [?] CRAN (R 4.1.1)
    ##  P  lubridate     * 1.8.0      2021-10-07 [?] CRAN (R 4.1.3)
    ##  P  magrittr        2.0.1      2020-11-17 [?] CRAN (R 4.1.2)
    ##     MASS            7.3-55     2022-01-16 [2] CRAN (R 4.1.3)
    ##     Matrix          1.4-0      2021-12-08 [2] CRAN (R 4.1.3)
    ##  P  memoise         2.0.1      2021-11-26 [?] CRAN (R 4.1.3)
    ##  P  mgcv            1.8-38     2021-10-06 [?] CRAN (R 4.1.2)
    ##  P  modelr          0.1.8      2020-05-19 [?] CRAN (R 4.1.3)
    ##  P  munsell         0.5.0      2018-06-12 [?] CRAN (R 4.1.3)
    ##  P  mvtnorm         1.1-3      2021-10-08 [?] CRAN (R 4.1.1)
    ##  P  nhdplusTools  * 0.4.3      2021-08-18 [?] CRAN (R 4.1.2)
    ##     nlme            3.1-155    2022-01-16 [2] CRAN (R 4.1.3)
    ##  P  officedown    * 0.2.3      2021-11-16 [?] CRAN (R 4.1.2)
    ##  P  officer       * 0.4.1      2021-11-14 [?] CRAN (R 4.1.3)
    ##  P  patchwork     * 1.1.1      2020-12-17 [?] CRAN (R 4.1.3)
    ##  P  pillar          1.6.4      2021-10-18 [?] CRAN (R 4.1.2)
    ##  P  pkgconfig       2.0.3      2019-09-22 [?] CRAN (R 4.1.3)
    ##  P  prettyunits     1.1.1      2020-01-24 [?] CRAN (R 4.1.3)
    ##  P  progress        1.2.2      2019-05-16 [?] CRAN (R 4.1.3)
    ##  P  proxy           0.4-26     2021-06-07 [?] CRAN (R 4.1.3)
    ##  P  purrr         * 0.3.4      2020-04-17 [?] CRAN (R 4.1.3)
    ##  P  R6              2.5.1      2021-08-19 [?] CRAN (R 4.1.3)
    ##  P  ragg          * 1.2.1      2021-12-06 [?] CRAN (R 4.1.2)
    ##  P  randtests       1.0        2014-11-17 [?] CRAN (R 4.1.1)
    ##  P  RANN            2.6.1      2019-01-08 [?] CRAN (R 4.1.3)
    ##  P  Rcpp            1.0.8      2022-01-13 [?] CRAN (R 4.1.3)
    ##  P  readr         * 2.1.1      2021-11-30 [?] CRAN (R 4.1.2)
    ##  P  readxl          1.3.1      2019-03-13 [?] CRAN (R 4.1.3)
    ##     renv            0.15.1     2022-01-13 [1] CRAN (R 4.1.3)
    ##  P  reprex          2.0.1      2021-08-05 [?] CRAN (R 4.1.3)
    ##  P  rlang           0.4.12     2021-10-18 [?] CRAN (R 4.1.2)
    ##  P  rmarkdown       2.11       2021-09-14 [?] CRAN (R 4.1.2)
    ##  P  rootSolve       1.8.2.3    2021-09-29 [?] CRAN (R 4.1.1)
    ##  P  rprojroot       2.0.2      2020-11-15 [?] CRAN (R 4.1.3)
    ##  P  rstudioapi      0.13       2020-11-12 [?] CRAN (R 4.1.3)
    ##  P  Rttf2pt1        1.3.9      2021-07-22 [?] CRAN (R 4.1.1)
    ##  P  rvest         * 1.0.2      2021-10-16 [?] CRAN (R 4.1.3)
    ##  P  rvg             0.2.5      2020-06-30 [?] CRAN (R 4.1.3)
    ##  P  s2              1.0.7      2021-09-28 [?] CRAN (R 4.1.3)
    ##  P  scales          1.1.1      2020-05-11 [?] CRAN (R 4.1.3)
    ##  P  selectr         0.4-2      2019-11-20 [?] CRAN (R 4.1.3)
    ##  P  sessioninfo     1.2.2      2021-12-06 [?] CRAN (R 4.1.3)
    ##  P  sf            * 1.0-5      2021-12-17 [?] CRAN (R 4.1.2)
    ##  P  smwrBase      * 1.1.5      2022-06-03 [?] repository (https://github.com/USGS-R/smwrBase@2478663)
    ##  P  smwrGraphs    * 1.1.4.9000 2022-06-03 [?] repository (https://github.com/USGS-R/smwrGraphs@f3debe7)
    ##  P  smwrStats     * 0.7.6      2022-06-03 [?] repository (https://github.com/USGS-R/smwrStats@2e02eb7)
    ##  P  sp              1.4-6      2021-11-14 [?] CRAN (R 4.1.3)
    ##  P  storr           1.2.5      2020-12-01 [?] CRAN (R 4.1.3)
    ##  P  stringi         1.7.6      2021-11-29 [?] CRAN (R 4.1.2)
    ##  P  stringr       * 1.4.0      2019-02-10 [?] CRAN (R 4.1.3)
    ##  P  systemfonts     1.0.3      2021-10-13 [?] CRAN (R 4.1.2)
    ##  P  texreg          1.37.5     2020-06-18 [?] CRAN (R 4.1.2)
    ##  P  textshaping     0.3.6      2021-10-13 [?] CRAN (R 4.1.3)
    ##  P  tibble        * 3.1.6      2021-11-07 [?] CRAN (R 4.1.3)
    ##  P  tidyr         * 1.1.4      2021-09-27 [?] CRAN (R 4.1.2)
    ##  P  tidyselect      1.1.1      2021-04-30 [?] CRAN (R 4.1.2)
    ##  P  tidyverse     * 1.3.1      2021-04-15 [?] CRAN (R 4.1.3)
    ##  P  txtq            0.2.4      2021-03-27 [?] CRAN (R 4.1.3)
    ##  P  tzdb            0.2.0      2021-10-27 [?] CRAN (R 4.1.3)
    ##  P  units           0.7-2      2021-06-08 [?] CRAN (R 4.1.2)
    ##  P  utf8            1.2.2      2021-07-24 [?] CRAN (R 4.1.3)
    ##  P  uuid            1.0-3      2021-11-01 [?] CRAN (R 4.1.2)
    ##  P  vctrs           0.3.8      2021-04-29 [?] CRAN (R 4.1.3)
    ##  P  vipor           0.4.5      2017-03-22 [?] CRAN (R 4.1.3)
    ##  P  vroom           1.5.7      2021-11-30 [?] CRAN (R 4.1.3)
    ##  P  withr           2.4.3      2021-11-30 [?] CRAN (R 4.1.2)
    ##  P  wk              0.6.0      2022-01-03 [?] CRAN (R 4.1.3)
    ##  P  xfun            0.29       2021-12-14 [?] CRAN (R 4.1.2)
    ##  P  xml2          * 1.3.3      2021-11-30 [?] CRAN (R 4.1.3)
    ##  P  xtable          1.8-4      2019-04-21 [?] CRAN (R 4.1.3)
    ##  P  yaml            2.2.1      2020-02-01 [?] CRAN (R 4.1.1)
    ##  P  zip             2.2.0      2021-05-31 [?] CRAN (R 4.1.3)
    ## 
    ##  [1] C:/Projects/schramm-gitter-gregory-2020-tmdl-data/renv/library/R-4.1/x86_64-w64-mingw32
    ##  [2] C:/Program Files/R/R-4.1.3/library
    ## 
    ##  P -- Loaded and on-disk path mismatch.
    ##  D -- DLL MD5 mismatch, broken installation.
    ## 
    ## ---------------------------------------------------------------------------------------------------------------
