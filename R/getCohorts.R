#' @title Cohort List Extractor
#'
#' @name getCohorts
#'
#' @description Extracts the List with complete cohort data.
#'
#' @param baseUrl required parameter
#' @param apikey required parameter
#' @param teamId required parameter
#' @param cohortId optional parameter to fetch data for a particular Id
#' @param pageNumber optional parameter with default value 0
#' @param pageSize optional parameter with default value 10
#'
#' @return result
#'
# @examples getCohorts(baseUrl = "https://ukb-dev.lifebit.ai", apikey = "hEHFlgtRTIcL8Rqu0gb9HKTTPWWtsfDppEF6xZf7", teamId = "5e91151f75edb766bf8fba26", pageNumber = 0, pageSize = 10)
#'
#' @export getCohorts
#'
library(httr)

getCohorts <- function(baseUrl, apikey, teamId, cohortId=NULL, pageNumber = 0, pageSize = 10 ){
  url = paste(baseUrl,"api/v1/cohort", sep="/")
  if(is.null(cohortId)){
      newUrl = url
      result <- content(GET(newUrl, add_headers(apikey = apikey),query = list(teamId = teamId, pageNumber = pageNumber, pageSize = pageSize)))
  } else {
      newUrl = paste(url,cohortId, sep="/")
      result <- content(GET(newUrl, add_headers(apikey = apikey),query = list(teamId = teamId)))
  }

  return(result)
}
