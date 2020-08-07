#' @title Limited Cohort Data Extractor
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
#' @return A list.
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
                 httr::add_headers(Authorization = auth),
                 query = list(teamId = teamid))
  res <- httr::content(r)
  cohort <- res$cohort
  return(cohort)
}
