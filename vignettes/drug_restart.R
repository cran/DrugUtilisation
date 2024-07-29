## ----include = FALSE----------------------------------------------------------
  knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
  )

## ----message = FALSE, warning = FALSE-----------------------------------------
library(DrugUtilisation)
library(CDMConnector)
library(CodelistGenerator)
library(PatientProfiles)
library(dplyr)

cdm <- mockDrugUtilisation(numberIndividual  = 200)

## ----message = FALSE, warning = FALSE-----------------------------------------
# codelists
metformin <- getDrugIngredientCodes(cdm = cdm, name = "metformin")
insulin <- getDrugIngredientCodes(cdm = cdm, name = "insulin detemir")

cdm <- generateDrugUtilisationCohortSet(
  cdm = cdm, name = "metformin", conceptSet = metformin
)
cdm$metformin |> cohortCount()

cdm <- generateDrugUtilisationCohortSet(
  cdm = cdm, name = "insulin", conceptSet = insulin
)
cdm$insulin |> cohortCount()

