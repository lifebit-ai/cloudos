
.get_httr_headers <- function(cloudos_token){
  
  # check type of Authentication method
  headers <- httr::add_headers(.headers = c("apikey" = cloudos_token,
                                            "Accept" = "application/json, text/plain, */*",
                                            "Content-Type" = "application/json;charset=UTF-8"))
  if (grepl("Bearer", cloudos_token)){
    headers <- httr::add_headers(.headers = c("Authorization" = cloudos_token,
                                              "Accept" = "application/json, text/plain, */*",
                                              "Content-Type" = "application/json;charset=UTF-8"))
  }
  return(headers)
}
