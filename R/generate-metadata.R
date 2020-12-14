## this is run seperately from the drake workflow.
## dataspcie must be installed from github ropenscilabs:
## https://docs.ropensci.org/dataspice/index.html

library(dataspice)

############################################
#### write data and metadata for export ####
############################################

write_csv(readd(cleaned_full_data),
          path = "data/cleaned_data.csv")

write_csv(readd(unadjusted_mk_results),
          path = "data/unadjusted_mk_results.csv")

write_csv(readd(flow_adjusted_mk_results),
          path = "data/flow_adjusted_mk_results.csv")

create_spice()
edit_biblio()
prep_access()
prep_attributes()
edit_attributes()
edit_creators()
edit_access()
write_spice()
build_site()
