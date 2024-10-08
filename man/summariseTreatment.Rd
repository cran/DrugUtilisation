% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summariseTreatment.R
\name{summariseTreatment}
\alias{summariseTreatment}
\title{This function is used to summarise treatments received}
\usage{
summariseTreatment(
  cohort,
  window,
  treatmentCohortName,
  treatmentCohortId = NULL,
  strata = list(),
  indexDate = "cohort_start_date",
  censorDate = NULL,
  minCellCount = lifecycle::deprecated()
)
}
\arguments{
\item{cohort}{A cohort table in a cdm reference.}

\item{window}{Time window over which to summarise the treatments.}

\item{treatmentCohortName}{Name of a cohort in the cdm that contains the
treatments of interest.}

\item{treatmentCohortId}{Cohort definition id of interest from
treatmentCohortName.}

\item{strata}{List with column names or vectors of column names groups to
stratify results by.}

\item{indexDate}{Variable in x that contains the date to compute the
intersection.}

\item{censorDate}{Whether to censor overlap events at a specific date or a
column date of x. If NULL, end of observation will be used.}

\item{minCellCount}{\verb{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}}}
}
\value{
A summary of treatments stratified by cohort_name and strata_name
}
\description{
This function is used to summarise treatments received
}
\examples{
\donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()
cdm$cohort1 |>
  summariseTreatment(
    treatmentCohortName = "cohort2",
    window = list(c(0, 30), c(31, 365))
  )
}

}
