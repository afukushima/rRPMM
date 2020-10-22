## -----------------------------------------------------------------------------
# devtools::install_github("afukushima/rRPMM", build_vignettes = TRUE)

## ----setup, message = FALSE, warning = FALSE----------------------------------
library(SPARQL)
library(rRPMM)
library(plotly)
library(dplyr)


res <- RPMM_numOfprojects_species()
resMat <- data.frame(gsub("@en", "", res$speciesLabel), res$callret.4)
colnames(resMat) <- c("Species", "num")

## for pie chart with plotly
resMat_1over <- resMat[resMat$num>1, ]
resMat_others <- resMat[resMat$num==1, ]
others <- list("Others", sum(resMat_others$num))
resMatfin <- rbind(resMat_1over, data.frame(Species="others", num="28"))

p <- plot_ly(resMatfin, labels = ~Species, values = ~num, type = 'pie') %>%
    layout(title = 'RPMM projects (Oct 22, 2020)',
        xaxis = list(showgrid = FALSE, zeroline = FALSE, 
                        showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, 
                        showticklabels = FALSE))
p


## ----rawdata------------------------------------------------------------------
res <- RPMM_get_rawdata_files(project = "RPMM0001")
head(res$url)

## ----rawdata2-----------------------------------------------------------------
res2 <- RPMM_get_rawdata_files(project = "RPMM0001", abf = TRUE)
head(res2$url)

## ----sessionInfo, echo=FALSE--------------------------------------------------
sessionInfo()

