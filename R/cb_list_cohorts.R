#' @title List cohorts
#'
#' @description Extracts the data frame with limited cohort data columns.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param size Number of cohort entries from database. (Optional) Default - 10
#'
#' @return A data frame with available cohorts.
#'
#' @examples
#' \dontrun{
#' cohorts_list(cloudos_obj)
#' }
#' @export
cb_list_cohorts <- function(cloudos,
                            size = 10) {
  url <- paste(cloudos@base_url, "v1/cohort", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos@auth),
                 query = list("teamId" = cloudos@team_id,
                              "pageNumber" = 0,
                              "pageSize" = size))
  if (!r$status_code == 200) {
    stop("No cohorts found. Or not able to connect with server.")
  }
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



