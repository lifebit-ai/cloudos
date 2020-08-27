filter_participants <-function(base_url, auth, team_id,
                               cohort_id, filters_id ) {
  
  r_body <- list("moreFilters" = list(list("fieldId" = filter_id,
                                      "instance" = c(0),
                                      "value" = c(-3,0)
                                      )
                 ),
                 "cohortId" = cohort_id
  )
  url <- paste(base_url, "api/v1/cohort/filter/participants", sep = "/")
  r <- httr::POST(url,
                  httr::add_headers(.headers = c("Authorization" = auth,
                                                 "Accept" = "application/json, text/plain, */*",
                                                 "Content-Type" = "application/json;charset=UTF-8")),
                  query = list("teamId" = team_id),
                  body = jsonlite::toJSON(r_body),
                  encode = "raw"
  )
  if (!r$status_code == 200) {
    stop("Something went wrong. Not able to create a cohort")
  }
  # parse the content
  res <- httr::content(r)
  # into a dataframe
  #res_df <- do.call(rbind, res)
  return(res)
}