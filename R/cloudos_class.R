#' cloudos class
#'
#' This class creates a object which
#' hold many information related to CloudOS server 
#' including base URL, authentication and team ID. 
#' Use of this object will simplify calling every 
#' other functions which requires to communicate with server.
#' This can be created using constructor function \code{\link{connect_cloudos}}
#'
#' @slot base_url Base URL of the CloudOS server.
#' @slot auth  An authentication method.
#' @slot auth_method Which authentication method being used.
#' @slot team_id Team ID in CloudOS account.
#'
#' @name cloudos-class
#' @rdname cloudos-class
#' @export
setClass("cloudos", slots = list(base_url = "character",
                                 auth = "character",
                                 auth_method = "character",
                                 team_id = "character")
          )

#' @title Connect CloudOS
#'
#' @description Creates a cloudos object which saves all 
#' authentication methods and metadata, 
#' that can help to connect with cloudos server.
#'
#' @param base_url Base URL of the CloudOS server. (Optional) 
#' Default: https://cloudos.lifebit.ai/ 
#' @param auth  An authentication method. (Required)
#' Example - Bearer token or API key.
#' @param team_id Team ID in CloudOS account. (Required)
#'
#' @return A \linkS4class{cloudos} object.
#'
#' @examples
#' \dontrun{
#' connect_cloudos(base_url= "https://cloudos.lifebit.ai",
#'              auth = "Bearer your_token",
#'              team_id = "your_team_id")
#' }
#' @export
connect_cloudos <- function(base_url, auth, team_id){
  # check type of Authentication method
  if (grepl("apikey", auth)){
    auth_method  = "API Key"
  }else if (grepl("Bearer", auth)){
    auth_method = "Bearer Token"
  }else{
    stop("Please mention an authentication starts with apikey/Bearer")
  }
  
  # check if base URL is given if not use default
  if(missing(base_url)){
    base_url = "https://cloudos.lifebit.ai/"
  }
  
  cloudos_class_obj <- methods::new("cloudos",
                                   base_url = base_url,
                                   auth_method = auth_method,
                                   auth = auth,
                                   team_id = team_id)
  
  return(cloudos_class_obj)
}

# method for cloudos object
setMethod("show", "cloudos",
          function(object) {
            cat("Base URL: ", object@base_url, "\n")
            cat("Authentication Method: ", object@auth_method , "\n")
            cat("Team ID:", object@team_id, "\n")
          }
)
