% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generateDrugUtilisationCohortSet.R
\name{cohortGapEra}
\alias{cohortGapEra}
\title{Get the gapEra used to create a cohort}
\usage{
cohortGapEra(cohort, cohortId = NULL)
}
\arguments{
\item{cohort}{A \code{cohort_table} object.}

\item{cohortId}{Integer vector refering to cohortIds from cohort. If NULL all
cohort definition ids in settings will be used.}
}
\value{
gapEra values for the specific cohortIds
}
\description{
Get the gapEra used to create a cohort
}
\examples{
\donttest{
library(DrugUtilisation)
library(CodelistGenerator)

cdm <- mockDrugUtilisation()

druglist <- getDrugIngredientCodes(cdm = cdm,
                                   name = c("acetaminophen", "metformin"))

cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "drug_cohorts",
                                        conceptSet = druglist,
                                        gapEra = 100)

cohortGapEra(cdm$drug_cohorts)
}

}
