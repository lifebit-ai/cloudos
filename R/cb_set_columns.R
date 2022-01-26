#' @title Set the columns in a cohort
#'
#' @description Updates a cohort by applying a new query.
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param column_ids Phenotype IDs to be added as columns in the participant table.
#' @param keep_columns If True, pre-existing columns are retained and newly supplied columns are added.
#'   Otherwise, pre-exisitng columns are overwritten. (Default: TRUE)
#' 
#' @return The updated cohort object.
#' 
#' @examples
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "612f37a57673ed0ddeaf1333", cb_version = "v2")
#' 
#' my_cohort <- cb_set_columns(my_cohort, c(1, 99, 38), keep_columns = F)
#' }
#' 
#' @export
cb_set_columns <- function(cohort,
                           column_ids,
                           keep_columns = TRUE){
    
  if (cohort@cb_version == "v1"){
    return(.cb_set_columns_v1(cohort = cohort,
                              column_ids = column_ids,
                              keep_columns = keep_columns))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_set_columns_v2(cohort = cohort,
                              column_ids = column_ids,
                              keep_columns = keep_columns))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}


.cb_set_columns_v1 <- function(cohort,
                               column_ids,
                               keep_columns = TRUE) {

  all_columns <- .create_all_columns(cohort = cohort, column_ids = column_ids, keep_columns = keep_columns)

  # prepare request body
  r_body <- list("columns" = all_columns,
                 "moreFilters" = .query_body_to_v1(cohort@query))
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v1/cohort", cohort@id, "filters", sep = "/")
  r <- httr::PUT(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id),
                 body = jsonlite::toJSON(r_body, auto_unbox = T),
                 encode = "raw"
  )
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "set columns")
  
  return(cb_load_cohort(cohort@id, cb_version = cohort@cb_version))
}


.cb_set_columns_v2 <- function(cohort,
                               column_ids,
                               keep_columns = TRUE) {

  all_columns <- .create_all_columns(cohort = cohort, column_ids = column_ids, keep_columns = keep_columns)

  no_participants <- cb_participant_count(cohort)
  
  # prepare request body
  r_body <- list(name = cohort@name,
                 description = cohort@desc,
                 columns = all_columns,
                 numberOfParticipants = no_participants$count)
  
  if(!identical(cohort@query, list())) r_body$query <- cohort@query
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v2/cohort", cohort@id, sep = "/")
  r <- httr::PUT(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id),
                 body = jsonlite::toJSON(r_body, auto_unbox = T),
                 encode = "raw"
  )
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "set columns")
  
  return(cb_load_cohort(cohort@id, cb_version = cohort@cb_version))
}

