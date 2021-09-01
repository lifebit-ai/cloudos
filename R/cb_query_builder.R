#' @title Combine phenotypes using 'AND'
#' @export
`&.cbQuery` <- function(e1, e2){
  
  tmp <- list(operator = "AND",
              queries = list(unclass(e2), unclass(e1)))
  
  class(tmp) <- "cbQuery"
  
  tmp
}

#' @title Combine phenotypes using 'OR'
#' @export
`|.cbQuery` <- function(e1, e2){
  
  tmp <- list(operator = "OR",
              queries = list(unclass(e2), unclass(e1))
  )
  
  class(tmp) <- "cbQuery"
  
  tmp
}

#' @title Change phenotype to 'NOT'
#' @export
`!.cbQuery` <- function(e1){
  tmp <- list(operator = "NOT",
              queries = list(unclass(e1))
  )
  
  class(tmp) <- "cbQuery"
  
  tmp
  
}

#' @title Define new phenotype
#' @export
phenotype <- function(id, value, from, to, instance = "0"){

  if((!missing(from) | !missing(to)) & !missing(value)) stop("Error: Phenotype value can be defined using 'value' or 'from/to', but not both")
  if(missing(from) & !missing(to)) stop("Error: Phenotype missing 'to' value")
  if(!missing(from) & missing(to)) stop("Error: Phenotype missing 'from' value")

  if(!missing(value))   tmp <- list(field = id, instance = list(instance), value = list(value))
  if(missing(value))  tmp <- list(field = id, instance = list(instance), value = list(from = from, to = to))
  
  structure(tmp, class = "cbQuery")
  
}
