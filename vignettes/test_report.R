## ----setup, include = FALSE, message = FALSE----------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----getData, message = FALSE-------------------------------------------------
library(SPARQL)
library(rRPMM)
res <- RPMM_get_project_info(projectid = "RPMM0001")

## ----showData, message = FALSE------------------------------------------------
knitr::kable(data.frame(unlist(res)))

## ----getData2, message = FALSE------------------------------------------------
res2 <- RPMM_get_project_info(projectid = "RPMM0003")

## ----showData2, message = FALSE-----------------------------------------------
knitr::kable(data.frame(unlist(res2)))

