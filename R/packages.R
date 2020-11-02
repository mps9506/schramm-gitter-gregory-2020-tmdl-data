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

## plotting functions
library(hrbrthemes)
library(extrafont)
library(here)
library(ragg)
suppressWarnings(suppressMessages(extrafont::font_import(here::here("data/fonts"), 
                                                         prompt = FALSE)))
extrafont::loadfonts(device = "win", quiet = TRUE)
