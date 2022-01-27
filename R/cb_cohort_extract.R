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
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = NULL)
  
  # parse the content
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



.fetch_table_v2 <- function(req_body, iter_all = FALSE) {
  
  page_size <- req_body$criteria$pagination$pageSize
  page_number <- req_body$criteria$pagination$pageNumber
  if (page_number == 'all') req_body$criteria$pagination$pageNumber <- 0
  
  cloudos <- .check_and_load_all_cloudos_env_var()
  url <- paste(cloudos$base_url, "v2/cohort/participants/search", sep = "/")
  
  r <- httr::POST(url,
                  .get_httr_headers(cloudos$token),
                  query = list("teamId" = cloudos$team_id),
                  body = jsonlite::toJSON(req_body, auto_unbox = T),
                  encode = "raw")
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "get participant table data")
  
  header <- res$header
  data <- res$data
  total <- res$total
  
  if (iter_all) {
    iters <- ceiling(total/page_size) - 1  # we have already fetched page 0
    for (i in seq_len(iters)) {
      req_body$criteria$pagination$pageNumber <- i
      req_body$criteria$pagination$pageSize <- page_size
      r <- httr::POST(url,
                      .get_httr_headers(cloudos$token),
                      query = list("teamId" = cloudos$team_id),
                      body = jsonlite::toJSON(req_body, auto_unbox = T),
                      encode = "raw")
      res <- httr::content(r)
      
      # check for request error
      if (!is.null(res$message)) message(res$message)
      httr::stop_for_status(r, task = "Retrieve participant table")
      
      data <- c(data, res$data)
    }
  }
  
  result <- list("total" = total, "header"= header, "data" = data)
  return(result)
  
}



####################################################################

#' @title Get participant data table
#'
#' @description Get participant data table in a dataframe. 
#'
#' @param cohort A cohort object. (Required)
#' See constructor functions \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param cols Vector of phenotype IDs to fetch as columns in the dataframe. If omitted, columns saved
#' in the cohort are fetched.
#' @param page_number Number of page as integer or 'all' to fetch all data. (Optional) Default - 'all'
#' @param page_size Number of entries in a page. (Optional) Default - 5000
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
                                      cols,
                                      page_number = 'all',
                                      page_size = 5000) {
  
  if (cohort@cb_version == "v1") {
    if (!missing(cols)) stop("'cols' argument is not supported for CB v1")
    return(.cb_get_participants_table_v1(cohort, page_number = page_number, page_size = page_size))
    
  } else if (cohort@cb_version == "v2") {
    return(.cb_get_participants_table_v2(cohort, cols = cols, page_number = page_number, page_size = page_size))
    
  } else {
    stop('Unknown cohort browser version string ("cb_version"). Choose either "v1" or "v2".')
  }
}

.cb_get_participants_table_v1 <- function(cohort,
                              page_number = 0,
                              page_size = 100) {

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
  res <- httr::content(r)
  
  # check for request error
  if (!is.null(res$message)) message(res$message)
  httr::stop_for_status(r, task = "get participant table data")
  
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
    stop("Unable to retrive the dataframe, something may be wrong with the cohort query.")
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
                                          cols,
                                          page_number = 0,
                                          page_size = 100) {

  if(page_size == 0) stop("page_size can't be 0")
  if(page_number != 'all' && !is.numeric(page_number)) stop("page_number must be integer or 'all'")

  # make json body
  if(missing(cols)){
    columns <- .get_column_json(cohort)
  } else {
    columns <- .make_column_json(cols)
  }
  
  r_body <- list("criteria" = list("pagination" = list("pageNumber" = page_number,
                                                       "pageSize" = page_size),
                                   "cohortId" = cohort@id),
                 "columns" = columns)
  
  if (length(cohort@query) > 0) r_body$query <- cohort@query
  
  if (page_number == "all") {
    res <- .fetch_table_v2(r_body, iter_all = TRUE)
  } else {
    res <- .fetch_table_v2(r_body, iter_all = FALSE)
  }
  
  # get col names and construct col ids
  # create an empty row with all the columns based on header info
  #     - this ensures the df has all columns even if a column is empty in all rows
  # get col types

  col_names <- list("_id" = "_id", "i" = "EID")
  emptyrow <- list("_id" = NA_character_, "i" = NA_character_)
  col_types <- list("_id"= as.character, "i"= as.character)
  for (col in res$header){
    if (col$array$type == "exact") {
      long_id <- paste0("f", col$id, "i", col$instance, "a", col$array$value)
      empty_val <- NA_character_
    } else {
      long_id <- paste0("f", col$id, "i", col$instance, "a", "all")
      empty_val <- list()
    }
    col_names[[long_id]] <- col$field$name
    emptyrow[[long_id]] <- empty_val

    if (is.null(col$field$valueType)) {
      col_types[[long_id]] <- as.character
    } else if (col$field$valueType == 'Integer') {
      col_types[[long_id]] <- as.numeric
    } else if (col$field$valueType == 'Continuous') {
      col_types[[long_id]] <- as.numeric
    } else {
      col_types[[long_id]] <- as.character
    }
  }
  
  df_list <- list()
  for (n in c(list(emptyrow), res$data)) {
    # important to change NULL to NA using .null_to_na_nested
    dta <- .null_to_na_nested(n)
    # change types within lists according to col_type
    for (name in names(dta)) {
      if (is.list(dta[[name]])){
        type_func <- col_types[[name]]
        dta[[name]] <- list(type_func(dta[[name]]))
      }
    }
    dta <- tibble::as_tibble_row(dta)
    df_list <- c(df_list, list(dta))
  }
  res_df <- dplyr::bind_rows(df_list)[-1,] # combine and remove empty first row


  # check if the dataframe is retrieved properly
  if(length(res_df) == 0){
    stop("Unable to retrive the dataframe, something may be wrong with the cohort query.")
  }

  # remove mongodb _id column
  res_df <- subset(res_df, select = -c(`_id`))

  # set column types based on header info
  for (colname in colnames(res_df)){
    if (!is.list(res_df[[colname]])) res_df[[colname]] <- col_types[[colname]](res_df[[colname]])
  }

  # rename the dataframe with column names
  res_df <- dplyr::rename_with(res_df, .fn = function(x) unlist(col_names[x], use.names=F))

  # reset row names
  rownames(res_df) <- NULL
  
  return(res_df)
}



