#################################
#### dataRetrieval functions ####
#################################

## find STORET sites in Texas

find_sites <- function(x){
  ## x = au spatial data frame
  au_df <- x %>%
    st_transform(4326)
  
  ## download ATTAINS TMDL info that lists 
  ## all the AUs with bacteria TMDLs
  cat(crayon::blue("downloading TMDL data from TCEQ\n"))
  ir <- read_ir_info()
  
  
  cat(crayon::blue("downloading site info from WQP\n"))
  ## download site info for all
  ## sites with E. coli data
  df <- whatWQPsites(type = "Stream",
               organization = "TCEQMAIN",
               characteristicName = "Escherichia coli",
               startDateLo = "01-01-2012",
               startDateHi = "12-31-2019") %>%
    st_as_sf(coords = c("LongitudeMeasure", "LatitudeMeasure")) %>%
    st_set_crs(4326)
  
  cat(crayon::blue("spatially join AUs and WQP sites\n"))
  ## spatial join au to station
  df <- df %>%
    st_join(au_df %>% select(AU_ID, IMP_CONTAC),
            join = st_nearest_feature) %>%
    mutate(segment = str_sub(AU_ID, end = -4)) %>%
    ## classify as having TMDL if it is in the ir dataframe
    mutate(tmdl = case_when(
      segment %in% ir$`Segment Number` ~ 1,
      !(segment %in% ir$`Segment Number`) ~ 0
      )) %>%
    dplyr::filter(MonitoringLocationTypeName == "River/Stream")

  
  return(df)
}


## download and clean ecoli data from STORET

download_ecoli <- function(x) {
  
  df <- readWQPqw(siteNumbers = x$MonitoringLocationIdentifier,
                  parameterCd = "Escherichia coli",
                  startDate = "2012-01-01",
                  endDate = "2019-12-31")
  
  df
}
  
clean_ecoli_data <- function(x) {
  x %>%
    dplyr::filter(ResultMeasure.MeasureUnitCode != "hours") %>%
    dplyr::select(OrganizationIdentifier, OrganizationFormalName, ActivityIdentifier,
                  ActivityStartDate, MonitoringLocationIdentifier, CharacteristicName,
                  ResultMeasureValue, `ResultMeasure.MeasureUnitCode`, ResultCommentText,
                  ProviderName) %>%
    mutate(ResultMeasureValue = case_when(
      ResultMeasureValue == 0 ~ 1,
      ResultMeasureValue != 0 ~ ResultMeasureValue
    ))
}


reduce_ecoli_data <- function(x) {
  ## minimum of 3 samples per year median
  x %>%
    mutate(year = as.factor(lubridate::year(ActivityStartDate))) %>%
    group_by(MonitoringLocationIdentifier, year) %>%
    summarise(n = n()) %>%
    tidyr::complete(MonitoringLocationIdentifier, year, fill = list(n = 0)) %>%
    ungroup() %>%
    group_by(MonitoringLocationIdentifier) %>%
    summarise(median = median(n, na.rm = TRUE)) %>%
    filter(median >= 3)  -> x_n
  
  x %>%
    filter(MonitoringLocationIdentifier %in% x_n$MonitoringLocationIdentifier) -> x
  
  
  return(x)
}

get_ecoli <- function(x) {
  df <- download_ecoli(x)
  df <- clean_ecoli_data(df)
  df <- reduce_ecoli_data(df)
  return(df)
}

###############################
#### TCEQ Assessment Units ####
###############################
download_au <- function(url,
                         rel_path) {
  cat(crayon::blue("downloading Assessment Units\n"))
  # download the files
  tmpfile <- tempfile()
  ras <- download.file(url = url,
                       destfile = tmpfile,
                       mode = "wb")
  
  # unzip
  tmpdir <- tempdir()
  archive::archive_extract(tmpfile, tmpdir)
  
  filepath <- paste0(tmpdir, rel_path)
  
  # reads
  shp <- sf::st_read(filepath)
  
  # deletes temp
  unlink(tmpdir)
  unlink(tmpfile)
  
  return(shp)
}



###################
#### TMDL Data ####
###################

## download TMDL info from TCEQ
read_ir_info <- function() {
  webpage <- read_html("https://www.tceq.texas.gov/waterquality/tmdl/nav/tmdlsegments")
  tbls <- html_nodes(webpage, "table")
  
  table1 <- webpage %>%
    html_nodes("table") %>%
    .[1:2] %>%
    html_table(fill = TRUE) %>%
    purrr::map_dfr(~ tibble::as_tibble(.)) %>%
    dplyr::filter(stringr::str_detect(Parameters, "Bacteria"))
  return(table1)
}


