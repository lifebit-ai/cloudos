#' @title Get genotypic table
#'
#' @description Get Genotypic table in a dataframe. 
#' Optionally genotypic filters can be applied as well.
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}}
#' @param page_number Number of page. (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#' @param filters WIP - details will be added.
#'
#' @return A dataframe.
#'
#' @export
get_genotypic_table <- function(object,
                               page_number = 0,
                               page_size = 10,
                               filters = "") {
  # TODO work on filter
  
  # chromosome filter
  # chr_filt = list("columnHeader" = "Chromosome",
  #                 "filterType" = "Text",
  #                 "values" = chr)
  # type_filt = list("columnHeader" = "Type",
  #                  "filterType" = "Text",
  #                  "values" = type)
  # filters = list(chr_filt, type_filt)
  
  
  
  url <- paste(object@base_url, "api/v1/cohort/genotypic-data", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = object@auth,
                                                 "accept" = "application/json, text/plain, */*",
                                                 "content-type" = "application/json;charset=UTF-8")),
                  query = list("teamId" = object@team_id),
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
  # TODO improve the dataframe
  df <- do.call(rbind, lapply(lapply(df_list, unlist), "[",
                        unique(unlist(c(sapply(df_list,names))))))
  return(df)
}

####################################################################

#' @title Get samples table
#'
#' @description Get samples (participants) table in a dataframe. 
#' Optionally phenotypic filters can be applied as well.
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}}
#' @param page_number Number of page. (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#'
#' @return A dataframe.
#'
#' @export
get_samples_table <- function(object, 
                              page_number = 0,
                              page_size = 10) {
  # TODO work on column
  columns <- list(list("id" = 34,
                       "instance" = 0,
                       "array" = list("type" = "exact",
                                      "value" = 0)
                  ),
                  list("id" = 31,
                       "instance" = 0,
                       "array" = list("type" = "exact",
                                      "value" = 0)
                  ),
                  list("id" = 52,
                       "instance" = 0,
                       "array" = list("type" = "exact",
                                      "value" = 0)
                  ),
                  list("id" = 5984,
                       "instance" = 0,
                       "array" = list("type" = "avg")
                  ),
                  list("id" = 5984,
                       "instance" = 0,
                       "array" = list("type" = "min")
                  ),
                  list("id" = 5984,
                       "instance" = 0,
                       "array" = list("type" = "max")
                  ),
                  list("id" = 20001,
                       "instance" = 0,
                       "array" = list("type" = "exact",
                                      "value" = 0)
                  )
            )
  
  # TODO work on filtered search
  search = list()
  cohort_filtered_search = list(list("column" = list("id" = 2345,
                                                     "instance" = 0,
                                                     "array" = list("type" = "exact",
                                                                    "value" = "0")
                                                    ),
                                                    "values" = c("Prefer not to answer","No")
                                    )
                                )
  onpage_filtered_serach = list(list("column" = list("id" = 31,
                                                     "instance" = 0,
                                                     "array" = list("type" = "exact",
                                                                    "value" = "0")
                                                     ),
                                     "contains"= c("Male")
  ))
  
  # make request
  url <- paste(object@base_url, "api/v1/cohort/participants/search", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = object@auth,
                                                 "Accept" = "application/json, text/plain, */*",
                                                 "Content-Type" = "application/json;charset=UTF-8")),
                  query = list("teamId" = object@team_id),
                  body = list("pageNumber" = page_number,
                              "pageSize" = page_size,
                              "columns" = columns,
                              "search" = search,
                              "returnTotal" = "false"),
                  encode = "json"
  )
  if (!r$status_code == 200) {
    stop("Something went wrong. Not able to create a cohort")
  }
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  df_list <- list()
  for (n in 1:length(res$data)) {
    dta <- do.call(cbind, res$data[[n]])
    df_list[[n]] <- as.data.frame(dta)
  }
  res_df <- dplyr::bind_rows(df_list)
  return(res_df)
}

#######################################################################

#' @title Extract participants
#'
#' @description Extracts selected participants.
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}} 
#' @param raw_data A JSON string for selected participants. (Required)
#'
#' @return A dataframe.
#'
#' @export
extract_samples <- function(object, raw_data) {
  url <- paste(object@base_url, "api/v1/cohort/participants/export", sep = "/")
  # TODO work on raw_data
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = object@auth,
                                                 "accept" = "*/*",
                                                 "content-type" = "application/json")),
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