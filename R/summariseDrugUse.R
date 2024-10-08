# Copyright 2024 DARWIN EU (C)
#
# This file is part of DrugUtilisation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' This function is used to summarise the dose table over multiple cohorts.
#'
#' `r lifecycle::badge("deprecated")`
#'
#' @param cohort Cohort with drug use variables and strata.
#' @param cdm Deprecated.
#' @param strata Stratification list.
#' @param estimates Estimates that we want for the columns.
#' @param minCellCount Deprecated.
#'
#' @return A summary of the drug use stratified by cohort_name and strata_name
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(PatientProfiles)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- CodelistGenerator::getDrugIngredientCodes(cdm, "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(
#'   cdm, "dus_cohort", codelist
#' )
#' cdm[["dus_cohort"]] <- cdm[["dus_cohort"]] |>
#'   addDrugUse(ingredientConceptId = 1125315)
#' result <- summariseDrugUse(cdm[["dus_cohort"]])
#' print(result)
#'
#' cdm[["dus_cohort"]] <- cdm[["dus_cohort"]] |>
#'   addSex() |>
#'   addAge(ageGroup = list("<40" = c(0, 39), ">=40" = c(40, 150)))
#'
#' cdm[["dus_cohort"]] |>
#'   summariseDrugUse(strata = list("age_group", "sex", c("age_group", "sex")))
#' }
#'
summariseDrugUse <- function(cohort,
                             cdm = lifecycle::deprecated(),
                             strata = list(),
                             estimates = c(
                               "min", "q05", "q25", "median", "q75", "q95",
                               "max", "mean", "sd", "count_missing",
                               "percentage_missing"
                             ),
                             minCellCount = lifecycle::deprecated()) {
  if (lifecycle::is_present(cdm)) {
    lifecycle::deprecate_warn(when = "0.5.0", what = "summariseDrugUse(cdm = )")
  }
  if (lifecycle::is_present(minCellCount)) {
    lifecycle::deprecate_warn(when = "0.5.0", what = "summariseDrugUse(minCellCount = )")
  }
  cdm <- omopgenerics::cdmReference(cohort)
  # check inputs
  checkInputs(
    cohort = cohort, cdm = cdm, strata = strata,
    estimates = estimates
  )

  # update cohort_names
  cohort <- cohort |>
    PatientProfiles::addCohortName() |>
    dplyr::collect()

  # summarise drug use columns
  result <- PatientProfiles::summariseResult(
    table = cohort, group = list("cohort_name" = "cohort_name"),
    strata = strata, variables = drugUseColumns(cohort),
    estimates = estimates
  ) |>
    dplyr::mutate(
      cdm_name = dplyr::coalesce(omopgenerics::cdmName(cdm), as.character(NA))
    )

  result <- result |>
    omopgenerics::newSummarisedResult(settings = dplyr::tibble(
      result_id = unique(result$result_id),
      result_type = "summarised_drug_use",
      package_name = "DrugUtilisation",
      package_version = as.character(utils::packageVersion("DrugUtilisation"))
    ))

  return(result)
}

#' Obtain automatically the drug use columns
#'
#' @param cohort A cohort
#'
#' @return Name of the drug use columns
#'
#' @noRd
#'
drugUseColumns <- function(cohort) {
  cohort |>
    dplyr::select(
      dplyr::any_of(c(
        "number_exposures", "duration", "cumulative_quantity", "number_eras",
        "initial_quantity", "impute_daily_dose_percentage", "impute_duration_percentage"
      )),
      dplyr::starts_with("initial_daily_dose"),
      dplyr::starts_with("cumulative_dose")
    ) |>
    colnames()
}
