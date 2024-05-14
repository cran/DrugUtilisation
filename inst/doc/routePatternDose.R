## ----eval = TRUE--------------------------------------------------------------
library(DrugUtilisation)
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
# Add route information to the drug table
addRoute(cdm$drug_exposure)


## ----eval = TRUE--------------------------------------------------------------

patternTable(cdm)


## ----eval = FALSE-------------------------------------------------------------
#  
#  patternsWithFormula
#  

## ----eval=TRUE----------------------------------------------------------------

addDailyDose(
  cdm$drug_exposure,
  cdm = cdm,
  ingredientConceptId = 1125315
)

## ----eval=TRUE----------------------------------------------------------------

suppressWarnings(dailyDoseCoverage(cdm, 1125315))



## ----eval=TRUE----------------------------------------------------------------
library(CodelistGenerator)
cdm <- mockDrugUtilisation()
cdm <- generateDrugUtilisationCohortSet(
  cdm, "dus_cohort", getDrugIngredientCodes(cdm, "acetaminophen")
)
cdm[["dus_cohort"]] %>%
  addDrugUse(cdm,
             duration = TRUE,
             quantity = TRUE,
             dose = TRUE,
             1125315)


## ----eval=TRUE----------------------------------------------------------------
cdm[["dus_cohort"]] %>%
  addDrugUse(cdm,
             ingredientConceptId = 1125315,
             gapEra = 30,
             eraJoinMode = "previous",
             overlapMode = "minimum",
             sameIndexMode = "minimum")


## -----------------------------------------------------------------------------
DBI::dbDisconnect(con, shutdown = TRUE)