######################
#### NHDPlusTools ####
######################

## Find the nearest active upstream NWIS stream gage from each TCEQ SWQM station
setup_nhd_tools <- function() {

  ## stage national data shoul put the nhd geodatabase into R binary files with
  ## list of paths stored in the nhdpluttools env as "national_data"
  nhdplus <- stage_national_data(include = c("flowline", "catchment"),
                                 output_path = "data/nhd_staged")
  return(nhdplus)

}


setup_nhd_flowlines <- function(nhdpluspath) {
  ## get the nhd flowlines as sf
  flowlines <- readRDS(nhdpluspath$flowline)
  flowlines <- flowlines %>%
    filter(RPUID %in% c("12a", "12b", "12c", "12d", "11a", "11b", "13b", "13c", "13d")) %>%
    st_transform(4326)
  return(flowlines)
}

## Query NLDI to find nearest NWIS streamflow gage to each WQP station
query_nldi <- function(x, y) {
  ## x = site_info
  ## y = swqm_sites

  y <- y$MonitoringLocationIdentifier

  df <- x %>%
    filter(MonitoringLocationIdentifier %in% y) %>%
    mutate(wqpsite = purrr::map(as.list(.$MonitoringLocationIdentifier),
                                ~wqp_list(featureid = .x)))

  cat(crayon::blue("Finding upstream gages\n This takes a while"))

  df <- df %>%
    mutate(upstreamNWIS = purrr::map(wqpsite,
                                     ~{Sys.sleep(6) ## long pause so not to piss off nldi server
                                       print(.$featureID)
                                       navigate_nldi(.,
                                                     mode = "upstreamMain",
                                                     data_source = "nwissite",
                                                     distance_km = 2)$UM_nwissite ## returns upstream NWIS gages within 1 mile
                                     }
    ))

  cat(crayon::blue("finding downstream gages\n This takes a while"))
  df <- df %>%
    mutate(downstreamNWIS = purrr::map(wqpsite,
                                       ~{Sys.sleep(6) ## long pause so not to piss off nldi server
                                         print(.$featureID)
                                         navigate_nldi(.,
                                                       mode = "downstreamMain",
                                                       data_source = "nwissite",
                                                       distance_km = 2)$DM_nwissite ## returns downstream NWIS gages
                                       }
    ))

  return(df)
}


wqp_list <- function(featureid) {
  x <-  list(featureSource = "wqp",
             featureID = featureid)
  return(x)
}


setup_wqp_sites <- function(df, flowlines) {
  ## df = nldi_data
  ## flowlines = flowline


  df <- df %>%
    mutate(
      n_downstream = purrr::map_dbl(downstreamNWIS, ~{
        if (is.null(.x)) {return(0)}
        else {nrow(.x)}
      }), ## returns number of downstream sites
      n_upstream = purrr::map_dbl(upstreamNWIS, ~{
        if (is.null(.x)) {return(0)}
        else {return(nrow(.x))}
      })) %>% ## returns number of upstream sites
    filter(n_upstream > 0 | n_downstream > 0) ## remove stations with zero associated NWIS gages

  ## convert wqp data points to sf
  ## apply function to each row
  n <- length(df$downstreamNWIS)
  cat(crayon::blue("matching comids\n"))
  pb <- dplyr::progress_estimated(n=n)
  df <- df %>%
    st_as_sf(coords = c("LongitudeMeasure", "LatitudeMeasure")) %>%
    st_set_crs(4326) %>%
    mutate(NWIS_comids = purrr::map2(upstreamNWIS, downstreamNWIS,
                                     ~c(.x$comid, .y$comid))) %>% ## returns comids for associated nearby NWIS stations
    mutate(nearest_flowlines = purrr::map(NWIS_comids,
                                          ~{
                                            pb$tick()$print()
                                            get_NWIS_comids(., flowlines)}
    )) ## returns flowlines for associated nearby NWIS stations

  ## filter records that don't return nearest flowlines
  df <- df %>%
    mutate(n_nearest_flowlines := purrr::map_dbl(row_number(),
                                                 ~{as.numeric(length(df$nearest_flowlines[[.x]]$COMID))}))

  df <- df %>%
    filter(n_nearest_flowlines > 0)

  ## index NWIS sites
  n <- length(df$nearest_flowlines)
  message("indexing NWIS locations")
  pb <- dplyr::progress_estimated(n=n)
  df <- df %>%
    mutate(index_site := purrr::map(row_number(),
                                    ~{
                                      pb$tick()$print()
                                      get_flowline_index(df$nearest_flowlines[[.x]],
                                                         df[.x,],
                                                         search_radius = 10)})) ## returns NWIS index location info

  ## bind_rows the upstream and downstream stations, then choose station based on comid in indexsite
  df <- df %>%
    mutate(NWIS = purrr::pmap(list(upstreamNWIS, downstreamNWIS), ## if upstream NWIS is null the bind_rows returns an empty geometry.
                              ~{if (length(..1) == 0) {return(..2)}
                                if (length(..2) == 0) {return(..1)}
                                else return(bind_rows(..1, ..2))
                              })) %>%
    mutate(NWIS_station = purrr::pmap(list(index_site, NWIS),
                                      ~{filter(..2, as.integer(comid) %in% c(..1$COMID))}))

  ## if there are two NWIS gages, they are identical and colocated with the WQP site
  df <- df %>%
    mutate(NWIS_station = purrr::map(NWIS_station,
                                     ~slice(.x, 1))) %>%
    as_tibble() %>%
    dplyr::select(MonitoringLocationIdentifier, NWIS_station) %>%
    unnest(NWIS_station)

  return(df)

}

