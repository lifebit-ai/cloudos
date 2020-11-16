#' @title Create Cohort
#'
#' @description Creates a new Cohort
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}}
#' @param cohort_name New cohort name to be created. (Required)
#' @param cohort_desc New cohort description to be created. (Optional)
#' @param filters WIP - details will be added.
#'
#' @return A \linkS4class{cohort} object.
#' 
#' @seealso \code{\link{cb_load_cohort}} for loading a available cohort.
#'
#' @examples
#' \dontrun{
#' cb_create_cohort(cloudos_obj,
#'              cohort_name = "my cohort",
#'              cohort_desc = "my cohort description")
#' }
#' @export
cb_create_cohort <- function(cloudos, cohort_name, cohort_desc, filters = "") {
  
  # if no description provided
  if(missing(cohort_desc)){
    cohort_desc = list()
  }
  
  url <- paste(cloudos@base_url, "v1/cohort/", sep = "/")
  r <- httr::POST(url,
                  .get_httr_headers(cloudos@auth),
                  query = list("teamId" = cloudos@team_id),
                  body = list("name" = cohort_name,
                              "description" = cohort_desc, 
                              "moreFilters" = filters), # TODO work on filters - its better to do from UI
                  encode = "json"
  )
  httr::stop_for_status(r, task = "create a cohort")
  # parse the content
  message("Cohort created successfully.")
  res <- httr::content(r)
  # into a dataframe
  # res_df <- do.call(rbind, res)
  # colnames(res_df) <- "details"
  # return a cohort object
  cohort_obj <- cb_load_cohort(cloudos = cloudos, 
                            cohort_id = res$`_id`)
  return(cohort_obj)
}
