#' @title Extract Genotypic Data
#'
#' @description Extract Genotypic Data with filter.
#'
#' @param base_url Base URL of the CloudOS server. (Required)
#' @param auth  An authentication method. (Required)
#' Example - Bearer token or API key.
#' @param team_id Team ID in CloudOS account. (Required)
#' @param page_number Number of page. (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#' @param filters WIP - details will be added.
#'
#' @return A dataframe.
#'
#' @examples
#' \dontrun{
#' extract_genotypic_data(base_url= "https://cloudos.lifebit.ai",
#'              auth = "Bearer ***token***",
#'              team_id = "***team_id***")
#' }
#' @export
extract_genotypic_data <- function(base_url, auth, team_id,
                               page_number = 0,
                               page_size = 10,
                               filters = "") {
  url <- paste(base_url, "api/v1/cohort/genotypic-data", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = auth,
                                                 "accept" = "application/json, text/plain, */*",
                                                 "content-type" = "application/json;charset=UTF-8")),
                  query = list("team_id" = team_id),
                  body = list("pageNumber" = page_number,
                              "pageSize" = page_size,
                              "filters" = filters),
                  encode = "json"
  )
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  }else{
    res <- httr::content(r)
    return(res$participants)
  }
}
