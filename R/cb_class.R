#' This S4 class creates a cohort object object.
#'
#' This will create a main cohort object, which will 
#' hold many information related to a cohort. 
#'
#' @slot cohort A single cohort
#' @slot filter A cohort filter
#'
#' @name cohort-class
#' @rdname cohort-class
#' @export
setClass("cohort", slots = list(cohort = "list",
                                filter = "list")
)