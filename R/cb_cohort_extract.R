#' @title Get genotypic table
#'
#' @description Get Genotypic table in a dataframe. 
#' Optionally genotypic filters can be applied as well.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}}
#' @param cohort A cohort object. (Required)
#' See constructor functions \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param page_number Number of page. (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#' @param geno_filters_query Genotypic filter query (Optional)
#'
#' @return A dataframe.
#' 
#' @example
#' \dontrun{
#' cb_get_genotypic_table(cloudos = my_cloudos,
#'                cohort = my_cohort,
#'                geno_filters_query = list("chromosome" = c("1", "7"))
#'                )
#' }
#'
#' @export
cb_get_genotypic_table <- function(cloudos,
                                   cohort,
                                   size = 10,
                                   geno_filters_query) {
  # TODO cohort object is not being used ATM,
  # because from BE it is not implemented to retrieve cohort related genotypic
  
  page_number = 0
  page_size = size
  
  genotypic_filters = ""
  if(!missing(geno_filters_query)){
    genotypic_filters <- .get_genotypic_filters_query(geno_filters_query)
  }
  
  r_body <- list("pageNumber" = jsonlite::unbox(page_number),
                 "pageSize" = jsonlite::unbox(page_size),
                 "filters" = genotypic_filters)
  
  url <- paste(cloudos@base_url, "v1/cohort/genotypic-data", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos@auth),
                  query = list("teamId" = cloudos@team_id),
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

#' @title Get samples table
#'
#' @description Get samples (participants) table in a dataframe. 
#' Optionally phenotypic filters can be applied as well.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}}
#' @param cohort A cohort object. (Required)
#' See constructor functions \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#' @param page_number Number of page. (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#'
#' @return A dataframe.
#'
#' @export
cb_get_samples_table <- function(cloudos,
                              cohort,
                              page_number = 0,
                              page_size = 10) {

  # make json body
  if(missing(cohort)){
    search = list()
    columns = list()
  }else{
    my_cohort_info <- .get_cohort_info(cloudos, cohort@id)
    search <- .get_search_json(my_cohort_info)
    columns <- .get_column_json(my_cohort_info)
  }
  # make request
  url <- paste(cloudos@base_url, "v1/cohort/participants/search", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos@auth),
                  query = list("teamId" = cloudos@team_id),
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
  # into a dataframe
  df_list <- list()
  for (n in res$data) {
    dta <- rbind(n)
    df_list <- c(df_list, list(as.data.frame(dta)))
  }
  res_df <- dplyr::bind_rows(df_list)
  
  # check if the dataframe is retrieved properly
  if(length(res_df) == 0){
    stop("Couldn't able to retrive the dataframe, something wrong with the cohort filters.")
  }
  
  # remove mongodb _id column
  res_df_new <- subset(res_df, select = -c(`_id`))
  
  # get column names
  columns_names <- c("EID") # EID is constant for all case
  for (n in res$header$columns) {
    dta <- n$field$name
    columns_names <- c(columns_names, dta)
  }
  
  # rename the dataframe with column names
  colnames(res_df_new) <- columns_names
  
  # rename rownames
  rownames(res_df_new) <- 1:page_size
  
  return(res_df_new)
}

#######################################################################

#' @title Extract participants
#'
#' @description Extracts selected participants.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param raw_data A JSON string for selected participants. (Required)
#'
#' @return A dataframe.
#'
#' @export
cb_extract_samples <- function(cloudos, raw_data) {
  url <- paste(cloudos@base_url, "v1/cohort/participants/export", sep = "/")
  # TODO work on raw_data - Find an end point that returns this and make a json in R
  r <- httr::POST(url,
                  .get_httr_headers(cloudos@auth),
                  body = raw_data,
                  encode = "json"
  )
  httr::stop_for_status(r, task = NULL)
  # parse the content
  res <- httr::content(r, as = "text")
  df <- utils::read.csv(textConnection(res))
  return(df)
}
