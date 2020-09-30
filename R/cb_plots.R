#' @title Plot filters
#'
#' @description Get a list of ggplot objects, each plot having one filter.
#'
#' @param cloudos A cloudos object. (Required)
#' See constructor function \code{\link{connect_cloudos}} 
#' @param cohort A cohort object. (Required)
#' See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}
#'
#' @return A list of ggplot objects
#' @import ggplot2
#'
#' @export
cb_plot_filters <- function(cloudos, cohort){
  # get cohort information so this can be used to get names
  # and applied filters
  my_cohort <- .get_cohort_info(cloudos, cohort@id)
  # get filter dataframe list, this is independent of cohort info
  filter_df_list <- cb_get_cohort_filters(cloudos, cohort)
  # empty ggplot list
  plot_list <- list()
  # run though all the filters in the cohort
  for(filter_number in 1:length(my_cohort$fields)){
    fields <-  my_cohort$fields[[filter_number]]
    fields_id <- fields$field$id
    fields_name <- fields$field$name
    # run though all the filter dataframe
    for(i in 1:length(filter_df_list)){
      filter_id <- paste0("filter_id_", names(filter_df_list[i]))
      filter_df <- filter_df_list[[i]]
      # get the one filter dataframe which matches with cohort
      # and then plot
      if(names(filter_df_list[i]) == fields_id){
        # make the plot
        if(ncol(filter_df) == 4){ # value - bar
          # TODO use this to get applied filters on the plot
          # morefileds
          # more_fields <-  my_cohort$moreFields[[filter_number]]
          # value <- 
          plot_list[[filter_id]] <- ggplot(data=filter_df, aes(x=label, y=number)) +
            geom_bar(stat="identity") + coord_flip() + 
            labs(title= fields_name)
        }else if(ncol(filter_df) == 3){ # range - histogram
          # TODO use this to get applied filters on the plot
          # morefileds
          # more_fields <-  my_cohort$moreFields[[filter_number]]
          # range <- more_fields$range
          plot_list[[filter_id]] <- ggplot(data=filter_df, aes(x=`_id`, y=number)) +
            geom_bar(stat="identity") + 
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
            labs(title= fields_name) +
            xlab(label = "range")
        }else{
          stop("Unknown filter type. Accepts 'bar' and 'histogram' only.")
        }
      }
    }
  }
  return(plot_list)
}

# ggplot exposed objects, mark them as global
utils::globalVariables(c("label", "number", "_id"))
