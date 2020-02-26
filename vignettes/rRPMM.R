## -----------------------------------------------------------------------------
# devtools::install_github("afukushima/rRPMM", build_vignettes = TRUE)

## ----setup--------------------------------------------------------------------
# suppressPackageStartupMessages(library(SPARQL))
# suppressPackageStartupMessages(library(rRPMM))
# suppressPackageStartupMessages(library(plotly))
# suppressPackageStartupMessages(library(dplyr))
Sys.setenv(LANGUAGE="en_US.UTF-8") 

library(SPARQL)
library(rRPMM)
library(plotly)
library(dplyr)


res <- RPMM_numOfprojects_species()
head(res)
pie(res$callret.4)
resMat <- data.frame(gsub("@en", "", res$speciesLabel), res$callret.4)
head(resMat)
colnames(resMat) <- c("Species", "num")

## for pie chart
resMat_1over <- resMat[resMat$num>1, ]
resMat_others <- resMat[resMat$num==1, ]
others <- list("Others", sum(resMat_others$num))
resMatfin <- rbind(resMat_1over, data.frame(Species="others", num="28"))

p <- plot_ly(resMatfin, labels = ~Species, values = ~num, type = 'pie') %>%
  layout(title = 'RPMM projects (Feb 19, 2020)',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
p


