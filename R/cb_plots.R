#' @title Plot filters
#'
#' @description Get a list of ggplot objects, each plot having one filter.
#'
#' @param filter_list The output of \code{\link{cb_get_cohort_filters}} (Required)
#'
#' @return A list
#' @import ggplot2
#'
#' @export
cb_plot_filters <- function(filter_list){ # latter the input will be a cohort object
  plot_list <- list()
  # check what kind of filter
  for(i in 1:length(filter_list)){
    df <- filter_list[[i]]
    if(ncol(df) == 4){ # value
      plot_list[[i]] <- ggplot(data=df, aes(x=label, y=number)) +
        geom_bar(stat="identity") 
    }else if(ncol(df) == 3){ # range
      plot_list[[i]] <- ggplot(data=df, aes(x=`_id`, y=number)) +
        geom_bar(stat="identity")
    }else{
      stop("Unknown filter type. Accepts 'range' and 'value' only.")
    }
  }
  return(plot_list)
}

# ggplot exposed objects, mark them as global
utils::globalVariables(c("label", "number", "_id"))
