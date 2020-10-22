context("rRPMM: an R package for RIKEN PMM")

test_that("check functions", {
  library(SPARQL)
  res1 <- RPMM_get_projects_list(taxonid = 3702)
  res2 <- rRPMM::RPMM_numOfprojects_species()
  res3 <- rRPMM::RPMM_numOfprojects_family()
  res4 <- rRPMM::RPMM_get_rawdata_files(project = "RPMM0001", abf = TRUE)
  res5 <- rRPMM::RPMM_get_rawdata_files(project = "RPMM0001", abf = FALSE)
  res6 <- rRPMM::RPMM_get_project_info(projectid = "RPMM0001")
  ##
  ## expected values
  expect_equal(class(res1), "data.frame")
  expect_equal(class(res2), "data.frame")
  expect_equal(class(res3), "data.frame")
  expect_equal(class(res4), "data.frame")
  ##
  expect_equal(names(res1)[1], "proj")
  expect_equal(names(res2)[1], "species")
  expect_equal(names(res3)[1], "family")
  expect_equal(names(res4)[1], "rawDataset")
  
  ##
  expect_equal(grep("ABF", res4$url[1]), 1)    ## abf format
  expect_equal(grep("CDF|cdf", res5$url[1]), 1) ## netCDF format
  ##
  expect_equal(grep("3702", res6$TaxonID), 1)    ## 3702 (NCBI taxon)
})

