#my_cohort <- .get_cohort_info(cloudos, cohort_id)
#more_fields <- my_cohort$moreFields[[1]]
#fields <- my_cohort$fields[[1]]

.value_filter <- function(more_fields, fields){
  # make a value vector
  my_values <- c()
  for(i in 1:length(more_fields$value)){
    value_id <- as.numeric(more_fields$value[[i]][1])
    my_values <- c(my_values, fields$field$values[[as.character(value_id)]])
  }
  # make search json
  search = list("column" = list("id" = jsonlite::unbox(more_fields$fieldId),
                                "instance" = more_fields$instance[[1]],
                                "array" = list("type" = "exact",
                                               "value" = "0")
                               ),
                "values" = my_values
                )
  return(search)
}

.range_filter <- function(more_fields){
  # make search json
  search = list("column" = list("id" = more_fields$fieldId,
                                 "instance" = more_fields$instance[[1]],
                                 "array" = list("type" = "exact",
                                                "value" = "0")
                                ),
                "low" = more_fields$range$from,
                "high" = more_fields$range$to
               )
  return(search)
}

.get_search_json <- function(my_cohort){
  # create an empty list
  search = list()
  # check if at all the cohort have filed or send an empty list
  if(length(my_cohort$moreFields) == 0){
    return(search)
  }
  # make search list for all the fields/filters
  for(filter_number in 1:length(my_cohort$moreFields)){
    # check what kind of fileds/filters
    if(names(my_cohort$moreFields[[filter_number]][3]) == "value"){
      search_new = .value_filter(my_cohort$moreFields[[filter_number]], 
                             my_cohort$fields[[filter_number]] )
    }else if (names(my_cohort$moreFields[[filter_number]][3]) == "range"){
      search_new = .range_filter(my_cohort$moreFields[[filter_number]])
    }else{
      stop("Unknown filter type. Accepts 'range' and 'value' only.")
    }
    # create a search list for first time and append a new search list
    if(length(search) == 0){
      search = list(search_new)
    }else{
      search = list(search, search_new)
    }
  }
  return(search)
}

#shj <- .get_search_json(my_cohort)
#shj %>% toJSON()

# cohort_filtered_search = list(list("column" = list("id" = 2345,
#                                                    "instance" = 0,
#                                                    "array" = list("type" = "exact",
#                                                                   "value" = "0")
#                                                   ),
#                                                   "values" = c("Prefer not to answer","No")
#                                   )
#                               )
# onpage_filtered_serach = list(list("column" = list("id" = 31,
#                                                    "instance" = 0,
#                                                    "array" = list("type" = "exact",
#                                                                   "value" = "0")
#                                                    ),
#                                    "contains"= c("Male")
# ))
