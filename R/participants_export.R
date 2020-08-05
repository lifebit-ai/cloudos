#' @title Extract participants
#'
#' @description Extracts selected participants.
#'
#' @param baseurl Base URL of the CloudOS server. Required
#' @param auth  An authontication token. Example - Bearer token. Required
#' @param apikey A API key. Required if auth not provided.
#' @param data_raw A body for selected participants
#'
#' @return Ideally a dataframe.
#'
# @examples 
# list_cohorts(baseurl= "https://cloudos.lifebit.ai", 
#              auth = "Bearer ***token***",
#              data_raw = "a string of inputs. This will be updated.")
#'
#' @export
participants_export <- function(baseurl, 
                                auth, 
                                apikey,
                                data_raw){
  url = paste(baseurl,"api/v1/cohort/participants/export", sep="/")
  r <- httr::POST(url, 
                  httr::add_headers(.headers = c('Authorization' = auth,
                                           'accept' = '*/*',
                                           'content-type' = 'application/json')), 
                  body = data_raw,
                  encode = "json"
        )
  res <- httr::content(r)
  res_list <- xml2::as_list(res)
  table <- res_list$html
  return(table)
}