get_NWIS_comids <- function(x, nhdflowlines) {
  comid <- x
  #print(comid)
  nhdflowlines <- nhdflowlines %>%
    filter(COMID %in% comid)

  return(nhdflowlines)

}


## download streamflows

download_streamflows <- function(x) {

  x <- x %>%
    dplyr::select(identifier) %>%
    distinct(identifier) %>%
    mutate(identifier = stringr::str_replace(identifier, "USGS-", "\\")) %>%
    mutate(identifier = stringr::str_replace(identifier, "USIBW-", "\\")) %>%
    mutate(identifier = stringr::str_replace(identifier, "TX071-", "\\")) %>%
    mutate(identifier = stringr::str_replace(identifier, "USCE-", "\\"))

  df <- readNWISdv(x$identifier, parameterCd = "00060",
                   startDate = "2012-01-01",
                   endDate = "2018-12-31")
  df <- renameNWISColumns(df)
  
  ## remove sites with fewer than 1460 records
  df <- reduce_NWIS_sites(df)
  return(df)
}


# ##################################
# ##### Data Cleaning Functions ####
# ##################################

reduce_NWIS_sites <- function(x) {
  keep <- x %>%
    group_by(site_no) %>%
    summarize(n = n()) %>%
    filter(n > 1460)

  x <- x %>%
    filter(site_no %in% keep$site_no)

  return(x)
}

#######################
#### Data Cleaning ####
#######################

## reduce TCEQ SWQM sites based on available E. coli data
clean_SWQM_with_ecoli <- function(x, y) {
  ## x = site_info
  ## y = ecoli_data
  
  x %>%
    filter(MonitoringLocationIdentifier %in% unique(y$MonitoringLocationIdentifier))
}

## join all the data
join_final_data <- function(w, x, y, z) {
  # w = ecoli_data
  # x = swqm_sites
  # y = nwis_wqp_data
  # z = streamflow_record
  w %>%
    dplyr::select(ActivityStartDate, MonitoringLocationIdentifier, CharacteristicName, ResultMeasureValue) %>%
    left_join(x %>% dplyr::select(MonitoringLocationIdentifier,
                                                  AU = AU_ID,
                                                  Impaired = IMP_CONTAC,
                                                  Segment = segment,
                                                  TMDL = tmdl), 
              by = c("MonitoringLocationIdentifier" = "MonitoringLocationIdentifier")) %>%
    left_join(y %>% select(MonitoringLocationIdentifier, 
                                              USGSSite_No = identifier),
              by = c("MonitoringLocationIdentifier" = "MonitoringLocationIdentifier")) %>%
    left_join(z %>% 
                mutate(USGSSite_No = paste0(agency_cd, "-", site_no)) %>%
                select(USGSSite_No, Date, Flow),
              by = c("USGSSite_No" = "USGSSite_No",
                     "ActivityStartDate" = "Date"))
}