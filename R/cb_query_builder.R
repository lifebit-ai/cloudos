`&.cbQuery` <- function(e1, e2){
  
  tmp <- list(operator = "AND",
              queries = list(unclass(e2), unclass(e1)))
  
  class(tmp) <- "cbQuery"
  
  tmp
}

`|.cbQuery` <- function(e1, e2){
  
  tmp <- list(operator = "OR",
              queries = list(unclass(e2), unclass(e1))
  )
  
  class(tmp) <- "cbQuery"
  
  tmp
}

`!.cbQuery` <- function(e1){
  tmp <- list(operator = "NOT",
              queries = list(unclass(e1))
  )
  
  class(tmp) <- "cbQuery"
  
  tmp
  
}

#' @title Define a phenotype
#'
#' @description Defines a single phenotype
#'
#' @param id A single phenotype id. Possible phenotyoes can be explored using the code{\link{cb_search_phenotypes}} function 
#' @param value The categorical value of the phenotype id defined
#' @param from For continuous phenotypes, the lower bound of the desired value range
#' @param to For continuous phenotypes, the upper bound of the desired value phenotype 
#' @param instance The instance number of the phenotype, default 0
#' 
#' @return A single phenotypes definition that cam be combined using &,| and ! operators
#' 
#' @examples
#' \dontrun{
#' continuous_phenotype <- phenotype(id = 13, from = "2016-01-21", to = "2017-02-13")
#' categorical_phenotype <- phenotype(id = 4, value = "Cancer")
#' }
#' 
#' @export
phenotype <- function(id, value, from, to, instance = "0"){

  if((!missing(from) | !missing(to)) & !missing(value)) stop("Error: Phenotype value can be defined using 'value' or 'from/to', but not both")
  if(missing(from) & !missing(to)) stop("Error: Phenotype missing 'to' value")
  if(!missing(from) & missing(to)) stop("Error: Phenotype missing 'from' value")

  if(!missing(value))   tmp <- list(field = id, instance = list(instance), value = list(value))
  if(missing(value))  tmp <- list(field = id, instance = list(instance), value = list(from = from, to = to))
  
  structure(tmp, class = "cbQuery")
  
}
