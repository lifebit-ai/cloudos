#' cohort class
#'
#' This class create a cohort object, which will 
#' hold many information related to a cohort 
#' including cohort ID, name, description, filters, tables. 
#' Use of this object will simplify calling every 
#' other functions which requires a cohort.
#' This can be created using constructor function 
#' \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#'
#' @slot id cohort ID.
#' @slot name  cohort name.
#' @slot desc cohort description.
#' @slot phenoptype_filters currently viewed filters.
#' @slot query applied filter query.
#' @slot columns All the columns
#' @slot cb_version chort browser version
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
                      columns = "list", # v1 and v2 are structured differently
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
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  return(res)
}


.get_cohort_info_v2 <- function(cohort_id) {
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v2/cohort", cohort_id, sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id)
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  return(res)
}


.get_val_or_range <- function(field_item){
  if (!is.null(field_item$value)){
    return(field_item$value)
  }else{
    return(field_item$range)
  }
}


#' Convert a v1 style filter/query (moreFields) to v2 style (query).
#' v2 queries are a superset of v1 filters. A set of v1 filters are equivalent to a set of nested v2 AND operators
#' containing those filters. This function builds the nested AND query from the flat list of v1 filters.
#' @param cohort_more_fields Filter information ('moreFields') from .get_cohort_info(cohort_id, cb_version="v1)
.v1_query_to_v2 <- function(cohort_more_fields){
  andop <- list("operator" = "AND",
                "queries" = list())
  
  # make empty filter field better behaved by setting it as empty list
  if (!is.list(cohort_more_fields)) cohort_more_fields <- list()
  
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
#' applied filters.
#'
#' @param cohort_id Cohort id (Required)
#' @param cb_version cohort browser version (Optional) [ "v1" | "v2" ]
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
  
  cohort_class_obj <- methods::new("cohort",
                                   id = cohort_id,
                                   name = my_cohort$name,
                                   desc = my_cohort$description,
                                   phenoptype_filters = my_cohort$phenotypeFilters,
                                   query = my_cohort$query,
                                   columns = my_cohort$columns,
                                   cb_version = cb_version)
  return(cohort_class_obj)
}

# method for cohort object
setMethod("show", "cohort",
          function(object) {
            cat("Cohort ID: ", object@id, "\n")
            cat("Cohort Name: ", object@name, "\n")
            cat("Cohort Description: ", object@desc, "\n")
            cat("Number of filters applied: ", length(object@phenoptype_filters), "\n")
            cat("Cohort Browser version: ", object@cb_version, "\n")
          }
)
