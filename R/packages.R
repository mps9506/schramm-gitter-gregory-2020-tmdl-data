## Load Packages

library(drake)
library(tidyverse)
library(rvest)
library(xml2)
library(dataRetrieval)
library(nhdplusTools)
library(knitr)
library(sf)
library(archive)
library(smwrBase)
library(smwrStats)

## logistice regression and estimated means
library(emmeans)

## plotting functions
library(hrbrthemes)
library(extrafont)
library(here)
library(ragg)
library(ggstance) ## used for geom_pointrangeh
library(patchwork)
suppressWarnings(suppressMessages(extrafont::font_import(here::here("data/fonts"), 
                                                         prompt = FALSE)))
extrafont::loadfonts(device = "win", quiet = TRUE)


## manuscripts and tables
library(bookdown)
library(officer)
library(officedown)
library(flextable)
