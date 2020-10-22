##' Download project information from RIKEN PMM
##' (http://metabobank.riken.jp/) with SPARQL queries
##'
##' @title get Project information of RIKEN PMM with Project-ID
##' @param projectid RPMM Project ID (default: RPMM0001)
##' @return A data.frame of Project info
##' @author Atsushi Fukushima
##' @export
##' @examples
##' res <- RPMM_get_project_info(projectid = "RPMM0001") 
##' head(res)
RPMM_get_project_info <- function(projectid = "RPMM0001") {
    
    endpoint <- "http://metabobank.riken.jp/pmm/endpoint"
    
    if (is.na(projectid)) {
            stop("Not found the Project ID in RPMM.")
    }
    
    
    # sparql_prefix <- paste("
    # PREFIX riken: <http://metadb.riken.jp/ontology/plantMetabolomics/0.1/>
    # PREFIX dcterms: <http://purl.org/dc/dcmitype/>
    # PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    #                     ")
    sparql_filter <- paste("
    FILTER( ?proj = <http://metadb.riken.jp/db/plantMetabolomics/0.1/Project/",
                           projectid, "> ).", sep = "")
    
#    query <- paste(sparql_prefix, "
    query <- paste("
    SELECT DISTINCT ?proj ?title ?species ?speciesLabel ?piName ?piAffiName ?ref ?otherInfo ?desc
WHERE {

  Optional {
    ?proj <http://metadb.riken.jp/ontology/plantMetabolomics/0.1/principalInvestigator> ?pi .
    Optional {
      ?pi <http://www.w3.org/2000/01/rdf-schema#label> ?piName FILTER (LANG(?piName) = 'en').
      Optional {
        ?pi <http://metadb.riken.jp/ontology/plantMetabolomics/0.1/affiliation> ?piAffi .
        ?piAffi <http://www.w3.org/2000/01/rdf-schema#label> ?piAffiName FILTER (LANG(?piAffiName) = 'en').
  }}}

  Optional{
    ?proj <http://www.w3.org/2000/01/rdf-schema#label> ?title FILTER (LANG(?title) = 'en') .
  }
  
  Optional {
    ?proj <http://purl.org/dc/dcmitype/references> ?ref .
  }

  Optional {
    ?proj <http://www.w3.org/2000/01/rdf-schema#seeAlso> ?otherInfo .
  }
  
  Optional {
    ?proj <http://purl.org/dc/dcmitype/description> ?desc .
  }
  
  ?proj <http://metadb.riken.jp/ontology/plantMetabolomics/0.1/experiment> ?exp . 
  Optional {
    ?exp <http://metadb.riken.jp/ontology/plantMetabolomics/0.1/measurement> ?measurement .
    ?measurement <http://metadb.riken.jp/ontology/plantMetabolomics/0.1/sampleMeasured> ?sample .
    ?sample <http://metadb.riken.jp/ontology/plantMetabolomics/0.1/biologicalSample> ?bioSample .
    ?bioSample <http://purl.obolibrary.org/obo/RO_0002162> ?species .
    ?species <http://www.w3.org/2004/02/skos/core#prefLabel> ?speciesLabel .
                   }",
     sparql_filter, "}", 
     sep = "")               
    
    message("Performing query please wait...")
    
    res <- tryCatch({
        SPARQL::SPARQL(endpoint, query)
    }, error = function(err) {
        message("an error occured when trying to query for RPMM.", err)
    })
    res <- format_project_info(res$results)

    return(res)
}

format_project_info <- function(returned_res) {
  proj <- unique(returned_res$proj); proj <- gsub("@en", "", proj);
  title <- unique(returned_res$title); title <- gsub("@en", "", title);
  species <- unique(returned_res$species); species <- gsub("@en", "", species);
  speciesLabel <- unique(returned_res$speciesLabel)
  speciesLabel <- gsub("@en", "", speciesLabel)
  piName <- unique(returned_res$piName); piName <- gsub("@en", "", piName);
  piAffiName <- unique(returned_res$piAffiName)
  piAffiName <- gsub("@en", "", piAffiName)
  ref <- unique(returned_res$ref); ref <- gsub("@en", "", ref)
  otherInfo <- unique(returned_res$otherInfo)
  otherInfor <- gsub("@en", "", otherInfo)
  desc <- unique(returned_res$desc); desc <- gsub("@en", "", desc)
  res <- list(Project = proj, 
              Title = title, TaxonID = species, 
              Species = speciesLabel, PI_Name = piName, 
              PI_Affi_Name = piAffiName, Reference = ref, 
              Other_Information = otherInfo, Description = desc)
  return(res)
}
