#' @title Create Cohort
#'
#' @description Creates a new Cohort
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}} 
#' @param cohort_name New cohort name to be created. (Required)
#' @param cohort_desc New cohort description to be created. (Required)
#' @param filters WIP - details will be added.
#'
#' @return A dataframe.
#'
#' @examples
#' \dontrun{
#' create_cohort(cloudos_obj,
#'              cohort_name = "my cohort",
#'              cohort_desc = "my cohort description")
#' }
#' @export
create_cohort <- function(object, cohort_name, cohort_desc, filters = "") {
  url <- paste(object@base_url, "api/v1/cohort/", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = object@auth,
                                                 "accept" = "application/json, text/plain, */*",
                                                 "content-type" = "application/json;charset=UTF-8")),
                  query = list("teamId" = object@team_id),
                  body = list("name" = cohort_name,
                              "description" = cohort_desc, 
                              "moreFilters" = filters), # TODO work on filters
                  encode = "json"
  )
  if (!r$status_code == 200) {
    stop("Something went wrong. Not able to create a cohort")
  }
  # parse the content
  message("Cohort named ", cohort_name, " created successfully.")
  res <- httr::content(r)
  # into a dataframe
  res_df <- do.call(rbind, res)
  colnames(res_df) <- "details"
  return(res_df)
}
