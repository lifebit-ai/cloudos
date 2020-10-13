#' @title Get genotypic table
#'
#' @description Get Genotypic table in a dataframe. 
#' Optionally genotypic filters can be applied as well.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}}
#' @param page_number Number of page. (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#' @param filters WIP - details will be added.
#'
#' @return A dataframe.
#'
#' @export
cb_get_genotypic_table <- function(cloudos,
                               page_number = 0,
                               page_size = 10,
                               filters = "") {
  # TODO work on filter, they are not getting saved
  # so it is not possible to retrieve cohort related genotypic table.
  # chromosome filter
  # chr_filt = list("columnHeader" = "Chromosome",
  #                 "filterType" = "Text",
  #                 "values" = chr)
  # type_filt = list("columnHeader" = "Type",
  #                  "filterType" = "Text",
  #                  "values" = type)
  # filters = list(chr_filt, type_filt)
  
  url <- paste(cloudos@base_url, "v1/cohort/genotypic-data", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos@auth),
                  query = list("teamId" = cloudos@team_id),
                  body = list("pageNumber" = page_number,
                              "pageSize" = page_size,
                              "filters" = filters),
                  encode = "json"
  )
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  }
  # parse the content
  res <- httr::content(r)
  df_list <- res$participants
  # https://www.r-bloggers.com/r-combining-vectors-or-data-frames-of-unequal-length-into-one-data-frame/
  df <- do.call(rbind, lapply(lapply(df_list, unlist), "[",
                        unique(unlist(c(sapply(df_list,names))))))
  df <- as.data.frame(df)
  # remove mongodb _id column
  df_new <- subset(df, select = (c(-`_id`)))
  return(df_new)
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
  # make column json
  columns <- .get_column_json()
  # make search json
  if(missing(cohort)){
    search = list()
  }else{
    my_cohort <- .get_cohort_info(cloudos, cohort@id)
    search <- .get_search_json(my_cohort)
  }
  # make request
  url <- paste(cloudos@base_url, "v1/cohort/participants/search", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos@auth),
                  query = list("teamId" = cloudos@team_id),
                  body = list("pageNumber" = page_number,
                              "pageSize" = page_size,
                              #"columns" = columns, # TODO
                              "search" =  search,
                              "returnTotal" = FALSE),
                  encode = "json"
  )
  if (!r$status_code == 200) {
    stop("Something went wrong. Not able to create a cohort")
  }
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  df_list <- list()
  for (n in res$data) {
    dta <- do.call(cbind, n)
    df_list <- c(df_list, list(as.data.frame(dta)))
  }
  res_df <- dplyr::bind_rows(df_list)
  # remove mongodb _id column
  res_df_new <- subset(res_df, select = -c(`_id`))
  return(res_df_new)
}

# test
#df6 <- cb_get_samples_table(cloudos, cohort = cohort_obj)
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
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  }
  # parse the content
  res <- httr::content(r, as = "text")
  df <- utils::read.csv(textConnection(res))
  return(df)
}
