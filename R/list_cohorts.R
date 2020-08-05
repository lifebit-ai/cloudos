#' @title Limited Cohort Data Extractor
#'
#' @description Extracts the data frame with limited cohort data columns.
#'
#' @param baseurl Base URL of the CloudOS server. Required
#' @param auth  An authontication token. Example - Bearer token. Required
#' @param apikey A API key. Required if auth not provided.
#' @param teamid Team ID in CloudOS account. Required parameter
#' @param page_number Number of page. Optional. Default - 0
#' @param page_size Number of entries in a page. Optional. Default - 10
#'
#' @return A list.
#'
# @examples
#'
#' @import httr
#' @export

list_cohorts <- function(baseurl, 
                         auth, 
                         apikey,
                         teamid, 
                         page_number = 0, 
                         page_size = 10 ){
  url = paste(baseurl,"api/v1/cohort", sep="/")
  r <- GET(url, 
           add_headers(Authorization = auth), 
           query = list(teamId = teamid))
  res <- content(r)
  cohort <- res$cohort
  return(cohort)
}
