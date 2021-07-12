#' @title List cohorts
#'
#' @description Extracts the data frame with limited cohort data columns.
#'
#' @param size Number of cohort entries from database. (Optional) Default - 10
#' @param cb_version cohort browser version. ["v1" | "v2"] (Optional) Default - "v2"

#'
#' @return A data frame with available cohorts.
#'
#' @examples
#' \dontrun{
#' cohorts_list()
#' }
#' @export
cb_list_cohorts <- function(size = 10, cb_version = "v2") {
  
  if (cb_version == "v1") {
    return(.cb_list_cohorts_v1(size=size))
    
  } else if (cb_version == "v2") {
    return(.cb_list_cohorts_v2(size=size))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}


.cb_list_cohorts_v1 <- function(size = 10) {
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v1/cohort", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id,
                              "pageNumber" = 0,
                              "pageSize" = size))
  httr::stop_for_status(r, task = "list cohorts")
  # parse the content
  res <- httr::content(r)
  if(size == 10){
    message("Total number of cohorts found-", res$total, 
            ". But here shows-",  size," as default. For more, change size = ", res$total, " to get all.") 
  }
  cohorts <- res$cohorts
  # make in to a list
  cohorts_list <- list()
  for (n in 1:length(cohorts)) {
    
    # For empty description backend returns two things NULL and ""
    description = cohorts[[n]]$description
    if(is.null(description)) description = "" # change everything to ""
    
    # For no filters backend returns NULL
    numberOfFilters <- cohorts[[n]]$numberOfFilters
    if(is.null(numberOfFilters)) numberOfFilters <- 0    
    
    dta <- data.frame(id = cohorts[[n]]$`_id`,
                      name = cohorts[[n]]$name,
                      description = description,
                      number_of_participants = cohorts[[n]]$numberOfParticipants,
                      number_of_filters = numberOfFilters,
                      created_at = cohorts[[n]]$createdAt,
                      updated_at = cohorts[[n]]$updatedAt)
    cohorts_list[[n]] <- dta
    # filter
    # cohorts[[1]]$`filters`
  }
  # make in to a dataframe
  cohorts_df <- do.call(rbind, cohorts_list)
  return(cohorts_df)
}


.cb_list_cohorts_v2 <- function(size = 10) {
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v2/cohort", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id,
                              "pageNumber" = 0,
                              "pageSize" = size))
  httr::stop_for_status(r, task = "list cohorts")
  # parse the content
  res <- httr::content(r)
  if(size == 10){
    message("Total number of cohorts found: ", res$total, 
            ". Showing ",  size," by default. Change 'size' parameter to return more.") 
  }
  cohorts <- res$cohorts
  # make in to a list
  cohorts_list <- list()
  for (n in 1:length(cohorts)) {
    
    # For empty description backend returns two things NULL and ""
    description <- cohorts[[n]]$description
    if(is.null(description)) description <- "" # change everything to ""
    
    # For no filters backend returns NULL
    numberOfFilters <- cohorts[[n]]$numberOfFilters
    if(is.null(numberOfFilters)) numberOfFilters <- 0
    
    dta <- data.frame(id = cohorts[[n]]$`_id`,
                      name = cohorts[[n]]$name,
                      description = description,
                      number_of_participants = cohorts[[n]]$numberOfParticipants,
                      number_of_filters = numberOfFilters,
                      created_at = cohorts[[n]]$createdAt,
                      updated_at = cohorts[[n]]$updatedAt)
    cohorts_list[[n]] <- dta
    # filter
    # cohorts[[1]]$`filters`
  }
  # make in to a dataframe
  cohorts_df <- do.call(rbind, cohorts_list)
  return(cohorts_df)
}



