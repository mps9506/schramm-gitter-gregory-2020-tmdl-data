
################
#### Tables ####
################

## note these are texreg objects formatted for ms word



## Logistic Regression results

tabulate_lr <- function(x) {
  mr <- texreg::matrixreg(list(x[[1]], x[[2]]),
                          custom.coef.names = c("Intercept", "TMDL"),
                          custom.header = list("Unadjusted" = 1, "Flow-Adjusted" = 2),
                          custom.model.names = c("GLM", "GLM"),
                          single.row = TRUE, 
                          include.bic = FALSE,
                          include.deviance = TRUE,
                          caption = "(\\#tab:modsum1) GLM model summaries.", 
                          output.type = "ascii", include.attributes = FALSE)
  ft <- flextable::flextable(as.data.frame(mr))
  ft <- width(ft,
              width = 1)
  
  ft <- hline(ft, i = 1, j = c("V1","V2","V3"),
              border = officer::fp_border(width = 1))
  ft <- hline(ft, i = 3, j = c("V1","V2","V3"),
              border = officer::fp_border(width = 0.5))
  ft <- set_header_labels(ft,
                          values = c(V1 = "",
                                     V2 = "Unadjusted",
                                     V3 = "Flow-Adjusted"))
  ft <- hline(ft, i = 1, j = c("V1"),
              border = officer::fp_border(width = 0),
              part = "header")
  ft <- hline(ft, i = 1, j = c("V2","V3"),
              border = officer::fp_border(width = 0.5),
              part = "header")
  ft <- merge_h(ft, part = "header")
  ft <- fontsize(ft, size = 9, part = "all")
  ft <- align(ft, j = c("V2","V3"),
              align = "center", part = "all")
  ft <- autofit(ft)
  ft <- add_footer(ft, values = c(V1 = "*** p < 0.001; ** p < 0.01;  * p < 0.05"))
  ft <- merge_at(ft, j = 1:3, part = "footer")
  # ft
  ft
}


tabulate_lr(readd(lr_results))
