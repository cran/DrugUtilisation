## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup,message= FALSE, warning=FALSE--------------------------------------
library(DrugUtilisation)
library(CodelistGenerator)
library(CDMConnector)
library(dplyr)
con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
connectionDetails <- list(
  con = con,
  writeSchema = "main",
  cdmPrefix = NULL,
  writePrefix = NULL
)
cdm <- mockDrugUtilisation(
  connectionDetails = connectionDetails,
  numberIndividual = 100
)

## -----------------------------------------------------------------------------
#get concept from json file using readConceptList from this package or CodelistGenerator
conceptSet_json_1 <- readConceptList(here::here("inst/Concept"), cdm)
conceptSet_json_2 <- codesFromConceptSet(here::here("inst/Concept"), cdm)

conceptSet_json_1
conceptSet_json_2

## -----------------------------------------------------------------------------
#get concept using code directly
conceptSet_code <- list(asthma = 317009)
conceptSet_code

## ----message=FALSE, warning=FALSE---------------------------------------------
#get concept by ingredient
conceptSet_ingredient <- getDrugIngredientCodes(cdm, name = "simvastatin")
conceptSet_ingredient

## ----message=FALSE, warning=FALSE---------------------------------------------
#get concept from ATC codes
conceptSet_ATC <- getATCCodes(cdm, 
                              level = "ATC 1st", 
                              name = "ALIMENTARY TRACT AND METABOLISM")
conceptSet_ATC

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateConceptCohortSet(cdm,
  conceptSet = conceptSet_code,
  name = "asthma_1",
  end = "observation_period_end_date",
  requiredObservation = c(10, 10),
  overwrite = TRUE
)
cdm$asthma_1

## ----message=FALSE, warning=FALSE---------------------------------------------
cohortCount(cdm$asthma_1)

## ----message=FALSE, warning=FALSE---------------------------------------------
cohortAttrition(cdm$asthma_1)

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateConceptCohortSet(cdm,
  conceptSet = conceptSet_code,
  name = "asthma_2",
  end = "event_end_date",
  requiredObservation = c(10, 10),
  overwrite = TRUE
)
cdm$asthma_2

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateConceptCohortSet(cdm,
  conceptSet = conceptSet_code,
  name = "asthma_3",
  end = "observation_period_end_date",
  requiredObservation = c(1, 1),
  overwrite = TRUE
)
cdm$asthma_3

cohortCount(cdm$asthma_3)

cohortAttrition(cdm$asthma_3)

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "dus_alleras",
  conceptSet = conceptSet_ingredient
)
cdm$dus_alleras

cohortCount(cdm$dus_alleras)

cohortAttrition(cdm$dus_alleras) %>% select(number_records, reason, excluded_records, excluded_subjects)


## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "dus_step2_0_inf",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf) # default as c(1, Inf)
)

cohortAttrition(cdm$dus_step2_0_inf) %>% select(number_records, reason, excluded_records, excluded_subjects)


## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "dus_step3_alleras",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 30 # default as 0
)

cohortAttrition(cdm$dus_step3_alleras) %>% select(number_records, reason, excluded_records, excluded_subjects)


## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "dus_alleras_step4",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 30,
  priorUseWashout = 30
)

cohortAttrition(cdm$dus_alleras_step4) %>% select(number_records, reason, excluded_records, excluded_subjects)


## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "dus_alleras_step5",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 30,
  priorUseWashout = 30,
  priorObservation = 30
)

cohortAttrition(cdm$dus_alleras_step5) %>% select(number_records, reason, excluded_records, excluded_subjects)


## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "dus_alleras_step67",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 30,
  priorUseWashout = 30,
  priorObservation = 30,
  cohortDateRange = as.Date(c("2010-01-01", "2011-01-01")),
  limi = "All"
)

cohortAttrition(cdm$dus_alleras_step67) %>% select(number_records, reason, excluded_records, excluded_subjects)

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "dus_step8_firstera",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 30,
  priorUseWashout = 30,
  priorObservation = 30,
  cohortDateRange = as.Date(c("2010-01-01", "2011-01-01")),
  limit = "First"
)

cohortAttrition(cdm$dus_step8_firstera) %>% select(number_records, reason, excluded_records, excluded_subjects)


## -----------------------------------------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "dus_step8_firstever",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 0,
  priorUseWashout = Inf,
  priorObservation = 0,
  cohortDateRange = as.Date(c(NA, NA)),
  limit = "First"
)

## -----------------------------------------------------------------------------
DBI::dbDisconnect(con, shutdown = TRUE)

