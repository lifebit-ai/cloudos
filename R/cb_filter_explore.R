#' @title Search available phenotypes
#'
#' @description Search for phenotypes in the Cohort Browser that match your term and return a tibble
#'   containing the metadata information for each matching phenotype. Use ' term = "" ' to return all
#'   phenotypes.
#' 
#' @param term A term to search. (Required)
#' @param cb_version cohort browser version (Optional) \[ "v1" | "v2" \]
#'
#' @return A tibble with phenotype metadata
#'
#' @examples
#' \dontrun{
#' cancer_phenos <- cb_search_phenotypes(term = "cancer")
#' 
#' all_phenos <- cb_search_phenotypes(term = "")
#' }
#' 
#' 
#' @export
cb_search_phenotypes <- function(term, cb_version = "v2") {
  if (cb_version == "v1") {
    return(.cb_search_phenotypes_v1(term))
    
  } else if (cb_version == "v2") {
    return(.cb_search_phenotypes_v2(term))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}

.cb_search_phenotypes_v1 <- function(term){
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v1/cohort/fields_search", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id,
                              "term" = term))
  res <- httr::content(r, simplifyVector = TRUE, simplifyDataFrame = TRUE)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "search phenotypes")

  filters <- tibble::as_tibble(res$filters)
  
  if(nrow(filters) == 0) stop(message("No phenotypic filters found with - ", term ))
  
  message("Total number of phenotypic filters found - ", nrow(filters))
  
  filters_df_new <- subset(filters, select = (c(-`_id`))) %>% arrange(id) %>%
    select(any_of(c("id", "name", "description", "possibleValues", "array", "type", "valueType", "units")), everything())
  
  return(filters_df_new)
}

.cb_search_phenotypes_v2 <- function(term){
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v2/cohort/fields_search", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id,
                              "term" = term))
  res <- httr::content(r, simplifyVector = TRUE, simplifyDataFrame = TRUE)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "search phenotypes")

  filters <- tibble::as_tibble(res$filters)
  
  if(nrow(filters) == 0) stop(message("No phenotypic filters found with - ", term ))
  
  message("Total number of phenotypic filters found - ", nrow(filters))
  
  filters_df_new <- subset(filters, select = (c(-`_id`))) %>% arrange(id) %>%
    select(any_of(c("id", "name", "description", "possibleValues", "array", "type", "valueType", "units")), everything())
  
  return(filters_df_new)
  
}

.fetch_stats_table_v2 <- function(req_body, pheno_id, iter_all = FALSE) {
  
  page_size <- req_body$criteria$pageSize
  page_number <- req_body$criteria$pageNumber
  if (page_number == 'all') req_body$criteria$pageNumber <- 0
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v2/cohort/filter", pheno_id, "data", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = jsonlite::toJSON(req_body, auto_unbox = T),
                  encode = "raw")
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "get count table for phenotype")
  
  if (is.null(res$data)) {
    # not a paged result
    paged <- FALSE
    res_data <- res
  } else {
    # is a paged result
    paged <- TRUE
    total <- res$total
    res_data <- res$data
  }
  
  if (iter_all & paged) {
    iters <- ceiling(total/page_size) - 1  # we have already fetched page 0
    for (i in seq_len(iters)) {
      req_body$criteria$pageNumber <- i
      req_body$criteria$pageSize <- page_size
      r <- httr::POST(url,
                      .get_httr_headers(cloudos$token),
                      query = list("teamId" = cloudos$team_id),
                      body = jsonlite::toJSON(req_body, auto_unbox = T),
                      encode = "raw")
      res <- httr::content(r)
      
      # check for request error
      if (!is.null(res$message)) message(res$message)
      httr::stop_for_status(r, task = "get count table for phenotype")
      
      res_data <- c(res_data, res$data)
    }
  }
  
  return(res_data)
}


.flatten_nested_phenotype <- function(items, max_depth = Inf, path = list()){
  flat_list <- list()
  for (item in items) {
    full_path <- c(path, item$coding)
    depth <- length(full_path)
    item_l <- list("full_path" = full_path,
                   "id" = item$coding,
                   "value" = item$label,
                   "count" = item$count)
    flat_list <- c(flat_list, list(item_l))
    
    if (length(item$children) > 0 & depth < max_depth) {
      l <- .flatten_nested_phenotype(item$children, max_depth = max_depth, path = full_path)
      flat_list <- c(flat_list, l)
    }
  }
  return(flat_list)
}


#' @title Get distribution of a phenotype in a cohort
#'
#' @description Retrieve a data frame containing the distirbution data for a specific phenotype within a cohort.
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param pheno_id A phenotype ID. (Required)
#' @param max_depth The maximum depth to descend in a 'nested list' phenotype. (Default: Inf)
#' @param page_number For internal use.
#' @param page_size For internal use.
#'
#' @return A data frame holding distribution data.
#' 
#' @example
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' all_cancer_phenos <- cb_search_phenotypes(term = "cancer")
#' my_pheno <- all_cancer_phenos[,3]
#' 
#' my_pheno_data <- cb_get_phenotype_statistics(my_cohort, pheno_id = my_pheno$id)
#' my_pheno_data %>% head(n=10)
#' }
#'
#' @export
cb_get_phenotype_statistics <- function(cohort, pheno_id, max_depth = Inf, page_number = 'all', page_size = 1000 ) {
  if (cohort@cb_version == "v1") {
    return(.cb_get_phenotype_statistics_v1(cohort, pheno_id))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_get_phenotype_statistics_v2(cohort, pheno_id, max_depth = max_depth, page_number = page_number, page_size = page_size))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}


