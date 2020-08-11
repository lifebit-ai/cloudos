#' @title Create Cohort
#'
#' @description Creates a new Cohort
#'
#' @param baseurl Base URL of the CloudOS server. (Required)
#' @param auth  An authentication method. (Required)
#' Example - Bearer token or API key.
#' @param teamid Team ID in CloudOS account. (Required)
#' @param cohort_name New cohort name to be created. (Required)
#' @param cohort_desc New cohort description to be created. (Required)
#' @param filters WIP - details will be added.
#'
#' @return A dataframe.
#'
#' @examples
#' \dontrun{
#' create_cohort(baseurl= "https://cloudos.lifebit.ai",
#'              auth = "Bearer ***token***",
#'              teamid = "***teamid***",
#'              cohort_name = "my cohort",
#'              cohort_desc = "my cohort description")
#' }
#' @export
create_cohort <- function(baseurl, auth, teamid,
                          cohort_name, cohort_desc, filters = "") {
  url <- paste(baseurl, "api/v1/cohort/", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = auth,
                                                 "accept" = "application/json, text/plain, */*",
                                                 "content-type" = "application/json;charset=UTF-8")),
                  query = list("teamId" = teamid),
                  body = list("name" = cohort_name,
                              "description" = cohort_desc,
                              "moreFilters" = filters),
                  encode = "json"
  )
  if(!r$status_code == 200){
    message("Something went wrong. Not able to create a cohort")
  }else{
    message("Cohort named ", cohort_name, " created successfully. Bellow are the details")
    res <- httr::content(r)
    # into a dataframe
    res_df <- do.call(rbind, res)
    colnames(res_df) <- "details"
    return(res_df)
  }
  
}
