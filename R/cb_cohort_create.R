#' @title Create Cohort
#'
#' @description Creates a new Cohort
#'
#' @param cohort_name New cohort name to be created. (Required)
#' @param cohort_desc New cohort description to be created. (Optional)
#' @param filters WIP - details will be added.
#' @param cb_version cohort browser version. \["v1" | "v2"\] (Optional) Default - "v2"
#'
#' @return A \linkS4class{cohort} object.
#' 
#' @seealso \code{\link{cb_load_cohort}} for loading a available cohort.
#'
#' @examples
#' \dontrun{
#' my_cohort <- cb_create_cohort(cohort_name = "Cohort-R",
#'                               cohort_desc = "This cohort is for testing purpose, created from R.")
#' }
#' @export
cb_create_cohort <- function(cohort_name, cohort_desc, filters = "", cb_version="v2") {
  
  if (cb_version == "v1") {
    return(.cb_create_cohort_v1(cohort_name=cohort_name, cohort_desc=cohort_desc, filters=filters))
    
  } else if (cb_version == "v2") {
    return(.cb_create_cohort_v2(cohort_name=cohort_name, cohort_desc=cohort_desc, filters=filters))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}


.cb_create_cohort_v1 <- function(cohort_name, cohort_desc, filters = "") {
  
  # if no description provided
  if(missing(cohort_desc)){
    cohort_desc = list()
  }
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v1/cohort/", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = list("name" = cohort_name,
                              "description" = cohort_desc, 
                              "moreFilters" = filters), # TODO work on filters - its better to do from UI
                  encode = "json"
  )
  httr::stop_for_status(r, task = "create a cohort")
  # parse the content
  message("Cohort created successfully.")
  res <- httr::content(r)
  # into a dataframe
  # res_df <- do.call(rbind, res)
  # colnames(res_df) <- "details"
  # return a cohort object
  cohort_obj <- cb_load_cohort(cohort_id = res$`_id`, cb_version = "v1")
  return(cohort_obj)
}


.cb_create_cohort_v2 <- function(cohort_name, cohort_desc, filters = "") {
  
  # if no description provided
  if(missing(cohort_desc)){
    cohort_desc = list()
  }
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v2/cohort/", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = list("name" = cohort_name,
                              "description" = cohort_desc, 
                              "moreFilters" = filters), # TODO work on filters - its better to do from UI
                  encode = "json"
  )
  httr::stop_for_status(r, task = "create a cohort")
  # parse the content
  message("Cohort created successfully.")
  res <- httr::content(r)
  # into a dataframe
  # res_df <- do.call(rbind, res)
  # colnames(res_df) <- "details"
  # return a cohort object
  cohort_obj <- cb_load_cohort(cohort_id = res$`_id`, cb_version = "v2")
  return(cohort_obj)
  
  #TODO check why created cohort is not listed but can be found by ID.
}


