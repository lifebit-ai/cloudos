#' @title Apply a Filter
#'
#' @description Applies filter and updates/saves the cohort from database.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param filter_id A filter ID. (Required)
#' @param filter_range A two element vector of filter with start and end.
#' @param filter_values A vector of filter values.
#'
#' @return A data frame.
#'
#' @export
cb_apply_filter <- function(cloudos, cohort, filter_id, filter_range, filter_values) {
  
  # prepare request body
  if (!missing(filter_values)){
    r_body <- list("moreFilters" = list(list("fieldId" = jsonlite::unbox(filter_id),
                                             "instance" = c(0),
                                             "value" = filter_values
                                             )
                                        )
                   )
  }
  if (!missing(filter_range)){
    r_body <- list("moreFilters" = list(list("fieldId" = jsonlite::unbox(filter_id),
                                             "instance" = c(0),
                                             "range" = list("from" = jsonlite::unbox(filter_range[1]),
                                                            "to" = jsonlite::unbox(filter_range[2])
                                                            )
                                             )
                                        )
                   )
  }
  if (missing(filter_values) && missing(filter_range)){
    r_body <- list("moreFilters" = list(list("fieldId" = jsonlite::unbox(filter_id),
                                             "instance" = c(0),
                                             "value" = "")
                                        )
                   )
  }
  
  
  # make request
  url <- paste(cloudos@base_url, "v1/cohort", cohort@id, "filters", sep = "/")
  r <- httr::PUT(url,
                  .get_httr_headers(cloudos@auth),
                  query = list("teamId" = cloudos@team_id),
                  body = jsonlite::toJSON(r_body),
                  encode = "raw"
  )
  if (!r$status_code == 200) {
    stop("Something went wrong. Not able to create a cohort")
  }
  # parse the content
  res <- httr::content(r)
  return(message("Filtter applied sucessfully, Current number of Participants - ", res$numberOfParticipants))
}
