# unnest function to get a flat list of phenotype filters out of nested v2 style query
.unnest_query<- function(q){
  if (is.null(q$queries)) {
    return(list(q))
    
  } else if (length(q$queries) == 1) {
    return(.unnest_query(q$queries[[1]]))
    
  } else if (length(q$queries) == 2) {
    return(c(.unnest_query(q$queries[[1]]), .unnest_query(q$queries[[2]])))
    
  } else {
    stop("Too many queries in operator.")
  }
}


#' only used for v1 endpoint - creates v1 search json using the v2 style query
#' @param my_cohort A cohort object
.get_search_json <- function(my_cohort){

  search = list()
  # check if the cohort has an applied query. if not retrun an empty list.
  if(length(my_cohort@query) == 0){
    return(search)
  }


  unnested <- .unnest_query(my_cohort@query)
  
  for (filter in unnested){
    if (is.null(filter$value$from)){
     f <-list("column" = list("id" = filter$field,
                              "instance" = filter$instance[[1]],
                              "array" = list("type"="any")),
              "values" = filter$value)
     search <- c(search, list(f))
     
    } else {
      f <-list("column" = list("id" = filter$field,
                               "instance" = filter$instance[[1]],
                               "array" = list("type"="any")),
               "low" = filter$value$from,
               "high" = filter$value$to)
      search <- c(search, list(f))
    }
  }

  return(search)
}

############################################################################################
# Column JOSN
# TODO work on column - At this point NO end-point that returns this information, there are cards

.get_column_json <- function(my_cohort){
  cohort_columns = list()
  # check if the cohort has column information. if not retrun an empty list.
  if(length(my_cohort@columns) == 0){
    return(cohort_columns)
  }
  # 
  for(col in my_cohort@columns){
    col_temp = list("id" = col$field$id,
                    "instance" = col$instance,
                    "array" = col$array # make sure toJSON(auto_unbox = T)
    )
    cohort_columns = c(cohort_columns, list(col_temp))
  }
  
  return(cohort_columns)
}

