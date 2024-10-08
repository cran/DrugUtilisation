% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/require.R
\name{requireIsFirstDrugEntry}
\alias{requireIsFirstDrugEntry}
\title{Restrict cohort to only the first cohort record per subject}
\usage{
requireIsFirstDrugEntry(
  cohort,
  cohortId = NULL,
  name = omopgenerics::tableName(cohort)
)
}
\arguments{
\item{cohort}{A cohort table in a cdm reference.}

\item{cohortId}{IDs of the cohorts to modify. The default is NULL meaning all
cohorts will be used; otherwise, only the specified cohorts will be modified,
and the rest will remain unchanged.}

\item{name}{Name of the table with the filtered cohort records. The default
name is the original cohort name, where the original table will be
overwritten.}
}
\value{
The cohort table having applied the first entry requirement.
}
\description{
Filter the cohort table keeping only the first cohort record per subject.
}
\examples{
\donttest{
library(DrugUtilisation)
library(dplyr)

cdm <- mockDrugUtilisation()

cdm$cohort1 <- cdm$cohort1 |>
  requireIsFirstDrugEntry()

attrition(cdm$cohort1) |> glimpse()
}

}
