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

.value_filter <- function(more_fields, fields){
  # make a value vector
  my_values <- c()
  for(i in 1:length(more_fields$value)){
    value_id <- as.character(more_fields$value[[i]][1])
    field_value <- fields$field$values[[value_id]]
    if(is.null(field_value)) field_value <- value_id
    my_values <- c(my_values, field_value)
  }
  # make search json
  search = list("column" = list("id" = jsonlite::unbox(more_fields$fieldId),
                                "instance" = jsonlite::unbox(more_fields$instance[[1]]),
                                "array" = list("type" = jsonlite::unbox("any"))
                                # "array" = list("type" = "exact", # [exact | any]
                                #                "value" = "0")
                               ),
                "values" = my_values
                )
  return(search)
}

.range_filter <- function(more_fields){
  # make search json
  search = list("column" = list("id" = jsonlite::unbox(more_fields$fieldId),
                                "instance" = jsonlite::unbox(more_fields$instance[[1]]),
                                "array" = list("type" = jsonlite::unbox("any"))
                                # "array" = list("type" = "exact", # [exact | any]
                                #                "value" = "0") # must be >= 0
                                ),
                "low" = more_fields$range$from,
                "high" = more_fields$range$to
               )
  return(search)
}

#' @param my_cohort The return list from .get_cohort_info(cohort_id)
.get_search_json <- function(my_cohort){
  # create an empty list
  search = list()
  # check if at all the cohort have filed or send an empty list
  if(length(my_cohort$moreFields) == 0){
    return(search)
  }
  # make search list for all the fields/filters
  for(filter_number in 1:length(my_cohort$fields)){
    # the my_cohort list is unordered
    # per filter get the same fields and moreFields from the list
    fields <-  my_cohort$fields[[filter_number]]
    fields_id <- fields$field$id
    for(j in 1:length(my_cohort$moreFields)){
      more_fields_id <- my_cohort$moreFields[[j]]$fieldId
      if(fields_id == more_fields_id){
        more_fields <- my_cohort$moreFields[[j]]
      }
    }
    # check what kind of fields/filters and get search list
    if(fields$field$type == "bars"){
      search_new = .value_filter(more_fields,fields)
    }else if (fields$field$type == "histogram"){
      search_new = .range_filter(more_fields)
    }else{
      stop("Unknown filter type. Accepts 'bar' and 'histogram' only.")
    }
    # create a search list for first time and append a new search list
    if(length(search) == 0){
      search = list(search_new)
    }else{
      search = c(search, list(search_new))
    }
  }
  return(search)
}

############################################################################################
# Column JOSN
# TODO work on column - At this point NO end-point that returns this information, there are cards

.get_column_json <- function(my_cohort){
  # create an empty list
  cohort_columns = list()
  # check if at all the cohort have filed or send an empty list
  if(length(my_cohort$columns) == 0){
    return(cohort_columns)
  }
  
  for(col in my_cohort$columns){
    col_temp = list("id" = col$id,
                    "instance" = col$instance,
                    "array" = col$array # make sure toJSON(auto_unbox = T)
    )
    # create a list for first time and append a new list
    if(length(cohort_columns) == 0){
      cohort_columns = list(col_temp)
    }else{
      cohort_columns = c(cohort_columns, list(col_temp))
    } 
  }
  
  return(cohort_columns)
}

