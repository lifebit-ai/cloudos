#' @title Extract participants
#'
#' @description Extracts selected participants.
#'
#' @param baseurl Base URL of the CloudOS server. (Required)
#' @param auth  An authentication method. (Required)
#' Example - Bearer token or API key.
#' @param raw_data A JSON string for selected participants. (Required)
#'
#' @return A dataframe.
#'
#' @examples
#' \dontrun{
#' extract_participants(baseurl= "https://cloudos.lifebit.ai",
#'              auth = "Bearer ***token***",
#'              raw_data = "a JSON string for selected participants")
#' }
#' @export
extract_participants <- function(baseurl, auth, raw_data) {
  url <- paste(baseurl, "api/v1/cohort/participants/export", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = auth,
                                           "accept" = "*/*",
                                      "content-type" = "application/json")),
                  body = raw_data,
                  encode = "json"
        )
  if(!r$status_code == 200){
    message("Something went wrong.")
  }else{
    res <- httr::content(r, as = "text")
    df <- utils::read.csv(textConnection(res))
    return(df)
  }
}
