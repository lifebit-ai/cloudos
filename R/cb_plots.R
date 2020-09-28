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
  
  # TODO use this to get applied filters
  #my_cohort <- .get_cohort_info(cloudos, cohort@id)
  
  filter_list <- cb_get_cohort_filters(cloudos, cohort)
  
  plot_list <- list()
  # check what kind of filter
  for(i in 1:length(filter_list)){
    # get filter id
    filter_id <- paste0("filter_id_", names(filter_list[i]))
    # get filter dataframe
    filter_df <- filter_list[[i]]
    # get the filtered values
    
    # make the plot
    if(ncol(filter_df) == 4){ # value - bar
      plot_list[[filter_id]] <- ggplot(data=filter_df, aes(x=label, y=number)) +
        geom_bar(stat="identity") 
    }else if(ncol(filter_df) == 3){ # range - histogram
      plot_list[[filter_id]] <- ggplot(data=filter_df, aes(x=`_id`, y=number)) +
        geom_bar(stat="identity") + 
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
    }else{
      stop("Unknown filter type. Accepts 'bar' and 'histogram' only.")
    }
  }
  return(plot_list)
}

# ggplot exposed objects, mark them as global
utils::globalVariables(c("label", "number", "_id"))
