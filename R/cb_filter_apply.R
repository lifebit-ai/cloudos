# converts the CBv2 style cohort@query data into CBv1 style query JSON
# this is very similar but not quite the same as .get_search_json()
.query_body_to_v1 <- function(query) {
  
  invisible(.check_operators(query))
  
  filter_list <- list()
  
  unnested <- .unnest_query(query)
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


# takes a single int ID or a vector of int IDs and builds 
# a JSON array for use in cb_apply_query()
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


# takes any CB v2 query and recursively looks for subqueries where an
# AND/OR operator is applied to a single condition and removes the operator. 
# When calling this function, starting_depth should be left as default (0). Its
# value is updated during recursion
.extract_single_nodes <- function(x, starting_depth = 0){
  
  starting_depth <- starting_depth + 1
  
  if(!is.list(x)) return(x)
  
  if(
    starting_depth > 1 &
    !is.null(x$operator) & 
    !identical(x$operator, "NOT") & 
    length(x$queries) == 1
  ) return(.extract_single_nodes(x$queries[[1]], starting_depth))
  
  lapply(x, .extract_single_nodes, starting_depth)
  
}


#### find non-AND operators
.check_operators <- function(x){
  
  if(!is.list(x)){return(NULL)}
  
  if(
    !is.null(x$operator) &
    !identical(x$operator, "AND")
  ) {stop("Only AND operators are allowed in CB v1")}
  
  lapply(x, .check_operators)
  
}


#' @title Apply a query to a cohort
#'
#' @description Updates a cohort by applying a new query.
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param simple_query A phenotype query using the "simple query" list structure (see example).
#' @param adv_query A phenotype query using the "advanced query" nested list structure (see example). 
#'   Advanced queries can include logical operators: 'AND', 'OR', 'NOT'.
#' @param column_ids Phenotype IDs to be added as columns in the participant table.
#' @param keep_query If True, combines the newly supplied query with the pre-existing query.
#'   Otherwise, pre-existing query is overwritten. (Default: TRUE)
#' @param keep_columns If True, pre-existing columns are retained and newly supplied columns are added.
#'   Otherwise, pre-exisitng columns are overwritten. (Default: TRUE)
#' 
#' @return A confirmation string.
#' 
#' @examples
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd", cb_version = "v1")
#' cb_apply_query(my_cohort,
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
#' cb_apply_query(my_cohort, adv_query = adv_query)
#' 
#'}
#'
#' @export
cb_apply_query <- function(cohort, 
                           query = list(),
                           column_ids = list(),
                           keep_query = TRUE,
                           keep_columns = TRUE){
  
  if (cohort@cb_version == "v1"){
    .check_operators(query)
    return(.cb_apply_query_v1(cohort = cohort,
                              query = query,
                              column_ids = column_ids,
                              keep_query = keep_query,
                              keep_columns = keep_columns))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_apply_query_v2(cohort = cohort,
                              query = query,
                              column_ids = column_ids,
                              keep_query = keep_query,
                              keep_columns = keep_columns))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}


.cb_apply_query_v1 <- function(cohort, 
                               query,
                               column_ids,
                               keep_query = TRUE,
                               keep_columns = TRUE) {
  
  # cohort columns
  all_columns <- c()
  if (!missing(column_ids)) {
    all_columns <- .build_column_body(column_ids)
  }
  if (keep_columns) {
    existing_ids <- sapply(cohort@columns, function(col){col$field$id})
    existing_columns <- .build_column_body(existing_ids)
    all_columns <- c(existing_columns, all_columns)
  }

  if (!identical(query, list())) {
    if (is.null(query$operator)){ 
      query <- list(operator = "AND", queries = list(query))
    }
    if (keep_query & !identical(cohort@query, list())) {
      query <- query & structure(cohort@query, class = "cbQuery")
    }
  } 
  else if (keep_query) {
    query <- structure(cohort@query, class = "cbQuery")
  }
  
  all_filters <- .extract_single_nodes(query) %>%
    .query_body_to_v1
  
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
  return(message("Query applied sucessfully, Current number of Participants - ", res$numberOfParticipants))
}


.cb_apply_query_v2 <- function(cohort, 
                               query,
                               column_ids,
                               keep_query = TRUE,
                               keep_columns = TRUE) {
  
  # cohort columns
  all_columns <- c()
  if (!missing(column_ids)) {
    all_columns <- .build_column_body(column_ids)
  }
  if (keep_columns) {
    existing_ids <- sapply(cohort@columns, function(col){col$field$id})
    existing_columns <- .build_column_body(existing_ids)
    all_columns <- c(existing_columns, all_columns)
  }
  
  if (!identical(query, list())) {
    if (is.null(query$operator)){ 
      query <- list(operator = "AND", queries = list(query))
    }
    if (keep_query & !identical(cohort@query, list())) {
      query <- query & structure(cohort@query, class = "cbQuery")
    }
  } 
  else if (keep_query) {
    query <- structure(cohort@query, class = "cbQuery")
  }
  
  query <- .extract_single_nodes(query)
  
  # get count of particpants if query is applied
  no_participants <- cb_participant_count(cohort,
                                          query = query)
  
  # prepare request body
  r_body <- list(name = cohort@name,
                 description = cohort@desc,
                 columns = all_columns,
                 query = query,
                 type = "advanced",
                 numberOfParticipants = no_participants$count)
  
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
  return(message("Query applied sucessfully."))
}


#' @title Dry run for \code{\link{cb_apply_query}}
#'
#' @description This doesn't update the database but mimics \code{\link{cb_apply_query}}
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param simple_query A phenotype query using the "simple query" list structure (see \code{\link{cb_apply_query}}).
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
  
  .Deprecated("cb_participant_count")
  
  if (cohort@cb_version != "v1") stop("This function is only compatible with Cohort Browser version v1 cohorts.")
  
  # prepare request body
  r_body <- list("moreFilters" = .simple_query_body_v1(simple_query))
  
  # add additional content
  r_body[["ids"]] = list()
  r_body[["cohortId"]] = cohort@id
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v1/cohort/genotypic-save", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = jsonlite::toJSON(r_body, auto_unbox = T),
                  encode = "raw"
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  res_df <- do.call(rbind, res)
  return(res_df)
}
