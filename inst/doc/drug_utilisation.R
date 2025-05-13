## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message = FALSE, warning = FALSE----------------------------------
library(DrugUtilisation)

cdm <- mockDrugUtilisation(numberIndividual = 200)
cdm$cohort1 |>
  dplyr::glimpse()

## ----message = FALSE, warning = FALSE-----------------------------------------
drugConcepts <- CodelistGenerator::getDrugIngredientCodes(cdm = cdm, name = c("acetaminophen", "simvastatin"))

## ----message = FALSE, warning = FALSE-----------------------------------------
cohort <- addNumberExposures(
  cohort = cdm$cohort1, # cohort with the population of interest
  conceptSet = drugConcepts, # concepts of the drugs of interest
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  nameStyle = "number_exposures_{concept_name}",
  name = NULL
)

cohort |>
  dplyr::glimpse()

## ----message = FALSE, warning = FALSE-----------------------------------------
cohort <- addNumberEras(
  cohort = cdm$cohort1, # cohort with the population of interest
  conceptSet = drugConcepts, # concepts of the drugs of interest
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  gapEra = 3,
  restrictIncident = TRUE,
  nameStyle = "{concept_name}",
  name = NULL
)

cohort |>
  dplyr::glimpse()

## ----eval = FALSE-------------------------------------------------------------
#  addDrugUtilisation(
#    cohort,
#    indexDate = "cohort_start_date",
#    censorDate = "cohort_end_date",
#    ingredientConceptId = NULL,
#    conceptSet = NULL,
#    restrictIncident = TRUE,
#    gapEra = 1,
#    numberExposures = TRUE,
#    numberEras = TRUE,
#    daysExposed = TRUE,
#    daysPrescribed = TRUE,
#    timeToExposure = TRUE,
#    initialExposureDuration = TRUE,
#    initialQuantity = TRUE,
#    cumulativeQuantity = TRUE,
#    initialDailyDose = TRUE,
#    cumulativeDose = TRUE,
#    nameStyle = "{value}_{concept_name}_{ingredient}",
#    name = NULL
#  )

## ----eval = TRUE--------------------------------------------------------------
cdm$drug_utilisation_example <- cdm$cohort1 |>
  # add end of current observation date with the package PatientProfiels
  PatientProfiles::addFutureObservation(futureObservationType = "date") |>
  # add the targeted drug utilisation measures
  addDrugUtilisation(
    indexDate = "cohort_end_date",
    censorDate = "future_observation",
    ingredientConceptId = c(1125315, 1503297),
    conceptSet = NULL,
    restrictIncident = TRUE,
    gapEra = 7,
    numberExposures = FALSE,
    numberEras = FALSE,
    daysExposed = FALSE,
    daysPrescribed = FALSE,
    timeToExposure = FALSE,
    initialExposureDuration = FALSE,
    initialQuantity = TRUE,
    cumulativeQuantity = TRUE,
    initialDailyDose = TRUE,
    cumulativeDose = TRUE,
    nameStyle = "{value}_{concept_name}_{ingredient}",
    name = "drug_utilisation_example"
  )

cdm$drug_utilisation_example |>
  dplyr::glimpse()

## ----eval = TRUE--------------------------------------------------------------
duResults <- summariseDrugUtilisation(
  cohort = cdm$cohort1,
  strata = list(),
  estimates = c(
    "q25", "median", "q75", "mean", "sd", "count_missing",
    "percentage_missing"
  ),
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  ingredientConceptId = c(1125315, 1503297),
  conceptSet = NULL,
  restrictIncident = TRUE,
  gapEra = 7,
  numberExposures = TRUE,
  numberEras = TRUE,
  daysExposed = TRUE,
  daysPrescribed = TRUE,
  timeToExposure = TRUE,
  initialExposureDuration = TRUE,
  initialQuantity = TRUE,
  cumulativeQuantity = TRUE,
  initialDailyDose = TRUE,
  cumulativeDose = TRUE
)

duResults |>
  dplyr::glimpse()

## ----eval = TRUE--------------------------------------------------------------
duResults <- cdm$cohort1 |>
  # add age and sex
  PatientProfiles::addDemographics(
    age = TRUE,
    ageGroup = list("<=50" = c(0, 50), ">50" = c(51, 150)),
    sex = TRUE,
    priorObservation = FALSE,
    futureObservation = FALSE
  ) |>
  # drug utilisation
  summariseDrugUtilisation(
    strata = list("age_group", "sex", c("age_group", "sex")),
    estimates = c("mean", "sd", "count_missing", "percentage_missing"),
    indexDate = "cohort_start_date",
    censorDate = "cohort_end_date",
    ingredientConceptId = c(1125315, 1503297),
    conceptSet = NULL,
    restrictIncident = TRUE,
    gapEra = 7,
    numberExposures = TRUE,
    numberEras = TRUE,
    daysExposed = TRUE,
    daysPrescribed = TRUE,
    timeToExposure = TRUE,
    initialExposureDuration = TRUE,
    initialQuantity = TRUE,
    cumulativeQuantity = TRUE,
    initialDailyDose = TRUE,
    cumulativeDose = TRUE
  )

duResults |>
  dplyr::glimpse()

## ----eval = TRUE--------------------------------------------------------------
tableDrugUtilisation(duResults)

