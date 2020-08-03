#' @title Limited Cohort Data Extractor
#'
#' @name listCohorts
#' @description Extracts the data frame with limited cohort data columns.
#'
#' @param baseUrl required parameter
#' @param apikey required parameter
#' @param workspaceId required parameter
#' @param cohortId optional parameter to fetch data for a particular Id
#' @param pageNumber optional parameter with default value 0
#' @param pageSize optional parameter with default value 10
#'
#' @return result
#'
# @examples listCohorts(baseUrl = "https://ukb-dev.lifebit.ai", apikey = "hEHFlgtRTIcL8Rqu0gb9HKTTPWWtsfDppEF6xZf7", teamId = "5e91151f75edb766bf8fba26", pageNumber = 0, pageSize = 10)
#'
#' @export listCohorts
#'
library(httr)

listCohorts <- function(baseUrl, apikey, workspaceId, cohortId=NULL, pageNumber = 0, pageSize = 10 ){
  url = paste(baseUrl,"api/v1/cohort", sep="/")
  if(is.null(cohortId)){
    newUrl = url
    res <- content(GET(newUrl, add_headers(apikey = apikey),query = list(teamId = workspaceId, pageNumber = pageNumber, pageSize = pageSize)))
  } else {
    newUrl = paste(url,cohortId, sep="/")
    res <- content(GET(newUrl, add_headers(apikey = apikey),query = list(teamId = workspaceId)))
  }

  if(is.null(cohortId)){
    cohort <- res
    output <- as.data.frame.list(unlist(cohort))
    result <- output[c("X_id", "name", "owner$name", "description", "numberOfParticipants", "numberOfFilters")]
    colnames(result) <- c("id", "name", "owner name", "description", "# of Participants", "# of Filters")
  } else {
    output <- as.data.frame(res)
    result <- output[c("X_id", "name", "description")]
    colnames(result) <- c("id", "name", "description")
  }

  rm(res)
  rm(output)
  return(result)
}
