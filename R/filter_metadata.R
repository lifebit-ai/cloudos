.list_cohorts <- function(base_url,
                         auth,
                         team_id,
                         filter_id) {
  url <- paste(base_url, "api/v1/cohort/filter", filter_id, "metadata", sep = "/")
  r <- httr::GET(url,
                 httr::add_headers("Authorization" = auth),
                 query = list("teamId" = team_id)
                 )
  if (!r$status_code == 200) {
    stop("Something went wrong.")
  }
  # parse the content
  res <- httr::content(r)
  res_df <- as.data.frame(do.call(cbind, res))
  return(cohorts_df)
}