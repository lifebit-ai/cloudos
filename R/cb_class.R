#' cohort class
#'
#' This will create a cohort object, which will 
#' hold many information related to a cohort 
#' including cohort ID, name, description, filters, tables. 
#' Use of this object will simplify calling every 
#' other functions which requires a cohort.
#'
#' @slot id cohort ID.
#' @slot name  cohort name.
#' @slot desc cohort description.
#' @slot fields Filters.
#' @slot more_fields Filter related information.
#'
#' @name cohort-class
#' @rdname cohort-class
#' @export
setClass("cohort", 
         slots = list(id = "character",
                      name = "character",
                      desc = "character",
                      fields = "list",
                      more_fields = "list")
         )

.get_cohort_info <- function(object, cohort_id) {
  url <- paste(object@base_url, "api/v1/cohort", cohort_id, sep = "/")
  r <- httr::GET(url,
                 httr::add_headers("Authorization" = object@auth),
                 query = list("teamId" = object@team_id)
  )
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  }
  # parse the content
  res <- httr::content(r)
  return(res)
}

#' @title Get cohort information
#'
#' @description Get all the details about a cohort including 
#' applied filters.
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param cohort_id Cohort id (Required)
#'
#' @return A list
#'
#' @export
cb_load_cohort <- function(object, cohort_id){
  my_cohort <- .get_cohort_info(object = object, 
                              cohort_id = cohort_id)
  cohort_class_obj <- methods::new("cohort",
                                   id = cohort_id,
                                   name = my_cohort$name,
                                   desc = my_cohort$description,
                                   fields = my_cohort$fields,
                                   more_fields = my_cohort$moreFields
                                   )
  return(cohort_class_obj)
}

# method for cohort object
setMethod("show", "cohort",
          function(object) {
            cat("Cohort ID: ", object@id, "\n")
            cat("Cohort Name: ", object@name, "\n")
            cat("Cohort Description: ", object@desc, "\n")
          }
)
