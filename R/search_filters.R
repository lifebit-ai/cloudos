#' @title List available filters
#'
#' @description All the cohort filters available in CloudOS.
#'
#' @param base_url Base URL of the CloudOS server. (Required)
#' @param auth  An authentication method. (Required)
#' Example - Bearer token or API key.
#' @param team_id Team ID in CloudOS account. (Required)
#' @param term A term to search. (Required)
#' Example - "male"
#'
#' @return A data frame with available cohort filters.
#'
#' @examples
#' \dontrun{
#' search_filters(base_url= "https://cloudos.lifebit.ai",
#'              auth = "Bearer ***token***",
#'              team_id = "***team_id***",
#'              term = "male")
#' }
#' @export
search_filters <- function(base_url,
                           auth,
                           team_id,
                           term){
  url <- paste(base_url, "api/v1/cohort/fields_search", sep = "/")
  r <- httr::GET(url,
                 httr::add_headers("Authorization" = auth),
                 query = list("teamId" = team_id,
                              "term" = term))
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  } else {
    res <- httr::content(r)
    filters <- res$filters
    message("Total number of filters - ", length(filters))
    # make in to a list
    filters_list <- list()
    for (n in 1:length(filters)) {
      dta <- do.call(cbind, filters[[n]])
      filters_list[[n]] <- as.data.frame(dta)
    }
    filters_df <- dplyr::bind_rows(filters_list)
  }
}
