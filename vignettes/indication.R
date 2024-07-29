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

## ----setup , message= FALSE, warning=FALSE------------------------------------
library(DrugUtilisation)
library(DBI)
library(duckdb)
library(CDMConnector)
library(dplyr)
library(PatientProfiles)


con <- DBI::dbConnect(duckdb::duckdb(), eunomia_dir())

cdm <- CDMConnector::cdm_from_con(
  con = con,
  cdm_schema = "main",
  write_schema = "main"
)

## ----eval=TRUE, message= FALSE, warning=FALSE---------------------------------
conceptList <- CodelistGenerator::getDrugIngredientCodes(cdm, "acetaminophen")
conceptList

## ----eval=TRUE, message= FALSE, warning=FALSE---------------------------------
cdm <- generateDrugUtilisationCohortSet(
  cdm = cdm,
  name = "acetaminophen_users",
  conceptSet = conceptList,
  limit = "All",
  gapEra = 30,
  priorUseWashout = 0
)

## ----eval=TRUE, message= FALSE, warning=FALSE---------------------------------
indications <-
  list(
    sinusitis = c(257012, 4294548, 40481087),
    bronchitis = c(260139, 258780)
  )

cdm <-
  CDMConnector::generateConceptCohortSet(cdm, name = "indications_cohort", indications)

cohortCount(cdm[["indications_cohort"]]) |>
  left_join(
    settings(cdm[["indications_cohort"]]) |>
      select(cohort_definition_id, cohort_name),
    by = "cohort_definition_id"
  )


## ----eval=TRUE, message= FALSE, warning=FALSE---------------------------------

cdm[["acetaminophen_users"]] |>
  addIndication(
    indicationCohortName = "indications_cohort",
    indicationWindow =  list(c(0,0),c(-30,0),c(-365,0)),
    unknownIndicationTable =  c("condition_occurrence")
  )


## ----eval=TRUE, message= FALSE, warning=FALSE---------------------------------
# cdm[["acetaminophen_users"]] |>
#   addIndication(
#     cdm = cdm, 
#     indicationCohortName = "indications_cohort",
#     indicationGap =  c(0, 30, 365),
#     unknownIndicationTable =  c("condition_occurrence")
#   ) |>
#   summariseIndication(cdm) |>
#   select("variable_name", "estimate_name", "estimate_value")


## ----eval=TRUE, message= FALSE, warning=FALSE---------------------------------

# cdm[["acetaminophen_users"]] |>
#   addDemographics(ageGroup = list(c(0, 19), c(20, 150))) |>
#   addIndication(
#     cdm = cdm,
#     indicationCohortName = "indications_cohort",
#     indicationGap =  c(0),
#     unknownIndicationTable =  c("condition_occurrence")
#   ) |>
#   summariseIndication(
#     cdm,
#     strata = list("age" = "age_group", "sex" = "sex")) |>
#       select("variable_name", "estimate_name", "estimate_value","strata_name")


