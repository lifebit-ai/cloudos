#' @title List available filters
#'
#' @description All the cohort filters available in CloudOS.
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}} 
#' @param term A term to search. (Required)
#' Example - "cancer"
#'
#' @return A data frame with available cohort filters.
#'
#' @examples
#' \dontrun{
#' search_filters(cloudos_object,
#'              term = "male")
#' }
#' @export
search_filters <- function(object,
                           term){
  url <- paste(object@base_url, "api/v1/cohort/fields_search", sep = "/")
  r <- httr::GET(url,
                 httr::add_headers("Authorization" = object@auth),
                 query = list("teamId" = object@team_id,
                              "term" = term))
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  } else {
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
  }
}


#' @title Filter a cohort samples
#'
#' @description This filters cohort samples based on particular phenotypic filter. 
#' This will return number of samples after phenotype filter applied to a cohort.
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}} 
#' @param cohort_id A cohort ID. (Required)
#' @param filter_id A filter ID. (Required)
#'
#' @return A data frame with filters applied.
#'
#' @export
filter_samples <- function(object, cohort_id, filter_id ) {
  # prepare request body
  # TODO: remove the hard-coded filters
  r_body <- list("filter" = list("instances" = c(0)),
                 "moreFilters" = list("fieldId" = filter_id,
                                      "instance" = c(0),
                                      "value" = c(-3,0)
                                  ),
                 "cohortId" = cohort_id
                 )
  # make request
  url <- paste(object@base_url, "api/v1/cohort/filter", filter_id, "data", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = object@auth,
                                                 "Accept" = "application/json, text/plain, */*",
                                                 "Content-Type" = "application/json;charset=UTF-8")),
                  query = list("teamId" = object@team_id),
                  body = jsonlite::toJSON(r_body),
                  encode = "raw"
  )
  if (!r$status_code == 200) {
    stop("Something went wrong. Not able to create a cohort")
  }
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  res_df <- do.call(rbind, res)
  return(res_df)
}

##################################################################################################
#' @title Filter participants
#'
#' @description This sums up all the filters and return number participants after applied filter.
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}} 
#' @param cohort_id A cohort ID. (Required)
#' @param filter_id A filter ID. (Required)
#'
#' @return A data frame with filters applied.
#'
#' @export
filter_participants <-function(object, cohort_id, filter_id ) {
  # prepare request body
  # TODO: remove the hard-coded filters
  r_body <- list("moreFilters" = list(list("fieldId" = filter_id,
                                           "instance" = c(0),
                                           "value" = c(-3,0)
  )
  ),
  "cohortId" = cohort_id
  )
  # make request
  url <- paste(object@base_url, "api/v1/cohort/filter/participants", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = object@auth,
                                                 "Accept" = "application/json, text/plain, */*",
                                                 "Content-Type" = "application/json;charset=UTF-8")),
                  query = list("teamId" = object@team_id),
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
#' @title Genotypic save
#'
#' @description applies filter (genotypic-save). Returns df with cohort and filtered participants
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}} 
#' @param cohort_id A cohort ID. (Required)
#' @param filter_id A filter ID. (Required)
#'
#' @return A data frame.
#'
#' @export
genotypic_save <- function(object, cohort_id, filter_id ) {
  # prepare request body
  r_body <- list("ids" = list(),
                 "moreFilters" = list(list("fieldId" = filter_id,
                                           "instance" = c(0),
                                           "value" = c(-3)
                 )
                 ),
                 "cohortId" = cohort_id
  )
  # make request
  url <- paste(object@base_url, "api/v1/cohort/genotypic-save", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = object@auth,
                                                 "Accept" = "application/json, text/plain, */*",
                                                 "Content-Type" = "application/json;charset=UTF-8")),
                  query = list("teamId" = object@team_id),
                  body = jsonlite::toJSON(r_body),
                  encode = "raw"
  )
  if (!r$status_code == 200) {
    stop("Something went wrong. Not able to create a cohort")
  }
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  res_df <- do.call(rbind, res)
  return(res_df)
}

#' @title Filter metadata
#'
#' @description Filter metadata of a cohort filter
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}} 
#' @param filter_id A filter ID. (Required)
#'
#' @return A data frame.
#'
#' @export
filter_metadata <- function(object, filter_id) {
  url <- paste(object@base_url, "api/v1/cohort/filter", filter_id, "metadata", sep = "/")
  r <- httr::GET(url,
                 httr::add_headers("Authorization" = object@auth),
                 query = list("teamId" = object@team_id)
  )
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  }
  # parse the content
  res <- httr::content(r)
  res_df <- as.data.frame(do.call(cbind, res))
  return(res_df)
}
