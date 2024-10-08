% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pattern.R
\name{addRoute}
\alias{addRoute}
\title{add route column to a table containing drug_exposure information}
\usage{
addRoute(drugTable)
}
\arguments{
\item{drugTable}{Table in the cdm that must contain drug_concept_id}
}
\value{
It adds route to the current table
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
  addRoute()
}

}
