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
.remove_single_nodes <- function(x, starting_depth = 0){
  
  starting_depth <- starting_depth + 1
  
  if(!is.list(x)) return(x)
  
  if(
    starting_depth > 1 &
    !is.null(x$operator) & 
    !identical(x$operator, "NOT") & 
    length(x$queries) == 1
  ) return(.remove_single_nodes(x$queries[[1]], starting_depth))
  
  lapply(x, .remove_single_nodes, starting_depth)
  
}

.create_final_query <- function(cohort, 
                                query, 
                                keep_query){
  
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
  
  return(.remove_single_nodes(query))
  
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
#' @param query A phenotype query defined using the \code{\link{phenotype}} function and logic operators (see example below)
#' @param keep_query If True, combines the newly supplied query with the pre-existing query.
#'   Otherwise, pre-existing query is overwritten. (Default: TRUE)
#' 
#' @return The updated cohort object.
#' 
#' @examples
#' \dontrun{
#' A <- phenotype(id = 13, from = "2016-01-21", to = "2017-02-13")
#' B <- phenotype(id = 4, value = "Cancer")
#' 
#' A_not_B <- A & !B
#' 
#' my_cohort <- cb_load_cohort(cohort_id = "612f37a57673ed0ddeaf1333", cb_version = "v2")
#' 
#' my_cohort <- cb_apply_query(my_cohort, query = A_not_B, keep_query = F)
#' }
#' 
#' @export
cb_apply_query <- function(cohort, 
                           query,
                           keep_query = TRUE){
  
  if(missing(query))  stop("Error: query argument must be specified")
      
  if (cohort@cb_version == "v1"){
    .check_operators(query)
    return(.cb_apply_query_v1(cohort = cohort,
                              query = query,
                              keep_query = keep_query))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_apply_query_v2(cohort = cohort,
                              query = query,
                              keep_query = keep_query))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}

.cb_apply_query_v1 <- function(cohort, 
                               query,
                               keep_query = TRUE) {

  query <- .create_final_query(cohort = cohort, query = query, keep_query = keep_query)
  all_filters <- .query_body_to_v1(query) 
  
  col_ids <- sapply(cohort@columns, function(col){col$field$id})
  columns <- .build_column_body(col_ids)

  # prepare request body
  r_body <- list("columns" = columns,
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
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "apply query")
  
  message("Query applied sucessfully, Current number of Participants - ", res$numberOfParticipants)

  return(cb_load_cohort(cohort@id, cb_version = cohort@cb_version))
}

.cb_apply_query_v2 <- function(cohort, 
                               query,
                               keep_query = TRUE) {

  query <- .create_final_query(cohort = cohort, query = query, keep_query = keep_query)

  # get count of particpants if query is applied
  no_participants <- cb_participant_count(cohort, query = query, keep_query = F)
  
  col_ids <- sapply(cohort@columns, function(col){col$field$id})
  columns <- .build_column_body(col_ids)

  # prepare request body
  r_body <- list(name = cohort@name,
                 description = cohort@desc,
                 columns = columns,
                 type = "advanced",
                 numberOfParticipants = no_participants$count)
  
  if(!identical(query, list())) r_body$query <- query
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v2/cohort", cohort@id, sep = "/")
  r <- httr::PUT(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id),
                 body = jsonlite::toJSON(r_body, auto_unbox = T),
                 encode = "raw"
  )
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "apply query")
  
  message("Query applied sucessfully. Current number of Participants - ", no_participants$count)
  
  return(cb_load_cohort(cohort@id, cb_version = cohort@cb_version))
}
