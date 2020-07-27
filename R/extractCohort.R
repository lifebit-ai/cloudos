#' @title Cohort Dataframe Extractor
#'
#' @description Extracts the data frame with complete cohort data.
#'
#' @name extractCohort
#'
#' @param baseUrl required parameter
#' @param apikey required parameter
#' @param teamId required parameter
#' @param cohortId optional parameter to fetch data for a particular Id
#' @param pageNumber optional parameter with default value 0
#' @param pageSize optional parameter with default value 10
#'
#' @return output
#'
# @examples extractCohort(baseUrl = "https://ukb-dev.lifebit.ai", apikey = "hEHFlgtRTIcL8Rqu0gb9HKTTPWWtsfDppEF6xZf7", teamId = "5e91151f75edb766bf8fba26", pageNumber = 0, pageSize = 10)
#'
#' @export extractCohort
#'
library(httr)

extractCohort <- function(baseUrl, apikey, teamId, cohortId=NULL, pageNumber = 1, pageSize = 10 ){
  url = paste(baseUrl,"api/v1/cohort", sep="/")
  if(is.null(cohortId)){
    newUrl = url
    res <- content(GET(newUrl, add_headers(apikey = apikey),query = list(teamId = teamId, pageNumber = pageNumber, pageSize = pageSize)))
  } else {
    newUrl = paste(url,cohortId, sep="/")
    res <- content(GET(newUrl, add_headers(apikey = apikey),query = list(teamId = teamId)))
  }

  if(is.null(cohortId)){
    cohort <- res
    output <- as.data.frame.list(unlist(cohort))
  } else {
    output <- as.data.frame(res)
  }
  rm(res)
  return(output)
}
