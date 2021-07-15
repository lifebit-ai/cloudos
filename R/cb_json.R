# For all the helper functions here - 
# @param more_fields Filter information from .get_cohort_info(cohort_id)
# @param fields Metainfo about filters from .get_cohort_info(cohort_id)
# @param my_cohort The return list from .get_cohort_info(cohort_id)
# @example
# \dontrun{
# my_cohort <- .get_cohort_info(cohort_id)
# more_fields <- my_cohort$moreFields[[3]]
# fields <- my_cohort$fields[[2]]
# }


#' only used for v1 endpoint - creates v1 search json using the v2 style query
#' @param my_cohort A cohort object
.get_search_json <- function(my_cohort){

  search = list()
  # check if the cohort has a query/applied filters. if not retrun an empty list.
  if(length(my_cohort@query) == 0){
    return(search)
  }

  # unnest function to get a flat list of filters out of nested AND query operators
  unnest <- function(q){
    if (is.null(q$queries)){
      return(list(q))
    } else {
      return(c(unnest(q$queries[[1]]), unnest(q$queries[[2]])))
    }
  }
  
  unnested <- unnest(my_cohort@query)
  
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

