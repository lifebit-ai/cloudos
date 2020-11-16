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
#' @slot fields Filters.
#' @slot more_fields Filter related information.
#' @slot columns All the columns
#'
#' @name cohort-class
#' @rdname cohort-class
#' @export
setClass("cohort", 
         slots = list(id = "character",
                      name = "character",
                      desc = "character",
                      fields = "list",
                      more_fields = "list",
                      columns = "list")
         )

.get_cohort_info <- function(cloudos, cohort_id) {
  url <- paste(cloudos@base_url, "v1/cohort", cohort_id, sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos@auth),
                 query = list("teamId" = cloudos@team_id)
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  return(res)
}

#' @title Get cohort information
#'
#' @description Get all the details about a cohort including 
#' applied filters.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param cohort_id Cohort id (Required)
#'
#' @return A \linkS4class{cohort} object.
#' 
#' @seealso \code{\link{cb_create_cohort}} for creating a new cohort. 
#'
#' @export
cb_load_cohort <- function(cloudos, cohort_id){
  my_cohort <- .get_cohort_info(cloudos = cloudos, 
                              cohort_id = cohort_id)
  
  # For empty description backend returns two things NULL and ""
  if(is.null(my_cohort$description)) my_cohort$description = "" # change everything to ""
  
  cohort_class_obj <- methods::new("cohort",
                                   id = cohort_id,
                                   name = my_cohort$name,
                                   desc = my_cohort$description,
                                   fields = my_cohort$fields,
                                   more_fields = my_cohort$moreFields,
                                   columns = my_cohort$columns
                                   )
  return(cohort_class_obj)
}

# method for cohort object
setMethod("show", "cohort",
          function(object) {
            cat("Cohort ID: ", object@id, "\n")
            cat("Cohort Name: ", object@name, "\n")
            cat("Cohort Description: ", object@desc, "\n")
            cat("Number of filters applied: ", length(object@fields), "\n")
          }
)
