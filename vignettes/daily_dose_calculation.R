## ----include = FALSE----------------------------------------------------------
if (Sys.getenv("EUNOMIA_DATA_FOLDER") == "") Sys.setenv("EUNOMIA_DATA_FOLDER" = tempdir())
if (!dir.exists(Sys.getenv("EUNOMIA_DATA_FOLDER"))) dir.create(Sys.getenv("EUNOMIA_DATA_FOLDER"))
if (!CDMConnector::eunomia_is_available()) CDMConnector::downloadEunomiaData()
knitr::opts_chunk$set(
  warning = FALSE,
  message = FALSE,
  collapse = TRUE,
  comment = "#>"
)

## ----message= FALSE, warning=FALSE--------------------------------------------
library(DrugUtilisation)
library(CodelistGenerator)
library(CDMConnector)
library(dplyr)
library(PatientProfiles)

cdm <- mockDrugUtilisation(numberIndividual  = 200)

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$drug_exposure |>
  filter(drug_concept_id == 2905077) |>
  addDailyDose(ingredientConceptId = 1125315) |>
  glimpse()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$drug_exposure |>
  addRoute() |>
  glimpse()

## ----message= FALSE, warning=FALSE--------------------------------------------
patternTable(cdm) |>
  glimpse()

## ----message= FALSE, warning=FALSE--------------------------------------------
patternsWithFormula |>
  glimpse()

## ----message= FALSE, warning=FALSE--------------------------------------------
summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315) |>
  glimpse()

## ----message= FALSE, warning=FALSE--------------------------------------------
summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315) |>
  tableDoseCoverage()

## ----message= FALSE, warning=FALSE--------------------------------------------
summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315) |>
  tableDoseCoverage(cdmName = F)

## ----message= FALSE, warning=FALSE--------------------------------------------
summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315) |>
  tableDoseCoverage(.options = list(title = "Title of summariseDoseCoverage"))