.cb_get_phenotype_statistics_v1 <- function(cohort, pheno_id) {
  
  # make more_filters from cohort@query
  more_filters = list() 
  for (filter in .unnest_query(cohort@query)){
    
    if (!is.null(filter$value$from)){
      # rename field to fieldId and value to range
      names(filter)[names(filter) == "field"] <- "fieldId"
      names(filter)[names(filter) == "value"] <- "range"
      more_filters <- c(more_filters, list(filter))
      
    } else if (!is.null(filter$value)){
      # rename field to fieldId
      names(filter)[names(filter) == "field"] <- "fieldId"
      more_filters <- c(more_filters, list(filter))
    }
  }
  
  r_body <- list("filter" = list("instances" = list("0")),
                 "moreFilters" = more_filters,
                 "cohortId" = cohort@id
  )
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v1/cohort/filter", pheno_id, "data", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = jsonlite::toJSON(r_body, auto_unbox = T),
                  encode = "raw"
  )
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "get count table for phenotype")
  
  # into a dataframe
  res_df <- dplyr::bind_rows(res)
  return(res_df)
}


.cb_get_phenotype_statistics_v2 <- function(cohort, pheno_id, max_depth = Inf, page_number = 'all', page_size = 1000) {
  r_body <- list("criteria" = list("cohortId" = cohort@id,
                                   "pageSize" = page_size,
                                   "pageNumber" = page_number),
                 "filter" = list("instance" = list("0"))
  )
  
  if (length(cohort@query) > 0) r_body$query <- cohort@query
  
  if (page_number == "all") {
    res_data <- .fetch_stats_table_v2(r_body, pheno_id, iter_all = TRUE)
  } else {
    res_data <- .fetch_stats_table_v2(r_body, pheno_id, iter_all = FALSE)
  }
  
  if (is.null(res_data[[1]]$children)) {
    # not nested phenotype
    res_data <- lapply(res_data, function(x){x$`_id` <- as.character(x$`_id`); x})
    res_df <- dplyr::bind_rows(res_data)
    res_df <- dplyr::rename(res_df, value = `_id`, count = number) %>% select(c('value', 'count'))
  } else {
    # nested phenotype
    flat <- .flatten_nested_phenotype(res_data, max_depth = max_depth)
    res_df <- dplyr::bind_rows(lapply(flat, function(x) x[2:4]))
    res_df$full_path <- lapply(flat, function(x) x$full_path)
  }

  return(res_df)
}



#' @title Participant Count
#'
#' @description Returns the number of participants in a cohort if the supplied query were to be applied.
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param query A phenotype query defined using the code{\link{phenotype}} function and logic operators (see example below)
#' @param keep_query Apply newly specified query on top of exisiting query (Default: TRUE)
#'
#' @return A list with count of participants in the cohort and the total no. of participants in the dataset.
#' 
#' @example
#' \dontrun{
#' A <- phenotype(id = 13, from = "2016-01-21", to = "2017-02-13")
#' 
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#'
#' cb_participant_count(my_cohort, query = A, keep_query = T)
#' }
#' @export
cb_participant_count <-function(cohort,
                                query = list(),
                                keep_query = TRUE) {
  
  if(missing(query)) query <- list()
  
  query <- .create_final_query(cohort = cohort, query = query, keep_query = keep_query)

  if (cohort@cb_version == "v1"){
    .check_operators(query)
    return(.cb_participant_count_v1(cohort = cohort,
                                    query = query))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_participant_count_v2(cohort = cohort,
                                    query = query))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}

.cb_participant_count_v1 <-function(cohort,
                                    query) {
  
  all_filters <- .query_body_to_v1(query)
    
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
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "get count of participants")
  
  return(res)
}

.cb_participant_count_v2 <-function(cohort,
                                    query) {
  
  if(identical(query, list())) 
    r_body <- NULL
  else 
    r_body <- jsonlite::toJSON(list(query = query), auto_unbox = T)
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v2/cohort", cohort@id, "filter/participants", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = r_body,
                  encode = "raw"
  )
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "get count of participants")
  
  return(res)
}


#####################################################################################################
#' @title Phenotype metadata
#'
#' @description Get the metadata of a phenotype in the cohort browser
#'
#' @param pheno_id A phenotype ID. (Required)
#' @param cb_version cohort browser version. (Default: "v2") \[ "v1" | "v2" \]
#'
#' @return A data frame.
#' 
#' @example
#' \dontrun{
#' all_cancer_phenos <- cb_search_phenotypes(term = "cancer")
#' my_pheno <- all_cancer_phenos[,3]
#' 
#' cb_get_phenotype_metadata(my_pheno$id)
#' }
#'
#' @export
cb_get_phenotype_metadata <- function(pheno_id, cb_version = "v2") {
  if (cb_version == "v1") {
    return(.cb_get_phenotype_metadata_v1(pheno_id))
    
  } else if (cb_version == "v2") {
    return(.cb_get_phenotype_metadata_v2(pheno_id))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}

.cb_get_phenotype_metadata_v1 <- function(pheno_id) {
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v1/cohort/filter", pheno_id, "metadata", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id)
  )
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "get phenotype metadata")

  res_df <- as.data.frame(do.call(cbind, res))

  # remove mongodb _id column
  res_df_new <- subset(res_df, select = (c(-`_id`)))
  return(res_df_new)
}

.cb_get_phenotype_metadata_v2 <- function(pheno_id) {
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v2/cohort/filter", pheno_id, "metadata", sep = "/")
  r <- httr::GET(url,
                 .get_httr_headers(cloudos$token),
                 query = list("teamId" = cloudos$team_id)
  )
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "get phenotype metadata")

  res_df <- as.data.frame(do.call(cbind, res))
  # remove mongodb _id column
  res_df_new <- subset(res_df, select = (c(-`_id`)))
  return(res_df_new)
}
