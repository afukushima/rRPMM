##' This function gets URIs of raw data files (e.g., cdf format) 
##' from RIKEN PMM 
##' (http://metabobank.riken.jp/) with SPARQL queries
##' 
##' @title Getting all the raw data files in a Project from RPMM 
##' @param project a Project identifier in RIKEN PMM (default: RPMM0001)
##' @param abf use abf format file (default: netCDF files)
##' @return A data.frame of raw data file lists
##' @author Atsushi Fukushima
##' @export
##' @examples 
##' res <- RPMM_get_rawdata_files(project = 'RPMM0001')
##' head(res$url)
RPMM_get_rawdata_files <- function(project = "RPMM0001",
                                   abf = FALSE) {
    
    endpoint <- "http://metabobank.riken.jp/pmm/endpoint"
    
    if (is.null(project)) {
        stop("Please input RPMM's Project ID")
    }
    
    
    sparql_prefix <- paste("
    PREFIX riken: <http://metadb.riken.jp/ontology/plantMetabolomics/0.1/>
    PREFIX dcterms: <http://purl.org/dc/dcmitype/>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
                        ")

    if (abf) {
      sparql_filter <- paste0(
      "FILTER( ?proj = <http://metadb.riken.jp/db/plantMetabolomics/0.1/Project/", 
                    project, "> ) .",
      "FILTER REGEX( ?filelabel, \"^abf\" ) ."
                      )
    } else { 
      sparql_filter <- paste0(
      "FILTER( ?proj = <http://metadb.riken.jp/db/plantMetabolomics/0.1/Project/", 
                    project, "> ) .",
      "FILTER REGEX( ?filelabel, \"^netCDF\" ) ."
                      )
    }
    query <- paste(sparql_prefix, "
    SELECT DISTINCT ?rawDataset ?url
    WHERE {
        ?proj riken:experiment ?exp .
        ?exp riken:measurement ?measurement .
        ?measurement riken:rawDataset ?rawDataset .
        ?rawDataset riken:file ?file .
        ?file riken:downloadURL ?url .
        ?file riken:fileFormat ?fileFormat .
        ?fileFormat rdfs:label ?filelabel .", 
        sparql_filter, "}")
    
    res <- tryCatch({
        SPARQL::SPARQL(endpoint, query)
    }, error = function(err) {
        message("an error occured when trying to query for RPMM.", err)
    })
    
    return(res$results)
}

