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

## -----------------------------------------------------------------------------
library(CDMConnector)
library(PatientProfiles)
library(DrugUtilisation)
library(CohortSurvival)
library(dplyr)

db <- DBI::dbConnect(duckdb::duckdb(), 
                     dbdir = eunomia_dir())
cdm <- cdm_from_con(
  con = db,
  cdm_schema = "main", 
  write_schema = "main", 
  cdm_name = "Eunomia"
)

cdm <- generateIngredientCohortSet(cdm = cdm,
                                   name = "amoxicillin",
                                   ingredient = "amoxicillin", 
                                   gapEra = 7) 
cdm$amoxicillin <- cdm$amoxicillin |> 
  requireIsFirstDrugEntry()

discontinuation_summary <- estimateSingleEventSurvival(cdm, 
                                    targetCohortTable = "amoxicillin", 
                                    outcomeCohortTable = "amoxicillin", 
                                    outcomeDateVariable = "cohort_end_date", 
                                    followUpDays = 90, 
                                    eventGap = 30)

## ----out.width="75%"----------------------------------------------------------
plotSurvival(discontinuation_summary)

## -----------------------------------------------------------------------------
tableSurvival(discontinuation_summary)

## -----------------------------------------------------------------------------
cdm$amoxicillin <- cdm$amoxicillin |> 
  addDemographics(ageGroup = list(c(0, 40),
                                  c(41, Inf))) |> 
  compute(temporary = FALSE, name = "amoxicillin")

discontinuation_summary <- estimateSingleEventSurvival(cdm, 
                                                       strata = list(c("age_group"),
                                                                     c("sex")),
                                    targetCohortTable = "amoxicillin", 
                                    outcomeCohortTable = "amoxicillin", 
                                    outcomeDateVariable = "cohort_end_date", 
                                    followUpDays = 90, 
                                    eventGap = 30)

## ----out.width="75%"----------------------------------------------------------
plotSurvival(discontinuation_summary, 
             facet = "strata_level")

## -----------------------------------------------------------------------------
tableSurvival(discontinuation_summary)

