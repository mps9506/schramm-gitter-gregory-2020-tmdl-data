Total Maximum Daily Loads and Escherichia coli trends in Texas
freshwater streams
================

[![License: CC BY
4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![DOI](https://zenodo.org/badge/307874510.svg)](https://zenodo.org/badge/latestdoi/307874510)

    ## [1] "Time of last build: 2022-02-22 08:30:57"

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

    ## - Session info ------------------------------------------------------------------------------------------------------------------------
    ##  setting  value
    ##  version  R version 4.1.2 (2021-11-01)
    ##  os       Windows 10 x64 (build 19044)
    ##  system   x86_64, mingw32
    ##  ui       RStudio
    ##  language (EN)
    ##  collate  English_United States.1252
    ##  ctype    English_United States.1252
    ##  tz       America/Chicago
    ##  date     2022-02-22
    ##  rstudio  2021.09.0+351 Ghost Orchid (desktop)
    ##  pandoc   2.14.0.3 @ C:/Program Files/RStudio/bin/pandoc/ (via rmarkdown)
    ## 
    ## - Packages ----------------------------------------------------------------------------------------------------------------------------
    ##  !  package       * version    date (UTC) lib source
    ##  P  abind           1.4-5      2016-07-21 [2] CRAN (R 4.1.1)
    ##  P  akima           0.6-2.3    2021-11-02 [2] CRAN (R 4.1.2)
    ##  PD archive       * 1.1.3      2021-11-30 [2] CRAN (R 4.1.2)
    ##  P  assertthat      0.2.1      2019-03-21 [2] CRAN (R 4.1.2)
    ##  P  backports       1.4.1      2021-12-13 [2] CRAN (R 4.1.2)
    ##  P  base64enc       0.1-3      2015-07-28 [2] CRAN (R 4.1.1)
    ##  P  base64url       1.4        2018-05-14 [2] CRAN (R 4.1.2)
    ##  P  beeswarm        0.4.0      2021-06-01 [?] CRAN (R 4.1.1)
    ##  P  bookdown      * 0.24       2021-09-02 [2] CRAN (R 4.1.2)
    ##  P  boot            1.3-28     2021-05-03 [?] CRAN (R 4.1.2)
    ##  P  broom           0.7.11     2022-01-03 [2] CRAN (R 4.1.2)
    ##  P  cachem          1.0.6      2021-08-19 [2] CRAN (R 4.1.2)
    ##     Cairo         * 1.5-14     2021-12-21 [2] CRAN (R 4.1.2)
    ##  P  car             3.0-12     2021-11-06 [2] CRAN (R 4.1.2)
    ##  P  carData         3.0-5      2022-01-06 [2] CRAN (R 4.1.2)
    ##  P  cellranger      1.1.0      2016-07-27 [2] CRAN (R 4.1.2)
    ##  P  class           7.3-20     2022-01-13 [2] CRAN (R 4.1.2)
    ##  P  classInt        0.4-3      2020-04-07 [2] CRAN (R 4.1.2)
    ##  P  cli             3.1.1      2022-01-20 [?] CRAN (R 4.1.2)
    ##     coda            0.19-4     2020-09-30 [2] CRAN (R 4.1.2)
    ##  P  codetools       0.2-18     2020-11-04 [2] CRAN (R 4.1.2)
    ##  P  colorspace      2.0-2      2021-06-24 [2] CRAN (R 4.1.2)
    ##  P  crayon          1.4.2      2021-10-29 [2] CRAN (R 4.1.2)
    ##  P  data.table      1.14.2     2021-09-27 [2] CRAN (R 4.1.2)
    ##  P  dataRetrieval * 2.7.10.1   2022-02-17 [2] Github (USGS-R/dataRetrieval@423204a)
    ##  P  DBI             1.1.2      2021-12-20 [2] CRAN (R 4.1.2)
    ##  P  dbplyr          2.1.1      2021-04-06 [2] CRAN (R 4.1.2)
    ##  P  DescTools       0.99.44    2021-11-23 [?] CRAN (R 4.1.2)
    ##  P  digest          0.6.29     2021-12-01 [2] CRAN (R 4.1.2)
    ##  P  dplyr         * 1.0.7      2021-06-18 [2] CRAN (R 4.1.2)
    ##  P  drake         * 7.13.3     2021-09-21 [2] CRAN (R 4.1.2)
    ##  P  e1071           1.7-9      2021-09-16 [2] CRAN (R 4.1.2)
    ##  P  ellipsis        0.3.2      2021-04-29 [2] CRAN (R 4.1.2)
    ##  P  emmeans       * 1.7.2      2022-01-04 [2] CRAN (R 4.1.2)
    ##  P  estimability    1.3        2018-02-11 [2] CRAN (R 4.1.1)
    ##  P  evaluate        0.14       2019-05-28 [2] CRAN (R 4.1.2)
    ##  P  Exact           3.1        2021-11-26 [?] CRAN (R 4.1.2)
    ##  P  expm            0.999-6    2021-01-13 [?] CRAN (R 4.1.2)
    ##  P  extrafont     * 0.17       2014-12-08 [2] CRAN (R 4.1.1)
    ##  P  extrafontdb     1.0        2012-06-11 [2] CRAN (R 4.1.1)
    ##  P  fansi           1.0.2      2022-01-14 [2] CRAN (R 4.1.2)
    ##  P  farver          2.1.0      2021-02-28 [?] CRAN (R 4.1.2)
    ##  P  fastmap         1.1.0      2021-01-25 [2] CRAN (R 4.1.2)
    ##  P  filelock        1.0.2      2018-10-05 [2] CRAN (R 4.1.2)
    ##  P  flextable     * 0.6.10     2021-11-15 [2] CRAN (R 4.1.2)
    ##  P  forcats       * 0.5.1      2021-01-27 [2] CRAN (R 4.1.2)
    ##  P  fs              1.5.2      2021-12-08 [2] CRAN (R 4.1.2)
    ##  P  fst             0.9.4      2020-08-27 [2] CRAN (R 4.1.2)
    ##  P  gdtools         0.2.3      2021-01-06 [2] CRAN (R 4.1.2)
    ##  P  generics        0.1.1      2021-10-25 [2] CRAN (R 4.1.2)
    ##  P  ggbeeswarm      0.6.0      2017-08-07 [?] CRAN (R 4.1.2)
    ##  P  ggplot2       * 3.3.5      2021-06-25 [2] CRAN (R 4.1.2)
    ##  P  ggstance      * 0.3.5      2020-12-17 [2] CRAN (R 4.1.2)
    ##  P  gld             2.6.4      2021-12-16 [?] CRAN (R 4.1.2)
    ##  P  glue            1.6.0      2021-12-17 [2] CRAN (R 4.1.2)
    ##  P  gtable          0.3.0      2019-03-25 [2] CRAN (R 4.1.2)
    ##  P  haven           2.4.3      2021-08-04 [2] CRAN (R 4.1.2)
    ##  P  here          * 1.0.1      2020-12-13 [2] CRAN (R 4.1.2)
    ##  P  hms             1.1.1      2021-09-26 [2] CRAN (R 4.1.2)
    ##  P  hrbrthemes    * 0.8.0      2020-03-06 [2] CRAN (R 4.1.2)
    ##  P  htmltools       0.5.2      2021-08-25 [2] CRAN (R 4.1.2)
    ##  P  httr            1.4.2      2020-07-20 [2] CRAN (R 4.1.2)
    ##  P  igraph          1.2.11     2022-01-04 [2] CRAN (R 4.1.2)
    ##  P  jsonlite        1.7.3      2022-01-17 [2] CRAN (R 4.1.2)
    ##  P  KernSmooth      2.23-20    2021-05-03 [2] CRAN (R 4.1.2)
    ##  P  knitr         * 1.37       2021-12-16 [2] CRAN (R 4.1.2)
    ##  P  lattice         0.20-45    2021-09-22 [2] CRAN (R 4.1.2)
    ##  P  leaps           3.1        2020-01-16 [2] CRAN (R 4.1.2)
    ##  P  lifecycle       1.0.1      2021-09-24 [2] CRAN (R 4.1.2)
    ##  P  lmom            2.8        2019-03-12 [?] CRAN (R 4.1.1)
    ##  P  lubridate     * 1.8.0      2021-10-07 [2] CRAN (R 4.1.2)
    ##  P  magrittr        2.0.1      2020-11-17 [2] CRAN (R 4.1.2)
    ##  P  MASS            7.3-55     2022-01-13 [2] CRAN (R 4.1.2)
    ##  P  Matrix          1.4-0      2021-12-08 [2] CRAN (R 4.1.2)
    ##  P  memoise         2.0.1      2021-11-26 [2] CRAN (R 4.1.2)
    ##  P  mgcv            1.8-38     2021-10-06 [?] CRAN (R 4.1.2)
    ##  P  modelr          0.1.8      2020-05-19 [2] CRAN (R 4.1.2)
    ##     multcomp        1.4-18     2022-01-04 [2] CRAN (R 4.1.2)
    ##  P  munsell         0.5.0      2018-06-12 [2] CRAN (R 4.1.2)
    ##  P  mvtnorm         1.1-3      2021-10-08 [2] CRAN (R 4.1.1)
    ##  P  nhdplusTools  * 0.4.3      2021-08-18 [2] CRAN (R 4.1.2)
    ##  P  nlme            3.1-155    2022-01-13 [?] CRAN (R 4.1.2)
    ##  P  officedown    * 0.2.3      2021-11-16 [2] CRAN (R 4.1.2)
    ##  P  officer       * 0.4.1      2021-11-14 [2] CRAN (R 4.1.2)
    ##  P  patchwork     * 1.1.1      2020-12-17 [2] CRAN (R 4.1.2)
    ##  P  pillar          1.6.4      2021-10-18 [2] CRAN (R 4.1.2)
    ##  P  pkgconfig       2.0.3      2019-09-22 [2] CRAN (R 4.1.2)
    ##  P  png             0.1-7      2013-12-03 [?] CRAN (R 4.1.1)
    ##  P  prettyunits     1.1.1      2020-01-24 [2] CRAN (R 4.1.2)
    ##  P  progress        1.2.2      2019-05-16 [2] CRAN (R 4.1.2)
    ##  P  proxy           0.4-26     2021-06-07 [2] CRAN (R 4.1.2)
    ##  P  purrr         * 0.3.4      2020-04-17 [2] CRAN (R 4.1.2)
    ##  P  R6              2.5.1      2021-08-19 [2] CRAN (R 4.1.2)
    ##  P  ragg          * 1.2.1      2021-12-06 [2] CRAN (R 4.1.2)
    ##  P  randtests       1.0        2014-11-17 [2] CRAN (R 4.1.1)
    ##  P  RANN            2.6.1      2019-01-08 [2] CRAN (R 4.1.2)
    ##  P  Rcpp            1.0.8      2022-01-13 [2] CRAN (R 4.1.2)
    ##  P  readr         * 2.1.1      2021-11-30 [2] CRAN (R 4.1.2)
    ##  P  readxl          1.3.1      2019-03-13 [2] CRAN (R 4.1.2)
    ##     renv            0.15.1     2022-01-13 [1] CRAN (R 4.1.2)
    ##  P  reprex          2.0.1      2021-08-05 [2] CRAN (R 4.1.2)
    ##  P  rlang           0.4.12     2021-10-18 [2] CRAN (R 4.1.2)
    ##  P  rmarkdown       2.11       2021-09-14 [2] CRAN (R 4.1.2)
    ##  P  rootSolve       1.8.2.3    2021-09-29 [?] CRAN (R 4.1.1)
    ##  P  rprojroot       2.0.2      2020-11-15 [2] CRAN (R 4.1.2)
    ##  P  rstudioapi      0.13       2020-11-12 [2] CRAN (R 4.1.2)
    ##  P  Rttf2pt1        1.3.9      2021-07-22 [2] CRAN (R 4.1.1)
    ##  P  rvest         * 1.0.2      2021-10-16 [2] CRAN (R 4.1.2)
    ##  P  rvg             0.2.5      2020-06-30 [2] CRAN (R 4.1.2)
    ##     sandwich        3.0-1      2021-05-18 [2] CRAN (R 4.1.2)
    ##  P  scales          1.1.1      2020-05-11 [2] CRAN (R 4.1.2)
    ##  P  sessioninfo     1.2.2      2021-12-06 [?] CRAN (R 4.1.2)
    ##  P  sf            * 1.0-5      2021-12-17 [2] CRAN (R 4.1.2)
    ##  P  smwrBase      * 1.1.5      2022-02-13 [2] https://ldecicco-usgs.r-universe.dev (R 4.1.2)
    ##  P  smwrGraphs    * 1.1.4.9000 2022-02-13 [2] https://ldecicco-usgs.r-universe.dev (R 4.1.2)
    ##  P  smwrStats     * 0.7.6      2022-02-13 [2] https://ldecicco-usgs.r-universe.dev (R 4.1.2)
    ##  P  sp              1.4-6      2021-11-14 [2] CRAN (R 4.1.2)
    ##  P  storr           1.2.5      2020-12-01 [2] CRAN (R 4.1.2)
    ##  P  stringi         1.7.6      2021-11-29 [2] CRAN (R 4.1.2)
    ##  P  stringr       * 1.4.0      2019-02-10 [2] CRAN (R 4.1.2)
    ##  P  survival        3.2-13     2021-08-24 [2] CRAN (R 4.1.2)
    ##  P  systemfonts     1.0.3      2021-10-13 [2] CRAN (R 4.1.2)
    ##  P  texreg        * 1.37.5     2020-06-18 [2] CRAN (R 4.1.2)
    ##  P  textshaping     0.3.6      2021-10-13 [2] CRAN (R 4.1.2)
    ##     TH.data         1.1-0      2021-09-27 [2] CRAN (R 4.1.2)
    ##  P  tibble        * 3.1.6      2021-11-07 [2] CRAN (R 4.1.2)
    ##  P  tidyr         * 1.1.4      2021-09-27 [2] CRAN (R 4.1.2)
    ##  P  tidyselect      1.1.1      2021-04-30 [2] CRAN (R 4.1.2)
    ##  P  tidyverse     * 1.3.1      2021-04-15 [2] CRAN (R 4.1.2)
    ##  P  txtq            0.2.4      2021-03-27 [2] CRAN (R 4.1.2)
    ##  P  tzdb            0.2.0      2021-10-27 [2] CRAN (R 4.1.2)
    ##  P  units           0.7-2      2021-06-08 [2] CRAN (R 4.1.2)
    ##  P  utf8            1.2.2      2021-07-24 [2] CRAN (R 4.1.2)
    ##  P  uuid            1.0-3      2021-11-01 [2] CRAN (R 4.1.2)
    ##  P  vctrs           0.3.8      2021-04-29 [2] CRAN (R 4.1.2)
    ##  P  vipor           0.4.5      2017-03-22 [?] CRAN (R 4.1.2)
    ##  P  viridisLite     0.4.0      2021-04-13 [?] CRAN (R 4.1.2)
    ##  P  withr           2.4.3      2021-11-30 [2] CRAN (R 4.1.2)
    ##  P  xfun            0.29       2021-12-14 [2] CRAN (R 4.1.2)
    ##  P  xml2          * 1.3.3      2021-11-30 [2] CRAN (R 4.1.2)
    ##  P  xtable          1.8-4      2019-04-21 [2] CRAN (R 4.1.2)
    ##  P  yaml            2.2.1      2020-02-01 [2] CRAN (R 4.1.1)
    ##  P  zip             2.2.0      2021-05-31 [2] CRAN (R 4.1.2)
    ##     zoo             1.8-9      2021-03-09 [2] CRAN (R 4.1.2)
    ## 
    ##  [1] C:/Data-Analysis-Projects/schramm-gitter-gregory-2020-tmdl-data/renv/library/R-4.1/x86_64-w64-mingw32
    ##  [2] C:/Users/michael.schramm/Documents/R/R-4.1.2/library
    ## 
    ##  P -- Loaded and on-disk path mismatch.
    ##  D -- DLL MD5 mismatch, broken installation.
    ## 
    ## ---------------------------------------------------------------------------------------------------------------------------------------
