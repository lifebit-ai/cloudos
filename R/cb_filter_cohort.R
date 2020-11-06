#' @title List available filters
#'
#' @description All the cohort filters available in CloudOS.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param term A term to search. (Required)
#' Example - "cancer"
#'
#' @return A data frame with available cohort filters.
#'
#' @examples
#' \dontrun{
#' cb_search_phenotypic_filters(cloudos,
#'              term = "cancer")
#' }
#' @export
cb_search_phenotypic_filters <- function(cloudos,
                           term){
  url <- paste(cloudos@base_url, "v1/cohort/fields_search", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos@auth),
                 query = list("teamId" = cloudos@team_id,
                              "term" = term))
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  }
  res <- httr::content(r)
  filters <- res$filters
  message("Total number of filters - ", length(filters))
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
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param filter_id A filter ID. (Required)
#'
#' @return A data frame with filters applied.
#'
#' @export
cb_get_filter_statistics <- function(cloudos, cohort, filter_id ) {
  # empty moreFilters returns all the filter values associated with a cohort for a filter
  r_body <- list("filter" = list("instances" = c(0)),
                 "moreFilters" = list(),
                 "cohortId" = cohort@id
                 )
  # make request
  url <- paste(cloudos@base_url, "v1/cohort/filter", filter_id, "data", sep = "/")
  r <- httr::POST(url,
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
  # into a dataframe
  res_df <- dplyr::bind_rows(res)
  return(res_df)
}

#' @title Get cohort filters
#'
#' @description Get a list of all the filters associated with a cohort. 
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#'
#' @return A list of data frame.
#'
#' @export
cb_get_cohort_filters <- function(cloudos, cohort){
  # get all the filters dataframe in a single list
  filter_list <- list()
  for(i in 1:length(cohort@more_fields)){
    field_id <- cohort@more_fields[[i]]$fieldId
    filter_list[[as.character(field_id)]] <- cb_get_filter_statistics(cloudos = cloudos,
                                                            cohort = cohort,
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
#' @title Filter participants
#'
#' @description This sums up all the filters and return number participants after applied filter.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param filter_id A filter ID. (Required)
#'
#' @return A data frame with filters applied.
#'
#' @export
cb_filter_participants <-function(cloudos, cohort, filter_id ) {
  # prepare request body
  # TODO: remove the hard-coded filters
  r_body <- list("moreFilters" = list(list("fieldId" = filter_id,
                                           "instance" = c(0),
                                           "value" = c(-3,0)
  )
  ),
  "cohortId" = cohort@id
  )
  # make request
  url <- paste(cloudos@base_url, "v1/cohort/filter/participants", sep = "/")
  r <- httr::POST(url,
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
  # into a dataframe
  #res_df <- do.call(rbind, res)
  return(res)
}
#####################################################################################################
#' @title Filter metadata
#'
#' @description Filter metadata of a cohort filter
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param filter_id A filter ID. (Required)
#'
#' @return A data frame.
#'
#' @export
cb_filter_metadata <- function(cloudos, filter_id) {
  url <- paste(cloudos@base_url, "v1/cohort/filter", filter_id, "metadata", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos@auth),
                 query = list("teamId" = cloudos@team_id)
  )
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  }
  # parse the content
  res <- httr::content(r)
  res_df <- as.data.frame(do.call(cbind, res))
  # remove mongodb _id column
  res_df_new <- subset(res_df, select = (c(-`_id`)))
  return(res_df_new)
}
