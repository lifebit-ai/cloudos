# example 
# for a range filter 
# .build_filter_body(filter_query = list("22" = list("from" = "2015-05-13", "to" = "2016-04-29")))
# for a value filter 
# .build_filter_body(filter_query = list ("50" = c("Father", "Mother")))
# for multiple filters 
# .build_filter_body(filter_query = list("22" = list("from" = "2015-05-13", "to" = "2016-04-29"), "50" = c("Father", "Mother")))

.build_filter_body <- function(filter_query) {
  
  filter_list_all <- c()
  for(n in 1:length(filter_query)){
    filter <- filter_query[[n]]
    filter_id <- as.numeric(names(filter_query)[n])
    if(is.list(filter)){
      #print("range")
      filter_list <- list(list("fieldId" = jsonlite::unbox(filter_id),
                                                    "instance" = c(0),
                                                    "range" = list("from" = jsonlite::unbox(filter$from),
                                                                   "to" = jsonlite::unbox(filter$to)
                                                    )))
      }
    if(!is.list(filter)){
      #print("value")
      filter_list <- list(list("fieldId" = jsonlite::unbox(filter_id),
                                                    "instance" = c(0),
                                                    "value" = filter
      ))
      }
    filter_list_all <- c(filter_list_all, filter_list)
  }
  
  filter_body <- list("moreFilters" = filter_list_all)
  return(filter_body)
}

#' @title Apply a Filter
#'
#' @description Applies filter and updates/saves the cohort from database.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param filter_query Phenotypic filter query. 
#' 
#' @return A confirmation string.
#' 
#' @examples
#' \dontrun{
#' cb_apply_filter(cloudos = my_cloudos,
#'                cohort = my_cohort,
#'                filter_query = list("22" = list("from" = "2015-05-13", "to" = "2016-04-29"), "50" = c("Father", "Mother")))
#'
#' @export
cb_apply_filter <- function(cloudos, cohort, filter_query) {
  # prepare request body
  r_body <- .build_filter_body(filter_query)

  # make request
  url <- paste(cloudos@base_url, "v1/cohort", cohort@id, "filters", sep = "/")
  r <- httr::PUT(url,
                  .get_httr_headers(cloudos@auth),
                  query = list("teamId" = cloudos@team_id),
                  body = jsonlite::toJSON(r_body),
                  encode = "raw"
  )
  stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  return(message("Filtter applied sucessfully, Current number of Participants - ", res$numberOfParticipants))
}

#' @title Dry run for \code{\link{cb_apply_filter}}
#'
#' @description This doesn't update the database but mimic \code{\link{cb_apply_filter}}
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param filter_query Phenotypic filter query. 
#'
#' @return A data frame.
#' 
#' @examples
#' \dontrun{
#' cb_apply_filter_dry_run(cloudos = my_cloudos,
#'                cohort = my_cohort,
#'                filter_query = list("22" = list("from" = "2015-05-13", "to" = "2016-04-29"), "50" = c("Father", "Mother")))
#'
#' @export
cb_apply_filter_dry_run <- function(cloudos, cohort, filter_query) {
  # prepare request body
  r_body <- .build_filter_body(filter_query)

  # add additional content
  r_body[["ids"]] = list()
  r_body[["cohortId"]] = cohort@id

  # make request
  url <- paste(cloudos@base_url, "v1/cohort/genotypic-save", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos@auth),
                  query = list("teamId" = cloudos@team_id),
                  body = jsonlite::toJSON(r_body),
                  encode = "raw"
  )
  stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  res_df <- do.call(rbind, res)
  return(res_df)
}