## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message = FALSE, warning=FALSE-------------------------------------------
library(DrugUtilisation)
library(CodelistGenerator)
library(CDMConnector)
library(dplyr)
library(PatientProfiles)

cdm <- mockDrugUtilisation(numberIndividual = 200)

new_cohort_set <- settings(cdm$cohort1) %>%
  dplyr::arrange(cohort_definition_id) %>%
  dplyr::mutate(cohort_name = c("asthma","bronchitis","pneumonia"))

cdm$cohort1 <- cdm$cohort1 |>
  newCohortTable(cohortSetRef = new_cohort_set)

new_cohort_set <- settings(cdm$cohort2) %>%
  dplyr::arrange(cohort_definition_id) %>%
  dplyr::mutate(cohort_name = c("albuterol","fluticasone","montelukast"))

cdm$cohort2 <- cdm$cohort2 |>
  newCohortTable(cohortSetRef = new_cohort_set)


## ----message = FALSE, warning=FALSE-------------------------------------------
settings(cdm$cohort1)

## ----message = FALSE, warning=FALSE-------------------------------------------
settings(cdm$cohort2)

## ----message = FALSE, warning=FALSE-------------------------------------------
summariseTreatmentFromCohort(cohort = cdm$cohort1,
                   treatmentCohortName = c("cohort2"),
                   window = list(c(0,0), c(1,30)))

## ----message = FALSE, warning=FALSE-------------------------------------------
cdm[["cohort1"]] <- cdm[["cohort1"]] %>%
  addSex() %>%
  addAge(ageGroup = list("<40" = c(0, 39), ">40" = c(40, 150)))

summariseTreatmentFromCohort(cohort = cdm$cohort1,
                   treatmentCohortName = c("cohort2"),
                   window = list(c(0,0)),
                   treatmentCohortId = 1,
                   strata = list("sex" = "sex", "age" = "age_group")
                   )

