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
#' @import dplyr
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
        # check the type of filter
        if(ncol(filter_df) == 4){ ############################## value - bar
          # to make sure we getting morefileds for same filter as fields
          for(j in 1:length(my_cohort$moreFields)){
            more_fields_id <- my_cohort$moreFields[[j]]$fieldId
            if(fields_id == more_fields_id){
              more_fields <- my_cohort$moreFields[[j]]
            }
          }
          filtered_values_colour <- .filtered_values_colour(more_fields, fields)
          # plot
          plot_list[[filter_id]] <- ggplot(data=filter_df, aes(x=label, y=number, fill = label)) +
            geom_bar(stat="identity") + coord_flip() + 
            labs(title= fields_name) + 
            scale_fill_manual(values =  filtered_values_colour) + 
            theme_classic() + 
            theme(legend.position="none") 
        }else if(ncol(filter_df) == 3){ ############################### range - histogram
          # to make sure we getting morefileds for same filter as fields
          for(j in 1:length(my_cohort$moreFields)){
            more_fields_id <- my_cohort$moreFields[[j]]$fieldId
            if(fields_id == more_fields_id){
              more_fields <- my_cohort$moreFields[[j]]
            }
          }
          # take only the data required from the dataframe
          filter_df_sel <- subset(filter_df, select = -c(total))
          names(filter_df_sel) <- c("range", "number")
          # get a dataframe with colours based on applied filters
          filtered_range_colour_df <- .filtered_range_colour_df(df = filter_df_sel, more_fields = more_fields)
          # plot
          plot_list[[filter_id]] <- ggplot(data=filtered_range_colour_df, aes(x=range, y=number)) +
            geom_histogram(stat="identity", fill= filtered_range_colour_df$color_value) + 
            scale_x_discrete(limits = filtered_range_colour_df$range) +
            theme_classic() +
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), 
                  panel.grid.major.x = element_blank(),
                  panel.grid.major.y = element_line( size=.1, color="black")) + 
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

# cloudos colour code 
# selected filters - #94C3C1 (bit darker bluegreen)
# Unselested filters - #C8EAD6 (light green)

.filtered_values_colour <- function(more_fields, fields){
  # make a value vector
  my_values <- c()
  for(i in 1:length(more_fields$value)){
    value_id <- as.numeric(more_fields$value[[i]][1])
    my_values <- c(my_values, fields$field$values[[as.character(value_id)]])
  }
  all_values <- c()
  for(i in 1:length(fields$field$values)){
    all_values <- c(all_values, fields$field$values[[i]])
  }
  # generate the colour vector
  my_value_color <- c()
  for(i in all_values){
      if(i %in% my_values){
        my_value_color <- c(my_value_color, "#94C3C1")
      }else{
        my_value_color <- c(my_value_color, "#C8EAD6")
    }
  }
  return(my_value_color)
}

.filtered_range_colour_df <- function(more_fields, df){
  
  range_from <- more_fields$range$from
  range_to <- more_fields$range$to
  new_df <- df %>% 
    mutate(color_value = case_when(range > range_from & range < range_to ~ "#94C3C1",
                                    TRUE ~ "#C8EAD6"))
  
  return(new_df)
}

# ggplot exposed objects, mark them as global
utils::globalVariables(c("label", "number", "_id", "total"))
