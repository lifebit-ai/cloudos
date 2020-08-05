#' @title Extract participants
#'
#' @description Extracts selected participants.
#'
#' @param baseurl Base URL of the CloudOS server. Required
#' @param auth  An authontication token. Example - Bearer token. Required
#' @param apikey A API key. Required if auth not provided.
#' @param raw_data A JSON string for selected participants.
#'
#' @return Ideally a dataframe.
#'
# @examples 
# extract_participants(baseurl= "https://cloudos.lifebit.ai", 
#              auth = "Bearer ***token***",
#              raw_data = "a JSON string for selected participants")
#'
#' @export
extract_participants <- function(baseurl, 
                                auth, 
                                apikey,
                                raw_data){
  url = paste(baseurl,"api/v1/cohort/participants/export", sep="/")
  r <- httr::POST(url, 
                  httr::add_headers(.headers = c('Authorization' = auth,
                                           'accept' = '*/*',
                                           'content-type' = 'application/json')), 
                  body = raw_data,
                  encode = "json"
        )
  res <- httr::content(r)
  res_list <- xml2::as_list(res)
  table <- res_list$html
  return(table)
}
