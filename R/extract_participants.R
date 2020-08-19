#' @title Extract participants
#'
#' @description Extracts selected participants.
#'
#' @param base_url Base URL of the CloudOS server. (Required)
#' @param auth  An authentication method. (Required)
#' Example - Bearer token or API key.
#' @param raw_data A JSON string for selected participants. (Required)
#'
#' @return A dataframe.
#'
#' @examples
#' \dontrun{
#' extract_participants(base_url= "https://cloudos.lifebit.ai",
#'              auth = "Bearer ***token***",
#'              raw_data = "a JSON string for selected participants")
#' }
#' @export
extract_participants <- function(base_url, auth, raw_data) {
  url <- paste(base_url, "api/v1/cohort/participants/export", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = auth,
                                                 "accept" = "*/*",
                                                 "content-type" = "application/json")),
                  body = raw_data,
                  encode = "json"
        )
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  }
  # parse the content
  res <- httr::content(r, as = "text")
  df <- utils::read.csv(textConnection(res))
  return(df)
}
