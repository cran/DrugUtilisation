% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dailyDose.R
\name{addDailyDose}
\alias{addDailyDose}
\title{add daily dose information to a drug_exposure table}
\usage{
addDailyDose(drugExposure, ingredientConceptId, name = NULL)
}
\arguments{
\item{drugExposure}{drugExposure it must contain drug_concept_id, quantity,
drug_exposure_start_date and drug_exposure_end_date as columns}

\item{ingredientConceptId}{ingredientConceptId for which to filter the
drugs of interest}

\item{name}{Name of the computed table, if NULL a temporary table will be
generated.}
}
\value{
same input table
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}
}
\examples{
\donttest{
library(DrugUtilisation)
library(dplyr)

cdm <- mockDrugUtilisation()

cdm[["drug_exposure"]] |>
  filter(drug_concept_id == 2905077) |>
  addDailyDose(ingredientConceptId = 1125315)
}

}
