#' @title Create Cohort
#'
#' @description Creates a new Cohort
#'
#' @param base_url Base URL of the CloudOS server. (Required)
#' @param auth  An authentication method. (Required)
#' Example - Bearer token or API key.
#' @param team_id Team ID in CloudOS account. (Required)
#' @param cohort_name New cohort name to be created. (Required)
#' @param cohort_desc New cohort description to be created. (Required)
#' @param filters WIP - details will be added.
#'
#' @return A dataframe.
#'
#' @examples
#' \dontrun{
#' create_cohort(base_url= "https://cloudos.lifebit.ai",
#'              auth = "Bearer ***token***",
#'              team_id = "***team_id***",
#'              cohort_name = "my cohort",
#'              cohort_desc = "my cohort description")
#' }
#' @export
create_cohort <- function(base_url, auth, team_id,
                          cohort_name, cohort_desc, filters = "") {
  url <- paste(base_url, "api/v1/cohort/", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = auth,
                                                 "accept" = "application/json, text/plain, */*",
                                                 "content-type" = "application/json;charset=UTF-8")),
                  query = list("team_id" = team_id),
                  body = list("name" = cohort_name,
                              "description" = cohort_desc,
                              "moreFilters" = filters),
                  encode = "json"
  )
  if (!r$status_code == 200) {
    stop("Something went wrong. Not able to create a cohort")
  }else{
    message("Cohort named ", cohort_name, " created successfully. Bellow are the details")
    res <- httr::content(r)
    # into a dataframe
    res_df <- do.call(rbind, res)
    colnames(res_df) <- "details"
    return(res_df)
  }
}
