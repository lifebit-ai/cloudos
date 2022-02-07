#' cohort class
#'
#' This class creates a cohort object, which holds the information related to a
#' cohort: cohort ID, name, description, query, table columns. This class is used
#' in functions which carry out operations related to specific cohorts.
#' A cohort class object can be created using constructor functions
#' \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}.
#'
#' @slot id cohort ID.
#' @slot name  cohort name.
#' @slot desc cohort description.
#' @slot phenoptype_filters phenotypes displayed in the cohort overview.
#' @slot query applied query.
#' @slot query_phenotype_ids IDs of phenotypes used in the query.
#' @slot columns All the columns.
#' @slot num_participants number of participants in the cohort.
#' @slot cb_version chort browser version.
#'
#' @name cohort-class
#' @rdname cohort-class
#' @export
setClass("cohort", 
         slots = list(id = "character",
                      name = "character",
                      desc = "character",
                      phenoptype_filters = "list", # renamed from 'fields' to match v2 naming
                      query = "list",   # replaces v1 more_fields / moreFields with more flexible v2 structure
                      query_phenotype_ids = "integer",
                      columns = "list", # v1 and v2 are structured differently
                      num_participants = "numeric",
                      cb_version = "character")
         )


.get_cohort_info <- function(cohort_id, cb_version = "v2") {
  if (cb_version == "v1") {
    return(.get_cohort_info_v1(cohort_id))
    
  } else if (cb_version == "v2") {
    return(.get_cohort_info_v2(cohort_id))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}

.get_cohort_info_v1 <- function(cohort_id) {
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v1/cohort", cohort_id, sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id)
  )
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "get cohort info")

  return(res)
}


.get_cohort_info_v2 <- function(cohort_id) {
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v2/cohort", cohort_id, sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id)
  )
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "get cohort info")
  
  return(res)
}


.get_val_or_range <- function(field_item){
  if (!is.null(field_item$value)){
    return(field_item$value)
  }else{
    return(field_item$range)
  }
}


# Convert a v1 style query (moreFields) to v2 style (query).
# v2 queries are a superset of v1 queries. A list of v1 phenotype queries are equivalent to a 
# set of nested v2 AND operators containing those phenotypes. This function builds the nested 
# AND query from the flat list of v1 phenotypes.
# @param cohort_more_fields query information ('moreFields') from .get_cohort_info(cohort_id, cb_version="v1)
.v1_query_to_v2 <- function(cohort_more_fields){
  andop <- list("operator" = "AND",
                "queries" = list())
  
  # make empty query field better behaved by setting it as empty list
  if (!is.list(cohort_more_fields)) cohort_more_fields <- list()
  if (identical(cohort_more_fields, list(""))) cohort_more_fields <- list()
  
  l <- length(cohort_more_fields)
  
  query <- list()
  
  if (l > 0){
    query <- andop
    query$queries <- list(list("field" = cohort_more_fields[[l]]$fieldId,
                               "instance" = cohort_more_fields[[l]]$instance,
                               "value" = .get_val_or_range(cohort_more_fields[[l]])))
  }
  
  if (l > 1){
    query$queries <- list(list("field" = cohort_more_fields[[l-1]]$fieldId,
                               "instance" = cohort_more_fields[[l-1]]$instance,
                               "value" = .get_val_or_range(cohort_more_fields[[l-1]])),
                          query$queries[[1]])
  }
  
  if (l > 2){
    for (i in (l-2):1){
      new_query <- andop
      new_query$queries <- list(list("field" = cohort_more_fields[[i]]$fieldId,
                                     "instance" = cohort_more_fields[[i]]$instance,
                                     "value" = .get_val_or_range(cohort_more_fields[[i]])),
                                query)
      query <- new_query
    }
  }
  
  return(query)
}



#' @title Get cohort information
#'
#' @description Get all the details about a cohort including 
#' applied query.
#'
#' @param cohort_id Cohort id (Required)
#' @param cb_version cohort browser version (Optional) \[ "v1" | "v2" \]
#'
#' @return A \linkS4class{cohort} object.
#'
#' @example
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' }
#' 
#' @seealso \code{\link{cb_create_cohort}} for creating a new cohort. 
#'
#' @export
cb_load_cohort <- function(cohort_id, cb_version = "v2"){
  my_cohort <- .get_cohort_info(cohort_id = cohort_id, cb_version = cb_version)
  
  # convert v1 query to v2 query and rename objects to v2 style
  if (cb_version == "v1"){
    my_cohort$phenotypeFilters = my_cohort$fields
    my_cohort$query = .v1_query_to_v2(my_cohort$moreFields)
  }
  
  # For empty fields backend can return NULL
  if(is.null(my_cohort$description)) my_cohort$description = "" # change everything to ""
  if(is.null(my_cohort$query)) my_cohort$query = list()
  
  flat_query <- .unnest_query(my_cohort$query)
  if (identical(flat_query, list(list()))) {
    query_phenotype_ids <- integer()
  } else {
    query_phenotype_ids = sapply(flat_query, function(p){p$field})
  }
  
  cohort_class_obj <- methods::new("cohort",
                                   id = cohort_id,
                                   name = my_cohort$name,
                                   desc = my_cohort$description,
                                   phenoptype_filters = my_cohort$phenotypeFilters,
                                   query = my_cohort$query,
                                   query_phenotype_ids = query_phenotype_ids,
                                   columns = my_cohort$columns,
                                   num_participants = NA_integer_,
                                   cb_version = cb_version)

  if (cb_version == "v1") {
    cohort_class_obj@num_participants <- cb_participant_count(cohort_class_obj)$count
  } else if (cb_version == "v2") {
    cohort_class_obj@num_participants <- my_cohort$numberOfParticipants
  }

  return(cohort_class_obj)
}

# method for cohort object
setMethod("show", "cohort",
          function(object) {
            cat("Cohort ID: ", object@id, "\n")
            cat("Cohort Name: ", object@name, "\n")
            cat("Cohort Description: ", object@desc, "\n")
            cat("Number of phenotypes in query: ", length(object@query_phenotype_ids), "\n")
            cat("Number of participants in cohort: ", object@num_participants, "\n")
            cat("Cohort Browser version: ", object@cb_version, "\n")
          }
)
