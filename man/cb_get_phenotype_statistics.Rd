% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cb_filter_explore.R
\name{cb_get_phenotype_statistics}
\alias{cb_get_phenotype_statistics}
\title{Get distribution of a phenotype in a cohort}
\usage{
cb_get_phenotype_statistics(
  cohort,
  pheno_id,
  max_depth = Inf,
  page_number = "all",
  page_size = 1000
)
}
\arguments{
\item{cohort}{A cohort object. (Required)
See constructor function \code{\link{cb_create_cohort}} or \code{\link{cb_load_cohort}}}

\item{pheno_id}{A phenotype ID. (Required)}

\item{max_depth}{The maximum depth to descend in a 'nested list' phenotype. (Default: Inf)}

\item{page_number}{For internal use.}

\item{page_size}{For internal use.}
}
\value{
A data frame holding distribution data.
}
\description{
Retrieve a data frame containing the distirbution data for a specific phenotype within a cohort.
}
