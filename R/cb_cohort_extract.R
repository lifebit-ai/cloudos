#' @title Get genotypic table
#'
#' @description Get Genotypic table in a dataframe. 
#' Optionally genotypic filters can be applied as well.
#'
#' @param cohort A cohort object. (Required)
#' See constructor functions \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param size Number of entries from database. (Optional) Default - 10 (Optional)
#' @param geno_filters_query Genotypic filter query (Optional)
#'
#' @return A dataframe.
#' 
#' @example
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' cb_get_genotypic_table(my_cohort,
#'                geno_filters_query = list("chromosome" = c("1", "7"))
#'                )
#' }
#'
#' @export
cb_get_genotypic_table <- function(cohort,
                                   size = 10,
                                   geno_filters_query) {
  # TODO cohort object is not being used ATM,
  # because from BE it is not implemented to retrieve cohort related genotypic
  
  if(size == 0) stop("size can't be 0")
  page_number = 0
  page_size = size
  
  genotypic_filters = ""
  if(!missing(geno_filters_query)){
    genotypic_filters <- .get_genotypic_filters_query(geno_filters_query)
  }
  
  r_body <- list("pageNumber" = jsonlite::unbox(page_number),
                 "pageSize" = jsonlite::unbox(page_size),
                 "filters" = genotypic_filters)
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v1/cohort/genotypic-data", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = jsonlite::toJSON(r_body),
                  encode = "raw"
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  .total_row_size_message(res)
  df_list <- res$participants
  # https://www.r-bloggers.com/r-combining-vectors-or-data-frames-of-unequal-length-into-one-data-frame/
  df <- do.call(rbind, lapply(lapply(df_list, unlist), "[",
                        unique(unlist(c(sapply(df_list,names))))))
  df <- as.data.frame(df)
  
  # check if the dataframe is retrieved properly
  if(length(df) == 0){
    stop("Couldn't able to retrive the dataframe, something wrong with the genotypic filters.")
  }
  
  # remove mongodb _id column
  df_new <- subset(df, select = (c(-`_id`)))
  return(df_new)
}

.get_genotypic_filters_query <- function(geno_filters_query){
  genotypic_filters_list <- list()
  for(i in 1:length(geno_filters_query)){
    filters <- list(list("columnHeader" = jsonlite::unbox(names(geno_filters_query)[i]),
                         "filterType" = jsonlite::unbox("Text"),
                         "values" = geno_filters_query[[i]]
                      ))
    genotypic_filters_list <- c(genotypic_filters_list, filters)
  }
  return(genotypic_filters_list)
}

#' @param res The res <- httr::content(r) content
.total_row_size_message <-  function(res){
  if(res$total){
    message(paste("Total number of rows found", res$total, 
                  "You can use 'size' to mention how many rows you want to extract.",
                  "Default size = 10",
                  sep = " "))
  }
}

####################################################################

#' @title Get participant data table
#'
#' @description Get participant data table in a dataframe. 
#'
#' @param cohort A cohort object. (Required)
#' See constructor functions \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param page_number Number of page. (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#'
#' @return A dataframe.
#'
#' @example
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' cohort_samples <- cb_get_participants_table(my_cohort)
#' cohort_samples %>% head(n=5)
#' }
#' 
#' @export
cb_get_participants_table <- function(cohort,
                              page_number = 0,
                              page_size = 10) {
  
  if (cohort@cb_version == "v1") {
    return(.cb_get_participants_table_v1(cohort, page_number = page_number, page_size = page_size))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_get_participants_table_v2(cohort, page_number = page_number, page_size = page_size))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}

