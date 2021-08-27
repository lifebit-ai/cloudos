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
  httr::stop_for_status(r, task = NULL)
  res <- httr::content(r, simplifyVector = TRUE, simplifyDataFrame = TRUE)
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
  httr::stop_for_status(r, task = NULL)
  res <- httr::content(r, simplifyVector = TRUE, simplifyDataFrame = TRUE)
  filters <- tibble::as_tibble(res$filters)
  
  if(nrow(filters) == 0) stop(message("No phenotypic filters found with - ", term ))
  
  message("Total number of phenotypic filters found - ", nrow(filters))
  
  filters_df_new <- subset(filters, select = (c(-`_id`))) %>% arrange(id) %>%
    select(any_of(c("id", "name", "description", "possibleValues", "array", "type", "valueType", "units")), everything())
  
  return(filters_df_new)
  
}


#' @title Get distribution of a phenotype in a cohort
#'
#' @description Retrieve a data frame containing the distirbution data for a specific phenotype within a cohort.
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param pheno_id A phenotype ID. (Required)
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
cb_get_phenotype_statistics <- function(cohort, pheno_id ) {
  if (cohort@cb_version == "v1") {
    return(.cb_get_phenotype_statistics_v1(cohort, pheno_id))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_get_phenotype_statistics_v2(cohort, pheno_id))
    
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
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  res_df <- dplyr::bind_rows(res)
  return(res_df)
}


.cb_get_phenotype_statistics_v2 <- function(cohort, pheno_id) {
  # empty moreFilters returns all the filter values associated with a cohort for a filter
  r_body <- list("criteria" = list("cohortId" = cohort@id),
                 "filter" = list("instance" = list("0"))
  )
  
  if (length(cohort@query) > 0) r_body$query <- cohort@query
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v2/cohort/filter", pheno_id, "data", sep = "/")
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
  res_df <- dplyr::bind_rows(res)
  return(res_df)
}

#' @title Get data for phenotypes associated with a cohort
#'
#' @description Get a dataframe with distirbution data for each phenotype associated with a cohort.
#'   Associated phenotypes are those found in the "Overview" section of the Cohort Browser Web UI.
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#'
#' @return A list of data frames.
#'
#' @example
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' cb_get_cohort_phenotypes(my_cohort)
#' }
#'
#' @export
cb_get_cohort_phenotypes <- function(cohort){
  # get all the filters dataframe in a single list
  filter_list <- list()
  for(filter in cohort@phenoptype_filters){
    field_id <- filter$field$id
    filter_list[[as.character(field_id)]] <- cb_get_phenotype_statistics(cohort = cohort,
                                                                         pheno_id = field_id)
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
#' @description Returns the number of participants in a cohort if the supplied query were to be applied.
#'
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param simple_query A phenotype query using the "simple query" list structure (see \code{\link{cb_apply_query}}).
#' @param adv_query A phenotype query using the "advanced query" nested list structure (see \code{\link{cb_apply_query}}).
#' @param keep_query Apply newly specified query on top of exisiting query (Default: TRUE)
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
                                query = list(),
                                simple_query,
                                adv_query,
                                keep_query = TRUE) {
  
  if(sum(!c(missing(simple_query), missing(adv_query), missing(query))) != 1)
    stop("Use exactly one of query, simple_query, adv_query")
  
  if(!missing(simple_query)){
    warning("argument simple_query deprecated")
    query <- .simple_query_body_v2(simple_query)
  }
  
  if(!missing(adv_query)){
    warning("argument adv_query deprecated")
    query <- .adv_query_body_v2(adv_query)
  }
  
  if (cohort@cb_version == "v1"){
    .check_operators(query)
    return(.cb_participant_count_v1(cohort = cohort,
                                    query = query,
                                    keep_query = keep_query))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_participant_count_v2(cohort = cohort,
                                    query = query,
                                    keep_query = keep_query))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}


.cb_participant_count_v1 <-function(cohort,
                                    query,
                                    keep_query = TRUE) {
  
  ### Logic to combine queries
  if (!identical(query, list())) {
    
    if (is.null(query$operator)) query <- list(operator = "AND", queries = list(query))
    
    if (keep_query & !identical(cohort@query, list())) query <- query & structure(cohort@query, class = "cbQuery")
    
  } 
  else if (keep_query) {
    
    query <- structure(cohort@query, class = "cbQuery")
    
  }
  
  all_filters <- .extract_single_nodes(query) %>%
    .query_body_to_v1
  
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
                                    query,
                                    keep_query = TRUE) {
  
  ### Logic to combine queries
  if (!identical(query, list())) {
    
    if (is.null(query$operator)) query <- list(operator = "AND", queries = list(query))
    
    if (keep_query & !identical(cohort@query, list())) query <- query & structure(cohort@query, class = "cbQuery")
    
  } 
  else if (keep_query) {
    
    query <- structure(cohort@query, class = "cbQuery")
    
  }
  
  query <- .extract_single_nodes(query)
  
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
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  #res_df <- do.call(rbind, res)
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
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
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
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  res_df <- as.data.frame(do.call(cbind, res))
  # remove mongodb _id column
  res_df_new <- subset(res_df, select = (c(-`_id`)))
  return(res_df_new)
}
