##' This function counts projects from RIKEN PMM 
##' (http://metabobank.riken.jp/) for each family with SPARQL queries
##' 
##' @title Number Of Projects in RIKEN PMM with family info  
##' @return A data.frame of Project lists
##' @author Atsushi Fukushima
##' @export
##' @examples 
##' res <- RPMM_numOfprojects_family()
##' head(res)
RPMM_numOfprojects_family <- function() {
    
    endpoint <- "http://metabobank.riken.jp/pmm/endpoint"
    
    sparql_prefix <- paste("
    PREFIX riken: <http://metadb.riken.jp/ontology/plantMetabolomics/0.1/>
    PREFIX dcterms: <http://purl.org/dc/dcmitype/>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX obo: <http://purl.obolibrary.org/obo/>
                        ")
    
    query <- paste(sparql_prefix, "
    SELECT DISTINCT ?family ?familyLabel count(distinct ?proj)
    WHERE {
        ?proj riken:experiment ?exp .
        ?exp riken:measurement ?measurement .
        ?measurement riken:sampleMeasured ?sample .
        ?sample riken:biologicalSample ?bioSample .
        ?bioSample obo:RO_0002162 ?species .
        ?species <http://www.w3.org/2004/02/skos/core#prefLabel> ?speciesLabel .
        ?species rdfs:subClassOf+ ?family .
        ?family <http://purl.bioontology.org/ontology/NCBITAXON/RANK> 
        \"family\"^^<http://www.w3.org/2001/XMLSchema#string> .
        ?family <http://www.w3.org/2004/02/skos/core#prefLabel> ?familyLabel .
    }")
    
    res <- tryCatch({
        SPARQL::SPARQL(endpoint, query)
    }, error = function(err) {
        message("an error occured when trying to query for RPMM.", err)
    })
    
    return(res$results)
}
