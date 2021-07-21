# 5 helper functions below. Each converts the different structures of 
# query data into either CBv1 or CBv2 query JSONs for use in cb_apply_filter()

# converts a simple query into CBv1 style query JSON
.simple_query_body_v1 <- function(simple_query) {
  filter_list <- list()
  
  for(n in seq_len(length(simple_query))){
    
    filter <- simple_query[[n]]
    filter_id <- as.numeric(names(simple_query)[n])
    
    if(is.list(filter)){
      # # filter has a range
      f <- list("fieldId" = filter_id,
                "instance" = list("0"),
                "range" = list(
                  "from" = filter$from,
                  "to" = filter$to
                ))
      filter_list <- c(filter_list, list(f))
      
    } else {
      # filter has values not range
      f <- list("fieldId" = filter_id,
                "instance" = list("0"),
                "value" =  c(list(),filter))
      filter_list <- c(filter_list, list(f))
    }
  }
  
  return(filter_list)
}


# converts the CBv2 style cohort@query data into CBv1 style query JSON
# this is very similar but not quite the same as .get_search_json()
.existing_query_body_v1 <- function(cohort) {
  filter_list <- list()
  
  unnested <- .unnest_query(cohort@query)
  for (filter in unnested){
    
    if (!is.null(filter$value$from)){
      # filter has a range
      f <- list("fieldId" = filter$field,
                "instance" = filter$instance,
                "range" = list(
                  "from" = filter$value$from,
                  "to" = filter$value$to
                ))
      filter_list <- c(filter_list, list(f))
      
    } else if (!is.null(filter$value)){
      # filter has values but not a range
      f <-list("fieldId" = filter$field,
               "instance" = filter$instance,
               "value" = filter$value)
      filter_list <- c(filter_list, list(f))
    }
  }
  
  return(filter_list)
}


# converts a simple query into CBv2 style query JSON
# conversion is achieved by creating a nested series of AND nodes (similar to .v1_query_to_v2())
.simple_query_body_v2 <- function(simple_query) {
  andop <- list("operator" = "AND",
                "queries" = list())
  
  l <- length(simple_query)
  query <- list()
  
  if (l > 0){
    query <- andop
    query$queries <- list(list("field" = as.numeric(names(simple_query)[l]),
                               "instance" = list("0"),
                               "value" = c(list(), simple_query[[l]])))
  }
  
  if (l > 1){
    query$queries <- list(list("field" = as.numeric(names(simple_query)[l-1]),
                               "instance" = list("0"),
                               "value" = c(list(), simple_query[[l-1]])),
                          query$queries[[1]])
  }
  
  if (l > 2){
    for (i in (l-2):1){
      new_query <- andop
      new_query$queries <- list(list("field" = as.numeric(names(simple_query)[i]),
                                     "instance" = list("0"),
                                     "value" = c(list(), simple_query[[i]])),
                                query)
      query <- new_query
    }
  }
  
  return(query)
}


# converts an advanced query into CBv2 style query JSON
.adv_query_body_v2 <- function(adv_query) {
  # recursive function to reformat adv_query list into an api compliant query
  reformat <- function(filter){
    # TODO add error checking for operator type
    if (is.null(filter$queries)){
    filter <- list("field" = filter$id,
              "instance" = list("0"),
              "value" = c(list(), filter$value))
    return(filter)
    
    } else {
    filter$queries <- lapply(filter$queries, reformat)
    return(filter)
    
    }
  }
  
  query <- reformat(adv_query)
  return(query)
}


# created as a function for consistency 
.existing_query_body_v2 <- function(cohort) {
  return(cohort@query)
}


# takes a single int ID or a vector of int IDs and builds 
# a JSON array for use in cb_apply_filter()
.build_column_body <- function(column_ids) {
  column_body_all <- c()
  for(id in column_ids){
    column_body_temp <- list("id" = id,
                             "instance" = "0",
                             "array" = list("type" = "exact",
                                            "value" = 0))
    column_body_all <- c(column_body_all, list(column_body_temp))
  }
  return(column_body_all)
}

.extract_single_nodes <- function(x, starting_depth = 0){
  
  starting_depth <- starting_depth + 1
  
  if(!is.list(x)) return(x)
  
  if(!is.null(x$operator) & ifelse(is.null(x$operator), "", x$operator) != "NOT" & length(x$queries) == 1 & starting_depth > 1) return(x$queries[[1]])
  
  lapply(x, .extract_single_nodes, starting_depth)
  
}

