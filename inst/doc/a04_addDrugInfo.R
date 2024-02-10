## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(
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
conceptList <- getDrugIngredientCodes(cdm, c("acetaminophen"))
conceptList

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm <- generateDrugUtilisationCohortSet(
  cdm  = cdm,
  name = "acetaminophen_example1",
  conceptSet = conceptList
)

## ----message = FALSE, warning=FALSE-------------------------------------------
cdm[["drug_exposure"]] %>%
  addRoute() 

## ----eval = TRUE--------------------------------------------------------------
patternTable(cdm)

## ----eval = FALSE-------------------------------------------------------------
#  patternsWithFormula

## ----eval=TRUE----------------------------------------------------------------
addDailyDose(
  cdm$drug_exposure,
  cdm = cdm,
  ingredientConceptId = 1125315
)

## ----eval=TRUE----------------------------------------------------------------
suppressWarnings(dailyDoseCoverage(cdm, 1125315))

## ----message= FALSE, warning=FALSE--------------------------------------------
addDrugUse(
  cohort = cdm[["acetaminophen_example1"]],
  cdm    = cdm,
  ingredientConceptId = 1125315
)

## ----message= FALSE, warning=FALSE--------------------------------------------
addDrugUse(
  cohort = cdm[["acetaminophen_example1"]],
  cdm    = cdm,
  ingredientConceptId = 1125315,
  duration = TRUE,
  quantity = TRUE,
  dose     = TRUE
)

## ----cols.print=7, message=FALSE, warning=FALSE-------------------------------
cdm <- generateDrugUtilisationCohortSet(
  cdm = cdm,
  name = "acetaminophen_example2",
  conceptSet = conceptList,
  gapEra = 0
)
 
cdm$drug_exposure %>%
  filter(drug_concept_id %in% !!conceptList$acetaminophen) %>%
  filter(person_id == 56)

## ----cols.print=7, message=FALSE, warning=FALSE-------------------------------
cdm[["acetaminophen_example2"]] %>%
  addDrugUse(
    ingredientConceptId = 1125315,
    gapEra = 0
  ) %>%
  filter(subject_id == 56)

## ----cols.print=7, message=FALSE, warning=FALSE-------------------------------
cdm <- generateDrugUtilisationCohortSet(
  cdm = cdm,
  name = "acetaminophen_example3",
  conceptSet = conceptList,
  gapEra = 180
)

cdm$acetaminophen_example3 %>%
  addDrugUse(
    ingredientConceptId = 1125315,
    gapEra = 180,
    duration = TRUE,
    quantity = FALSE,
    dose = FALSE
  ) %>%
  filter(subject_id == 56) 

## ----cols.print=7, message=FALSE, warning=FALSE-------------------------------
cdm$acetaminophen_example3 %>%
  addDrugUse(
    ingredientConceptId = 1125315,
    gapEra = 0
  ) %>%
  filter(subject_id == 56) 

## ----eval=TRUE----------------------------------------------------------------
cdm[["acetaminophen_example1"]] %>%
  addDrugUse(cdm,
             ingredientConceptId = 1125315,
             gapEra = 30,
             eraJoinMode = "previous",
             overlapMode = "minimum",
             sameIndexMode = "minimum")


## ----message = FALSE, warning=FALSE-------------------------------------------
cdm[["acetaminophen_example1"]] <- cdm[["acetaminophen_example1"]] %>% 
  addDrugUse(
    cdm = cdm,
    ingredientConceptId = 1125315
  )

summariseDrugUse(cdm[["acetaminophen_example1"]])

## ----message = FALSE, warning=FALSE-------------------------------------------
cdm[["acetaminophen_example1"]] <- cdm[["acetaminophen_example1"]] %>%
  addSex(cdm) # Function from PatientProfiles

summariseDrugUse(cdm[["acetaminophen_example1"]],
                 strata = list("sex" = "sex")) 