.cb_get_participants_table_v1 <- function(cohort,
                              page_number = 0,
                              page_size = 10) {

  if(page_size == 0) stop("page_size can't be 0")
  # make json body
  if(missing(cohort)){
    search = list()
    columns = list()
  }else{
    search <- .get_search_json(cohort)
    columns <- .get_column_json(cohort)
  }
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v1/cohort/participants/search", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = jsonlite::toJSON(
                    list("pageNumber" = page_number,
                         "pageSize" = page_size,
                         "columns" = columns,
                         "search" =  search,
                         "returnTotal" = FALSE),
                    auto_unbox = T),
                  encode = "raw"
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  
  # get col names and construct col ids
  col_names <- list("_id" = "_id", "i" = "EID")
  for (col in res$header$columns){
    long_id <- paste0("f", col$id, "i", col$instance, "a", col$array$value)
    col_names[[long_id]] <- col$field$name
  }
  
  # create an empty row with all the columns based on header info
  # - this ensures the df has all columns even if a column is empty in all rows
  emptyrow <- data.frame(rbind(rep(NA, length(col_names))))
  colnames(emptyrow) <- names(col_names)
  
  df_list <- list(emptyrow) 
  for (n in res$data) {
    dta <- rbind(n)
    df_list <- c(df_list, list(as.data.frame(dta)))
  }
  res_df <- dplyr::bind_rows(df_list)[-1,] # combine and remove empty first row
  
  
  # check if the dataframe is retrieved properly
  if(length(res_df) == 0){
    stop("Couldn't able to retrive the dataframe, something wrong with the cohort filters.")
  }
  
  # rename the dataframe with column names
  colnames(res_df) <- col_names
  
  # remove mongodb _id column
  res_df <- subset(res_df, select = -c(`_id`))
  
  # replace NULL values with NA
  # NULL values in a df are wrapped in a list
  # counterintuitively is.null(list(NULL)) >>> FALSE but list(NULL)=='NULL' >>> TRUE
  res_df[res_df == 'NULL'] <- NA
  
  # reset row names
  rownames(res_df) <- NULL
  
  return(res_df)
}


.cb_get_participants_table_v2 <- function(cohort,
                              page_number = 0,
                              page_size = 10) {

  if(page_size == 0) stop("page_size can't be 0")
  # make json body
  if(missing(cohort)){
    columns = list()
  }else{
    columns <- .get_column_json(cohort)
  }
  cloudos <- .check_and_load_all_cloudos_env_var()
  # make request
  url <- paste(cloudos$base_url, "v2/cohort/participants/search", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = jsonlite::toJSON(
                    list("criteria" = list("pagination" = list("pageNumber" = page_number,
                                                               "pageSize" = page_size),
                                           "cohortId" = cohort@id),
                         "query" = cohort@query,
                         "columns" = columns),
                    auto_unbox = T),
                  encode = "raw")
  
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r)
  
  # get col names and construct col ids
  col_names <- list("_id" = "_id", "i" = "EID")
  for (col in res$header){
    long_id <- paste0("f", col$id, "i", col$instance, "a", col$array$value)
    col_names[[long_id]] <- col$field$name
  }
  
  # create an empty row with all the columns based on header info
  # - this ensures the df has all columns even if a column is empty in all rows
  emptyrow <- data.frame(rbind(rep(NA, length(col_names))))
  colnames(emptyrow) <- names(col_names)
  
  df_list <- list(emptyrow) 
    for (n in res$data) {
    dta <- rbind(n)
    df_list <- c(df_list, list(as.data.frame(dta)))
  }
  res_df <- dplyr::bind_rows(df_list)[-1,] # combine and remove empty first row


  # check if the dataframe is retrieved properly
  if(length(res_df) == 0){
    stop("Couldn't able to retrive the dataframe, something wrong with the cohort filters.")
  }
  
  # rename the dataframe with column names
  colnames(res_df) <- col_names
  
  # remove mongodb _id column
  res_df <- subset(res_df, select = -c(`_id`))
  
  # replace NULL values with NA
  res_df[res_df == 'NULL'] <- NA  # see .get_samples_table_v1 for explanation

  # reset row names
  rownames(res_df) <- NULL
  
  return(res_df)
}

#######################################################################

#' @title Extract participants - WIP
#'
#' @description Extracts selected participants.
#'
#' @param raw_data A JSON string for selected participants. (Required)
#'
#' @return A dataframe.
#'
cb_extract_samples <- function(raw_data) {
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v1/cohort/participants/export", sep = "/")
  # TODO work on raw_data - Find an end point that returns this and make a json in R
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  body = raw_data,
                  encode = "json"
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r, as = "text")
  df <- utils::read.csv(textConnection(res))
  return(df)
}
