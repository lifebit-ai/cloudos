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
phenotype <- function(id, value, instance = list("0"), ...){
  
  if(!is.list(value) | !is.list(instance)){ stop ("Error: Value and instance must be a list")}
  
  tmp <- append(list(field = id, instance = instance, value = value), list(...))
  
  structure(tmp, class = "cbQuery")
  
}