####################################################################

#' @title Get longform participant data table
#'
#' @description Get participant data table in a longform dataframe. 
#'
#' @param cohort A cohort object. (Required)
#' See constructor functions \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param cols Vector of phenotype IDs to fetch as columns in the dataframe. If omitted, columns saved
#' in the cohort are fetched.
#' @param broadcast Whether to broadcast single value phenotypes across rows. (Optional)
#' Can be TRUE, FALSE or a vector of phenotype IDs to specify which phenotypes to broadcast. 
#' Default - TRUE
#' @param page_number Number of page (can be 'all' to fetch all data) . (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#' 
#'
#' @return A tibble.
#'
#' @example
#' \dontrun{
#' my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#' cohort_samples <- cb_get_participants_table_long(my_cohort)
#' cohort_samples %>% head(n=5)
#' }
#' 
#' @export
cb_get_participants_table_long <- function(cohort,
                                           cols,
                                           broadcast = TRUE,
                                           page_number = 0,
                                           page_size = 100) {
  
  if(page_size == 0) stop("page_size can't be 0")
  if(cohort@cb_version != "v2") stop("cb_version must be 'v2")
  
  # make json body
  if(missing(cols)){
    columns <- .get_column_json(cohort)
  } else {
    columns <- .make_column_json(cols)
  }
  
  r_body <- list("criteria" = list("pagination" = list("pageNumber" = page_number,
                                                       "pageSize" = page_size),
                                   "cohortId" = cohort@id),
                 "columns" = columns)
  
  if (length(cohort@query) > 0) r_body$query <- cohort@query
  
  if (page_number == "all") {
    res <- .fetch_table_v2(r_body, iter_all = TRUE)
  } else {
    res <- .fetch_table_v2(r_body, iter_all = FALSE)
  }
  
  # get metadata for each column
  col_names <- list("_id" = "_id", "i" = "EID")
  col_types <- list("i"= as.character)
  datagroups <- list()
  broadcast_cols <- c()
  
  for (col in res$header){
    if (col$array$type == "exact") {
      long_id <- paste0("f", col$id, "i", col$instance, "a", col$array$value)
    } else {
      long_id <- paste0("f", col$id, "i", col$instance, "a", "all")
    }
    col_names[[long_id]] <- col$field$name
    
    if ( col$id %in% broadcast || (broadcast == TRUE && col$field$array == 1) ) {
      broadcast_cols <- c(broadcast_cols, long_id)
    } else {
      datagroups[[col$field$Original_dataset]] <- c(datagroups[[col$field$Original_dataset]], long_id)
    }
    
    if (is.null(col$field$valueType)) {
      col_types[[long_id]] <- as.character
    } else if (col$field$valueType == 'Integer') {
      col_types[[long_id]] <- as.numeric
    } else if (col$field$valueType == 'Continuous') {
      col_types[[long_id]] <- as.numeric
    } else {
      col_types[[long_id]] <- as.character
    }
  }
  
  
  # create an empty row with all the columns based on header info
  # - this ensures the df has all columns even if a column is empty in all rows
  emptyrow <- data.frame(rbind(rep(NA, length(col_names))))
  colnames(emptyrow) <- names(col_names)
  
  # bind all the rows together (each row is data for 1 participant)
  df_list <- list(emptyrow) 
  for (n in res$data) {
    # important to change NULL to NA using .null_to_na_nested
    dta <- rbind(.null_to_na_nested(n))
    df_list <- c(df_list, list(as.data.frame(dta)))
  }
  res_df <- dplyr::bind_rows(df_list)[-1,] # combine and remove empty first row
  
  # check if the dataframe is retrieved properly
  if(length(res_df) == 0){
    stop("Unable to retrive the dataframe, something may be wrong with the cohort query.")
  }
  
  # treat columns from different original tables seperately
  # then combine into single dataframe with empty vals where appropriate
  df_list <- list()
  for (group in datagroups){
    df <- select(res_df, c("i", all_of(group))) %>% tidyr::unnest(cols = everything())
    for (colname in colnames(df)){
      df[[colname]] <- col_types[[colname]](df[[colname]])
    }
    df_list <- c(df_list, list(df))
  }
  datagroups_df <- dplyr::bind_rows(df_list)
  
  # Start final_df using i column & any cols to broadcast
  final_df <- select(res_df, c("i", all_of(broadcast_cols))) %>% tidyr::unnest(cols = everything())
  for (colname in colnames(final_df)){
    final_df[[colname]] <- col_types[[colname]](final_df[[colname]])
  }
  
  # join the datagroups dataframe to the broadcast columns
  final_df <- dplyr::left_join(final_df, datagroups_df, by = 'i')
  
  # rename the dataframe with column names
  final_df <- dplyr::rename_with(final_df, .fn = function(x) unlist(col_names[x], use.names=F))
  
  # reset row names
  rownames(final_df) <- NULL
  
  return(final_df)
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
