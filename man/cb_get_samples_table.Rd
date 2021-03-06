% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cb_cohort_extract.R
\name{cb_get_samples_table}
\alias{cb_get_samples_table}
\title{Get samples table}
\usage{
cb_get_samples_table(cohort, page_number = 0, page_size = 10)
}
\arguments{
\item{cohort}{A cohort object. (Required)
See constructor functions \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}}

\item{page_number}{Number of page. (Optional) Default - 0}

\item{page_size}{Number of entries in a page. (Optional) Default - 10}
}
\value{
A dataframe.
}
\description{
Get samples (participants) table in a dataframe.
Optionally phenotypic filters can be applied as well.
}
