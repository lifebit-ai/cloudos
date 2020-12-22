cloudos_conf_file <- "~/.cloudos/config"

.read_cloudos_config_file <- function(){
  if(file.exists(cloudos_conf_file)){
    readRenviron(cloudos_conf_file)
  }
}

# env_var = 'CLOUDOS_BASEURL'
# env_var = 'CLOUDOS_TOKEN'
# env_var = 'CLOUDOS_TEAMID'
.check_cloudos_env_var <- function(env_var){
  env_var_value <- Sys.getenv(env_var)
  if (identical(env_var_value, "")) {
    .read_cloudos_config_file()
    env_var_value <- Sys.getenv(env_var)
    if (identical(env_var_value, "")){
      stop(paste("Please set env var", env_var, "or use cloudos_configure()", sep = " "),
           call. = FALSE)
    }
  }
  return(env_var_value)
}

.check_and_load_all_cloudos_env_var <- function(){
  all_cloudos_env_var <- c()
  all_cloudos_env_var$base_url <- .check_cloudos_env_var('CLOUDOS_BASEURL')
  all_cloudos_env_var$token <- .check_cloudos_env_var('CLOUDOS_TOKEN')
  all_cloudos_env_var$team_id <- .check_cloudos_env_var('CLOUDOS_TEAMID')
  return(all_cloudos_env_var)
}

cloudos_whoami <- function(){
  .check_and_load_all_cloudos_env_var()
  message(
    paste(
      paste0("CloudOS base URL ", Sys.getenv('CLOUDOS_BASEURL')),
      paste0("CloudOS token    ", Sys.getenv('CLOUDOS_TOKEN')),
      paste0("CloudOS team id  ", Sys.getenv('CLOUDOS_TEAMID')),
    sep = "\n")
  )
}

cloudos_configure <- function(base_url, token, team_id){
  
  if(file.exists(cloudos_conf_file)){
    message(paste(sep = " ",
                  "Found a", 
                  cloudos_conf_file, 
                  "This will be replaced"))
    file.remove(cloudos_conf_file)
  }
  
  if(!file.exists(cloudos_conf_file)){
    file.create(cloudos_conf_file)
  }
  
  file_conn<-file(cloudos_conf_file)
  writeLines(c(paste("CLOUDOS_BASEURL", base_url, sep = "="),
               paste("CLOUDOS_TOKEN", token, sep = "="),
               paste("CLOUDOS_TEAMID", team_id, sep = "=")), 
             file_conn, sep = "\n")
  close(file_conn)
  
}
