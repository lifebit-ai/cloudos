#' @title Extract Genotypic Data
#'
#' @description Extract Genotypic Data with filter.
#'
#' @param object A cloudos object. (Required)
#' See constructor function \code{\link{cloudos}}
#' @param page_number Number of page. (Optional) Default - 0
#' @param page_size Number of entries in a page. (Optional) Default - 10
#' @param filters WIP - details will be added.
#'
#' @return A dataframe.
#'
#' @examples
#' \dontrun{
#' extract_genotypic_data(cloudos_obj)
#' }
#' @export
extract_genotypic_data <- function(object,
                               page_number = 0,
                               page_size = 10,
                               filters = "") {
  # TODO work on filter
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
extract_participants <- function(object, raw_data) {
  url <- paste(object@base_url, "api/v1/cohort/participants/export", sep = "/")
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
