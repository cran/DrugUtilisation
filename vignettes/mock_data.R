## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, warning = FALSE---------------------------------------------------
library(DrugUtilisation)

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm <- mockDrugUtilisation()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$person |> 
  dplyr::glimpse()

cdm$person |>
  dplyr::tally()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$concept |> 
  dplyr::glimpse()

cdm$concept |>
  dplyr::tally()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$visit_occurrence |> 
  dplyr::glimpse()

cdm$visit_occurrence |>
  dplyr::tally()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$cohort1 |> 
  dplyr::glimpse()

cdm$cohort1 |>
  dplyr::tally()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$cohort2 |> 
  dplyr::glimpse()

cdm$cohort2 |>
  dplyr::tally()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm <- mockDrugUtilisation(
  seed = 789
)

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$cohort1 |> 
  dplyr::glimpse()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm <- mockDrugUtilisation(numberIndividual = 100)

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$person |>
  dplyr::glimpse()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$person |>
  dplyr::tally()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$visit_occurrence |>
  dplyr::glimpse()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$visit_occurrence |>
  dplyr::tally()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm <- mockDrugUtilisation(
    drug_exposure = dplyr::tibble(
      drug_exposure_id = 1:3,
      person_id = c(1, 1, 1),
      drug_concept_id = c(2, 3, 4),
      drug_exposure_start_date = as.Date(c(
        "2000-01-01", "2000-01-10", "2000-02-20"
      )),
      drug_exposure_end_date = as.Date(c(
        "2000-02-10", "2000-03-01", "2000-02-20"
      )),
      quantity = c(41, 52, 1),
      drug_type_concept_id = 0
    )
  )

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$drug_exposure |>
  dplyr::glimpse()

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm <- mockDrugUtilisation(
  observation_period = dplyr::tibble(
      observation_period_id = 1,
      person_id = 1:2,
      observation_period_start_date = as.Date("1900-01-01"),
      observation_period_end_date = as.Date("2100-01-01"),
      period_type_concept_id = 0
    ),
    cohort1 = dplyr::tibble(
      cohort_definition_id = 1,
      subject_id = c(1, 1, 2),
      cohort_start_date = as.Date(c("2000-01-01", "2001-01-01", "2000-01-01")),
      cohort_end_date = as.Date(c("2000-03-01", "2001-03-01", "2000-03-01"))
    )
  )

## ----message= FALSE, warning=FALSE--------------------------------------------
cdm$cohort1 |> 
  dplyr::glimpse()

