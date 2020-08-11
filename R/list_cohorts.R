#' @title List cohorts
#'
#' @description Extracts the data frame with limited cohort data columns.
#'
#' @param baseurl Base URL of the CloudOS server. (Required)
#' @param auth  An authentication method. (Required)
#' Example - Bearer token or API key.
#' @param teamid Team ID in CloudOS account. (Required)
#' @param page_number Number of page. (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#'
#' @return A data frame with available cohorts.
#'
#' @examples
#' \dontrun{
#' list_cohorts(baseurl= "https://cloudos.lifebit.ai",
#'              auth = "Bearer ***token***",
#'              teamid = "***teamid***")
#' }
#' @export
list_cohorts <- function(baseurl,
                         auth,
                         teamid,
                         page_number = 0,
                         page_size = 10) {
  url <- paste(baseurl, "api/v1/cohort", sep = "/")
  r <- httr::GET(url,
                 httr::add_headers("Authorization" = auth),
                 query = list("teamId" = teamid,
                              "pageNumber" = page_number,
                              "pageSize" = page_size))
  if (!r$status_code == 200) {
    message("No cohorts found. Or not able to connect with server.")
  } else {
    res <- httr::content(r)
    message("Total number of cohorts found - ", res$total)
    cohorts <- res$cohort
    # make in to a list
    cohorts_list <- list()
    for (n in 1:res$total) {
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
}
