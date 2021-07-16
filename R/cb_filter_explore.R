#' @title List available filters
#'
#' @description All the cohort filters available in CloudOS.
#'
#' @param term A term to search. (Required)
#' @param cb_version cohort browser version (Optional) [ "v1" | "v2" ]
#' Example - "cancer"
#'
#' @return A data frame with available cohort filters.
#'
#' @examples
#' \dontrun{
#' cb_search_phenotypic_filters(term = "cancer")
#' }
#' @export
cb_search_phenotypic_filters <- function(term, cb_version = "v2") {
  if (cb_version == "v1") {
    return(.cb_search_phenotypic_filters_v1(term))
    
  } else if (cb_version == "v2") {
    return(.cb_search_phenotypic_filters_v2(term))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}

.cb_search_phenotypic_filters_v1 <- function(term){
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v1/cohort/fields_search", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id,
                              "term" = term))
  httr::stop_for_status(r, task = NULL)
  res <- httr::content(r)
  filters <- res$filters
  
  if(length(filters) == 0) stop(message("No phenotypic filters found with - ", term ))
  
  message("Total number of phenotypic filters found - ", length(filters))
  
  # make in to a list
  filters_list <- list()
  for (n in 1:length(filters)) {
    dta <- do.call(cbind, filters[[n]])
    filters_list[[n]] <- as.data.frame(dta)
  }
  filters_df <- dplyr::bind_rows(filters_list)
  # remove mongodb _id column
  filters_df_new <- subset(filters_df, select = (c(-`_id`)))
  return(filters_df_new)
}

.cb_search_phenotypic_filters_v2 <- function(term){
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v2/cohort/fields_search", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id,
                              "term" = term))
  httr::stop_for_status(r, task = NULL)
  res <- httr::content(r)
  filters <- res$filters
  
  if(length(filters) == 0) stop(message("No phenotypic filters found with - ", term ))
  
  message("Total number of phenotypic filters found - ", length(filters))
  
  # make in to a list
  filters_list <- list()
  for (n in 1:length(filters)) {
    dta <- do.call(cbind, filters[[n]])
    filters_list[[n]] <- as.data.frame(dta)
  }
  filters_df <- dplyr::bind_rows(filters_list)
  # remove mongodb _id column
  filters_df_new <- subset(filters_df, select = (c(-`_id`)))
  return(filters_df_new)
}


#' @title Filter a cohort samples
#'
#' @description This filters cohort samples based on particular phenotypic filter. 
#' This will return number of samples after phenotype filter applied to a cohort.
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param filter_id A filter ID. (Required)
#'
#' @return A data frame with filters applied.
#' 
#' @example
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' all_cancer_filters <- cb_search_phenotypic_filters(term = "cancer")
#' my_filter <- all_cancer_filters[,3]
#' 
#' cohort_with_filters <- cb_get_filter_statistics(my_cohort, filter_id = my_filter$id)
#' cohort_with_filters %>% head(n=10)
#' }
#'
#' @export
cb_get_filter_statistics <- function(cohort, filter_id ) {
  # empty moreFilters returns all the filter values associated with a cohort for a filter
  r_body <- list("filter" = list("instances" = c(0)),
                 "moreFilters" = list(),
                 "cohortId" = cohort@id
                 )
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v1/cohort/filter", filter_id, "data", sep = "/")
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
  res_df <- dplyr::bind_rows(res)
  return(res_df)
}

#' @title Get cohort filters
#'
#' @description Get a list of all the filters associated with a cohort. 
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#'
#' @return A list of data frame.
#'
#' @example
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' cb_get_cohort_filters(my_cohort)
#' }
#'
#' @export
cb_get_cohort_filters <- function(cohort){
  # get all the filters dataframe in a single list
  filter_list <- list()
  for(i in 1:length(cohort@more_fields)){
    field_id <- cohort@more_fields[[i]]$fieldId
    filter_list[[as.character(field_id)]] <- cb_get_filter_statistics(cohort = cohort,
                                                            filter_id = field_id)
    # compare with applied filters from cohort and modify the dataframe
    # if(names(cohort@more_fields[[i]][3]) == "value"){
    #   
    # }else if (names(cohort@more_fields[[i]][3]) == "range"){
    #  
    # }else{
    #   stop("Unknown filter type. Accepts 'range' and 'value' only.")
    # }
  }
  return(filter_list)
}

##################################################################################################
#' @title Participant Count
#'
#' @description This sums up all the filters and return number participants after applied filter.
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param simple_query Phenotypic filter query. 
#' @param adv_query Advanced phenotypic filter query (can include logical operators).
#' @param keep_existing_filter Apply newly specified query on top of exisiting query (Default: TRUE)
#'
#' @return A list with count of participants in the cohort and the total no. of participants in the dataset.
#' 
#' @example
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' cb_participant_count(my_cohort, simple_query = list("4"="Male"))
#' }
#'
#' @export
cb_participant_count <-function(cohort,
                                simple_query,
                                adv_query,
                                keep_existing_filter = TRUE) {

  if (cohort@cb_version == "v1"){
    if (!missing(adv_query)) stop("Advanced queries are not compatible with Cohort Browser v1.")
    return(.cb_participant_count_v1(cohort = cohort,
                               simple_query =  simple_query,
                               keep_existing_filter = keep_existing_filter))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_participant_count_v2(cohort = cohort,
                               simple_query =  simple_query,
                               adv_query = adv_query,
                               keep_existing_filter = keep_existing_filter))
        
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}


.cb_participant_count_v1 <-function(cohort,
                                    simple_query,
                                    keep_existing_filter = TRUE) {

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
  r_body <- list("cohortId" = cohort@id,
                 "moreFilters" = all_filters)
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v1/cohort/filter/participants", sep = "/")
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
  #res_df <- do.call(rbind, res)
  return(res)
}


.cb_participant_count_v2 <-function(cohort,
                                    simple_query,
                                    adv_query,
                                    keep_existing_filter = TRUE) {

  if (!missing(adv_query) & !missing(simple_query)) stop("Cannot use advanced and simple queries at the same time.")

  # get new query to apply
  if (!missing(simple_query)) {
    new_query <- .simple_query_body_v2(simple_query)
  } else if (!missing(adv_query)) {
    new_query <- .adv_query_body_v2(adv_query)
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
    r_body <- list("query" = list("operator" = "AND",
                                  "queries" = qs))
    r_body <- jsonlite::toJSON(r_body, auto_unbox = T)
    
  } else if (length(qs) == 1) {
    r_body <- list("query" = qs[[1]])
    r_body <- jsonlite::toJSON(r_body, auto_unbox = T)
    
  } else {
    r_body <- NULL
  }

  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v2/cohort", cohort@id, "filter/participants", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = r_body,
                  encode = "raw"
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  #res_df <- do.call(rbind, res)
  return(res)
}


#####################################################################################################
#' @title Filter metadata
#'
#' @description Filter metadata of a cohort filter
#'
#' @param filter_id A filter ID. (Required)
#'
#' @return A data frame.
#' 
#' @example
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' all_cancer_filters <- cb_search_phenotypic_filters(term = "cancer")
#' my_filter <- all_cancer_filters[,3]
#' 
#' cb_filter_metadata(my_filter$id)
#' }
#'
#' @export
cb_filter_metadata <- function(filter_id) {
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v1/cohort/filter", filter_id, "metadata", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id)
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  res_df <- as.data.frame(do.call(cbind, res))
  # remove mongodb _id column
  res_df_new <- subset(res_df, select = (c(-`_id`)))
  return(res_df_new)
}
