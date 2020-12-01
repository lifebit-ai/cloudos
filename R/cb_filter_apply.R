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
  return(filter_list_all)
}

.get_existing_filter_body <- function(my_cohort_info) {
  
  filter_list_all <- c()
  for(n in 1:length(my_cohort_info$moreFields)){
    more_fields <- my_cohort_info$moreFields[[n]]
    filter_id <- more_fields$fieldId
    if("range" %in% names(more_fields)){
      #print("range")
      filter_list <- list(list("fieldId" = jsonlite::unbox(more_fields$fieldId),
                               "instance" = c(0),
                               "range" = list("from" = jsonlite::unbox(more_fields$range$from),
                                              "to" = jsonlite::unbox(more_fields$range$to)
                               )))
    }
    if("value" %in% names(more_fields)){
      #print("value")
      filter_list <- list(list("fieldId" = jsonlite::unbox(more_fields$fieldId),
                               "instance" = c(0),
                               "value" = unlist(more_fields$value)
      ))
    }
    filter_list_all <- c(filter_list_all, filter_list)
  }
  return(filter_list_all)
}

.build_column_body <- function(column_ids) {
  
  column_body_all <- c()
  for(i in 1:length(column_ids)){
    column_body_temp <- list("id" = jsonlite::unbox(column_ids[i]),
                             "instance" = jsonlite::unbox(0),
                             "array" = list("type" = jsonlite::unbox("exact"),
                                            "value" = jsonlite::unbox(0)))
    column_body_all <- c(column_body_all, list(column_body_temp))
  }
  return(column_body_all)
}

.get_existing_columns_body <- function(my_cohort_info){
  column_body_all <- c()
  for(i in length(my_cohort_info$columns)){
    column_body_temp <- list("id" = jsonlite::unbox(my_cohort_info$columns[[i]]$id),
                             "instance" = jsonlite::unbox(my_cohort_info$columns[[i]]$instance),
                             "array" = list("type" = jsonlite::unbox(my_cohort_info$columns[[i]]$array$type),
                                            "value" = jsonlite::unbox(my_cohort_info$columns[[i]]$array$value)))
    column_body_all <- c(column_body_all, list(column_body_temp))
  }
  return(column_body_all)
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
#' @param column_ids Filter IDs as column in the table
#' @param keep_existing_filter If wants to keep existing filters (Default: TRUE)
#' @param keep_existing_columns If wants to keep existing columns (Default: TRUE)
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
cb_apply_filter <- function(cloudos, 
                            cohort, 
                            filter_query,
                            column_ids,
                            keep_existing_filter = TRUE,
                            keep_existing_columns = TRUE) {
  
  # get info about existing columns and fields
  my_cohort_info <- .get_cohort_info(cloudos = cloudos, cohort_id = cohort@id)
  
  # cohort columns
  all_columns <- c()
  if(!missing(column_ids)){
    all_columns <- .build_column_body(column_ids)
  }
  if(keep_existing_columns){
    existing_columns <- .get_existing_columns_body(my_cohort_info)
    all_columns <- c(existing_columns, all_columns)
  }
  
  # cohort filters
  all_filters <- c()
  if(!missing(filter_query)){
    all_filters <- .build_filter_body(filter_query)
  }
  if(keep_existing_filter){
    existing_filters <- .get_existing_filter_body(my_cohort_info)
    all_filters <- c(existing_filters, all_filters)
  }
  
  # prepare request body
  r_body <- list("columns" = all_columns,
                 "moreFilters" = all_filters)

  # make request
  url <- paste(cloudos@base_url, "v1/cohort", cohort@id, "filters", sep = "/")
  r <- httr::PUT(url,
                  .get_httr_headers(cloudos@auth),
                  query = list("teamId" = cloudos@team_id),
                  body = jsonlite::toJSON(r_body),
                  encode = "raw"
  )
  httr::stop_for_status(r, task = NULL)
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
  r_body <- list("moreFilters" = .build_filter_body(filter_query))

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
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  res_df <- do.call(rbind, res)
  return(res_df)
}