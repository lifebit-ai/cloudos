#' @title List cohorts
#'
#' @description Extracts the data frame with limited cohort data columns.
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}} 
#' @param page_number Number of page. (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#'
#' @return A data frame with available cohorts.
#'
#' @examples
#' \dontrun{
#' list_cohorts(cloudos_obj)
#' }
#' @export
list_cohorts <- function(object,
                         page_number = 0,
                         page_size = 10) {
  url <- paste(object@base_url, "api/v1/cohort", sep = "/")
  r <- httr::GET(url,
                 httr::add_headers("Authorization" = object@auth),
                 query = list("teamId" = object@team_id,
                              "pageNumber" = page_number,
                              "pageSize" = page_size))
  if (!r$status_code == 200) {
    stop("No cohorts found. Or not able to connect with server.")
  }
  # parse the content
  res <- httr::content(r)
  message("Total number of cohorts found-", res$total, 
          ". But here is 10. For more, change 'page_number' and 'page_size'")
  cohorts <- res$cohorts
  # make in to a list
  cohorts_list <- list()
  for (n in 1:page_size) {
    dta <- data.frame(id = cohorts[[n]]$`_id`,
                      name = cohorts[[n]]$`name`,
                      description = cohorts[[n]]$`description`,
                      number_of_participants = cohorts[[n]]$`numberOfParticipants`,
                      number_of_filters = cohorts[[n]]$`numberOfFilters`,
                      created_at = cohorts[[n]]$`createdAt`,
                      updated_at = cohorts[[n]]$`updatedAt`)
    cohorts_list[[n]] <- dta
    # filter
    # cohorts[[1]]$`filters`
  }
  # make in to a dataframe
  cohorts_df <- do.call(rbind, cohorts_list)
  return(cohorts_df)
}

###################################################################

get_cohort_info <- function(object, cohort_id) {
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
