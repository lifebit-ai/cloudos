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
phenotype <- function(id, value, ...){
  
  tmp <- append(list(id = id, value = value), list(...))
  
  structure(tmp, class = "cbQuery")
  
}