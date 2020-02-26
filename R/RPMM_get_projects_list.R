##' Download list of projects from RIKEN PMM
##' (http://metabobank.riken.jp/) with SPARQL queries
##'
##' @title get Project list of RIKEN PMM with species info
##' @param scientific_name a scientific name of species
##' @param taxonid NCBI taxonomy ID (default: 3702)
##' @return A data.frame of Project lists
##' @author Atsushi Fukushima
##' @export
##' @examples
##' res <- RPMM_get_projects_list(taxonid = 3702) ## Arabidopsis
##' head(res)
RPMM_get_projects_list <- function(scientific_name = "Arabidopsis thaliana", 
                                    taxonid = 3702) {
    
    endpoint <- "http://metabobank.riken.jp/pmm/endpoint"
    
    if ((is.null(scientific_name)) || (is.null(taxonid))) 
        stop("Please input species name or NCBI taxonomy ID.")
    if (!is.null(scientific_name)) {
        taxonid <- taxize::get_uid(scientific_name, ask = FALSE, 
                                    messages = FALSE)[1]
        if (is.na(taxonid)) 
            stop("Not found the species name in NCBI taxonomy.")
    }
    
    
    sparql_prefix <- paste("
    PREFIX riken: <http://metadb.riken.jp/ontology/plantMetabolomics/0.1/>
    PREFIX dcterms: <http://purl.org/dc/dcmitype/>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX obo: <http://purl.obolibrary.org/obo/>
                        ")
    sparql_filter <- paste("
    FILTER( ?species = <http://purl.bioontology.org/ontology/NCBITAXON/", 
                        taxonid, "> ).", sep = "")
    
    query <- paste(sparql_prefix, "
    SELECT DISTINCT ?proj
    FROM<http://metadb.riken.jp/db/plantMetabolomics>
    WHERE {
        ?proj a riken:Project .
        ?proj riken:experiment ?exp .
        ?exp riken:measurement ?measurement .
        ?measurement riken:sampleMeasured ?sample .
        ?sample riken:biologicalSample ?bioSample .
        ?bioSample obo:RO_0002162 ?species .", 
        sparql_filter, "}")
    
    message("Performing query please wait...")
    
    res <- tryCatch({
        SPARQL::SPARQL(endpoint, query)
    }, error = function(err) {
        message("an error occured when trying to query for RPMM.", err)
    })
    
    return(res$results)
}
