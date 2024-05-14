## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message = FALSE, warning = FALSE----------------------------------
library(DrugUtilisation)
library(CodelistGenerator)
library(dplyr)
library(CDMConnector)

cdm <- mockDrugUtilisation(numberIndividual = 200)

## -----------------------------------------------------------------------------
conceptSet_json <- codesFromConceptSet(here::here("inst/Concept"), cdm)
conceptSet_json

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
  overwrite = TRUE
)
cdm$asthma_1

## ----message=FALSE, warning=FALSE---------------------------------------------
cohortCount(cdm$asthma_1)

## ----message=FALSE, warning=FALSE---------------------------------------------
attrition(cdm$asthma_1)

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateConceptCohortSet(cdm,
  conceptSet = conceptSet_code,
  name = "asthma_2",
  end = "event_end_date",
  overwrite = TRUE
)
cdm$asthma_2

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateConceptCohortSet(cdm,
  conceptSet = conceptSet_code,
  name = "asthma_3",
  end = "observation_period_end_date",
  requiredObservation = c(10, 10),
  overwrite = TRUE
)
cdm$asthma_3

cohortCount(cdm$asthma_3)

attrition(cdm$asthma_3)

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "simvastin_1",
  conceptSet = conceptSet_ingredient
)
cdm$simvastin_1

cohortCount(cdm$simvastin_1)

attrition(cdm$simvastin_1)

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "simvastin_2",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf) # default as c(1, Inf)
)

attrition(cdm$simvastin_2)

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "simvastin_3",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 30 # default as 0
)

attrition(cdm$simvastin_3) %>% select(number_records, reason, excluded_records, excluded_subjects)

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "simvastin_4",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 30,
  priorUseWashout = 30
)

attrition(cdm$simvastin_4) %>% select(number_records, reason, excluded_records, excluded_subjects)


## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "simvastin_5",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 30,
  priorUseWashout = 30,
  priorObservation = 30
)

attrition(cdm$simvastin_5) %>% select(number_records, reason, excluded_records, excluded_subjects)

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "simvastin_6",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 30,
  priorUseWashout = 30,
  priorObservation = 30,
  cohortDateRange = as.Date(c("2010-01-01", "2011-01-01"))
)

attrition(cdm$simvastin_6) %>% select(number_records, reason, excluded_records, excluded_subjects)

## ----message=FALSE, warning=FALSE---------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "simvastin_7",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 30,
  priorUseWashout = 30,
  priorObservation = 30,
  cohortDateRange = as.Date(c("2010-01-01", "2011-01-01")),
  limit = "First"
)

attrition(cdm$simvastin_7) %>% select(number_records, reason, excluded_records, excluded_subjects)

## -----------------------------------------------------------------------------
cdm <- generateDrugUtilisationCohortSet(cdm,
  name = "simvastin_8",
  conceptSet = conceptSet_ingredient,
  imputeDuration = "none",
  durationRange = c(0, Inf),
  gapEra = 0,
  priorUseWashout = Inf,
  priorObservation = 0,
  cohortDateRange = as.Date(c(NA, NA)),
  limit = "First"
)

