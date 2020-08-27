# cloudos objects

# clodos s4class definition
setClass("cloudos", slots = list(base_url = "character",
                                 auth = "character",
                                 auth_method = "character",
                                 team_id = "character")
         )

# function to create a cloud class object
cloudos <- function(base_url, auth, team_id){
  
  # check type of Authentication method
  if (grepl("apikey", auth)){
    auth_method  = "API Key"
  }else if (grepl("Bearer", auth)){
    auth_method = "Bearer Token"
  }else{
    stop("Please mention an authentication starts with apikey/Bearer")
  }
  
  cloudos_class_obj <- new("cloudos",
                       base_url = base_url,
                       auth_method = auth_method,
                       auth = auth,
                       team_id = team_id)
  
  return(cloudos_class_obj)
}

# method for cloudos obejct

setMethod("show",
          "cloudos",
          function(object) {
            cat("Base URL: ", object@base_url, "\n")
            cat("Authentication Method: ", object@auth_method , "\n")
            cat("Team ID:", object@team_id, "\n")
          }
)