#' @title Apply a Filter
#'
#' @description Applies filter and updates/saves the cohort from database.
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param simple_query Phenotypic filter query. 
#' @param adv_query Advanced phenotypic filter query (can include logical operators).
#' @param column_ids Filter IDs as column in the table
#' @param keep_existing_filter If wants to keep existing filters (Default: TRUE)
#' @param keep_existing_columns If wants to keep existing columns (Default: TRUE)
#' 
#' @return A confirmation string.
#' 
#' @examples
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd", cb_version = "v1")
#' cb_apply_filter(my_cohort,
#'                 simple_query = list("22" = list("from" = "2015-05-13", "to" = "2016-04-29"),
#'                                     "50" = c("Father", "Mother")) )
#' 
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd", cb_version = "v2")
#' adv_query <- list(
#'   "operator" = "AND",
#'   "queries" = list(
#'     list( "id" = 22, "value" = list("from"="2015-05-13", "to"="2016-04-29")),
#'     list(
#'       "operator" = "OR",
#'       "queries" = list(
#'         list("id" = 32, "value" = c("Cancer", "Rare Diseases")),
#'         list("id" = 14, "value" = "Yes")
#'       )
#'     )
#'   )
#' )
#' cb_apply_filter(my_cohort, adv_query = adv_query)
#' 
#'}
#'
#' @export
cb_apply_filter <- function(cohort, 
                            simple_query,
                            adv_query,
                            column_ids,
                            keep_existing_filter = TRUE,
                            keep_existing_columns = TRUE){
  
  if (cohort@cb_version == "v1"){
    if (!missing(adv_query)) stop("Advanced queries are not compatible with Cohort Browser v1.")
    return(.cb_apply_filter_v1(cohort = cohort,
                               simple_query =  simple_query,
                               column_ids = column_ids,
                               keep_existing_filter = keep_existing_filter,
                               keep_existing_columns = keep_existing_columns))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_apply_filter_v2(cohort = cohort,
                               simple_query =  simple_query,
                               adv_query = adv_query,
                               column_ids = column_ids,
                               keep_existing_filter = keep_existing_filter,
                               keep_existing_columns = keep_existing_columns))
        
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}


.cb_apply_filter_v1 <- function(cohort, 
                            simple_query,
                            column_ids,
                            keep_existing_filter = TRUE,
                            keep_existing_columns = TRUE) {
  
  # cohort columns
  all_columns <- list()
  if(!missing(column_ids)){
    all_columns <- .build_column_body(column_ids)
  }
  if(keep_existing_columns){
    existing_ids <- sapply(cohort@columns, function(col){col$field$id})
    existing_columns <- .build_column_body(existing_ids)
    all_columns <- c(existing_columns, all_columns)
  }
  
  # cohort filters
  all_filters <- list()
  if(keep_existing_filter){
    existing_filters <- .existing_query_body_v1(cohort)
    all_filters <- c(all_filters, existing_filters)
  }
  
  if(!missing(simple_query)){
    simple_q_filters <- .simple_query_body_v1(simple_query)
    all_filters <- c(all_filters, simple_q_filters)
  }
  
  # prepare request body
  r_body <- list("columns" = all_columns,
                 "moreFilters" = all_filters)

  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v1/cohort", cohort@id, "filters", sep = "/")
  r <- httr::PUT(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = jsonlite::toJSON(r_body, auto_unbox = T),
                  encode = "raw"
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  return(message("Filter applied sucessfully, Current number of Participants - ", res$numberOfParticipants))
}


.cb_apply_filter_v2 <- function(cohort, 
                            simple_query,
                            adv_query,
                            column_ids,
                            keep_existing_filter = TRUE,
                            keep_existing_columns = TRUE) {
  
  if (!missing(adv_query) & !missing(simple_query)) stop("Cannot use advanced and simple queries at the same time.")
  
  # cohort columns
  all_columns <- c()
  if (!missing(column_ids)) {
    all_columns <- .build_column_body(column_ids)
  }
  if (keep_existing_columns) {
    existing_ids <- sapply(cohort@columns, function(col){col$field$id})
    existing_columns <- .build_column_body(existing_ids)
    all_columns <- c(existing_columns, all_columns)
  }
  
  
  # prepare request body
  r_body <- list("name" = cohort@name,
                 "description" = cohort@desc,
                 "columns" = all_columns)
  
  # cohort query
  
  # get new query to apply
  if (!missing(simple_query)) {
    new_query <- .simple_query_body_v2(simple_query)
    r_body$type <- "advanced"
  } else if (!missing(adv_query)) {
    new_query <- .adv_query_body_v2(adv_query)
    r_body$type <- "advanced"
  } else {
    new_query <- list()
  }
  
  if (keep_existing_filter) {
    existing_query <- .existing_query_body_v2(cohort)
  } else {
    existing_query <- list()
  }
  
  # combine queries depending on whether they are empty or not
  qs <- list(existing_query, new_query)
  qs <- qs[lapply(qs, length) > 0]
  
  # add query to r_body if appropriate
  if (length(qs) == 2) {
    r_body$query <- list("operator" = "AND",
                         "queries" = qs)
      
  } else if (length(qs) == 1) {
    r_body$query <- qs[[1]]
      
  }
  
  r_body$query <- .extract_single_nodes(r_body$query)

  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v2/cohort", cohort@id, sep = "/")
  r <- httr::PUT(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = jsonlite::toJSON(r_body, auto_unbox = T),
                  encode = "raw"
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  return(message("Filter applied sucessfully."))
}



#' @title Dry run for \code{\link{cb_apply_filter}}
#'
#' @description This doesn't update the database but mimic \code{\link{cb_apply_filter}}
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param simple_query Phenotypic filter query. 
#'
#' @return A data frame.
#' 
#' @examples
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' cb_apply_filter_dry_run(my_cohort,
#'                         simple_query = list("22" = list("from" = "2015-05-13", "to" = "2016-04-29"),
#'                                             "50" = c("Father", "Mother")) )
#'}
#'
#' @export
cb_apply_filter_dry_run <- function(cohort, simple_query) {
  # prepare request body
  r_body <- list("moreFilters" = .build_filter_body(simple_query))

  # add additional content
  r_body[["ids"]] = list()
  r_body[["cohortId"]] = cohort@id

  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v1/cohort/genotypic-save", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
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
