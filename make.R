###########################
#### Load source files ####
###########################

source("R/packages.R")  # loads packages
source("R/download_data.R")
source("R/mann-kendall-tests.R")
source("R/logistic_regression.R")
source("R/figures.R")
source("R/tables.R")
source("R/plan.R")      # creates the drake plan

###########################
#### set local options ####
###########################

# specify path to your nhdplus database
nhd_data <- "E:\\TWRI\\Data-Resources\\NHDPlusV21_NationalData_Seamless_Geodatabase_Lower48_07\\NHDPlusNationalData\\NHDPlusV21_National_Seamless_Flattened_Lower48.gdb"

##########################################################
#### You shouldn't need to modify anything after this ####
##########################################################

nhdplus_path(nhd_data)

progress()

make(
  plan
)

#config <- drake_config(plan)
#drake_ggraph(config)