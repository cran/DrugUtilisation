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

.addDailyDose <- function(drugExposure,
                          ingredientConceptId,
                          name = NULL) {
  cdm <- omopgenerics::cdmReference(drugExposure)
  nm <- omopgenerics::uniqueTableName(omopgenerics::tmpPrefix())

  # select only pattern_id and unit
  dailyDose <- drugExposure |>
    dplyr::select(
      "drug_concept_id", "drug_exposure_start_date", "drug_exposure_end_date",
      "quantity"
    ) |>
    dplyr::distinct() %>%
    dplyr::mutate(days_exposed = !!CDMConnector::datediff(
      start = "drug_exposure_start_date",
      end = "drug_exposure_end_date"
    ) + 1) |>
    dplyr::inner_join(
      drugStrengthPattern(cdm = cdm, ingredientConceptId = ingredientConceptId),
      by = "drug_concept_id"
    ) |>
    standardUnits() |>
    applyFormula() |>
    dplyr::select(
      "drug_concept_id", "drug_exposure_start_date", "drug_exposure_end_date",
      "quantity", "daily_dose", "unit"
    ) |>
    dplyr::compute(temporary = FALSE, overwrite = TRUE, name = nm)

  # add the information back to the initial table
  drugExposure <- drugExposure |>
    dplyr::left_join(
      dailyDose,
      by = c(
        "drug_concept_id", "drug_exposure_start_date", "drug_exposure_end_date",
        "quantity"
      )
    )

  drugExposure <- drugExposure |> compute2(name)

  cdm <- omopgenerics::dropSourceTable(cdm = cdm, name = nm)

  return(drugExposure)
}

#' Check coverage of daily dose computation in a sample of the cdm for selected
#' concept sets and ingredient
#'
#' @inheritParams cdmDoc
#' @inheritParams ingredientConceptIdDoc
#' @param estimates Estimates to obtain.
#' @param sampleSize Maximum number of records of an ingredient to estimate dose
#'  coverage. If an ingredient has more, a random sample equal to `sampleSize`
#'  will be considered. If NULL, all records will be used.
#'
#' @return The function returns information of the coverage of computeDailyDose.R
#' for the selected ingredients and concept sets
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315)
#' }
#'
summariseDoseCoverage <- function(cdm,
                                  ingredientConceptId,
                                  estimates = c(
                                    "count_missing", "percentage_missing",
                                    "mean", "sd", "q25", "median", "q75"
                                  ),
                                  sampleSize = NULL) {
  # initial checks
  cdm <- omopgenerics::validateCdmArgument(cdm)
  omopgenerics::assertNumeric(ingredientConceptId, integerish = TRUE, length = 1)
  omopgenerics::assertNumeric(x = sampleSize, min = 0, length = 1, null = TRUE, integerish = TRUE)
  omopgenerics::assertCharacter(estimates)

  # get daily dosage
  dailyDose <- cdm[["drug_exposure"]] |>
    dplyr::inner_join(
      cdm[["concept_ancestor"]] |>
        dplyr::filter(.data$ancestor_concept_id %in% .env$ingredientConceptId) |>
        dplyr::select("drug_concept_id" = "descendant_concept_id") |>
        dplyr::distinct(),
      by = "drug_concept_id"
    ) |>
    dplyr::select(
      "drug_concept_id", "drug_exposure_start_date", "drug_exposure_end_date",
      "quantity"
    ) %>%
    dplyr::mutate(days_exposed = !!CDMConnector::datediff(
      start = "drug_exposure_start_date",
      end = "drug_exposure_end_date"
    ) + 1) |>
    dplyr::left_join(
      drugStrengthPattern(cdm = cdm, ingredientConceptId = ingredientConceptId),
      by = "drug_concept_id"
    ) |>
    standardUnits() |>
    applyFormula() |>
    dplyr::select(
      "drug_concept_id", "daily_dose", "unit", "pattern_id",
      "concept_id" = "ingredient_concept_id"
    ) |>
    .addRoute() |>
    dplyr::left_join(
      cdm[["concept"]] |>
        dplyr::rename("ingredient_name" = "concept_name") |>
        dplyr::select("concept_id", "ingredient_name"),
      by = "concept_id"
    ) |>
    dplyr::collect()

  if (!is.null(sampleSize)) {
    dailyDose <- dailyDose |>
      dplyr::group_by(.data$ingredient_name) |>
      dplyr::sample_n(size = as.integer(sampleSize), replace = FALSE) |>
      dplyr::ungroup()
    sampleSize <- as.character(sampleSize)
  } else {
    sampleSize <- "Inf"
  }

  # summarise
  dailyDoseSummary <- dailyDose |>
    dplyr::mutate(dplyr::across(
      c("route", "unit", "pattern_id", "ingredient_name"),
      ~ dplyr::if_else(is.na(.x), "missing", as.character(.x))
    )) |>
    PatientProfiles::summariseResult(
      group = list("ingredient_name"),
      includeOverallGroup = FALSE,
      strata = list("unit", c("route", "unit"), c("unit", "route", "pattern_id")),
      includeOverallStrata = TRUE,
      variables = "daily_dose",
      estimates = estimates
    ) |>
    dplyr::filter(
      !(.data$strata_name %in% c("Overall", "route")) |
        .data$variable_name != "daily_dose" |
        .data$estimate_name %in% c("count", "percentage")
    ) |>
    dplyr::mutate(
      "cdm_name" = omopgenerics::cdmName(cdm),
      variable_name = dplyr::if_else(
        grepl("missing", .data$estimate_name), "Missing dose", .data$variable_name
      )
    )
  dailyDoseSummary <- dailyDoseSummary |>
    omopgenerics::newSummarisedResult(settings = dplyr::tibble(
      "result_id" = unique(dailyDoseSummary$result_id),
      "package_name" = "DrugUtilisation",
      "package_version" = pkgVersion(),
      "result_type" = "summarise_dose_coverage",
      "sample_size" = sampleSize
    ))

  return(dailyDoseSummary)
}

standardUnits <- function(drugExposure) {
  drugExposure |>
    dplyr::mutate(
      amount_value = dplyr::if_else(
        .data$amount_unit_concept_id == 9655,
        .data$amount_value / 1000, .data$amount_value
      ),
      numerator_value = dplyr::if_else(
        .data$numerator_unit_concept_id == 9655,
        .data$numerator_value / 1000, .data$numerator_value
      ),
      denominator_value = dplyr::if_else(
        .data$denominator_unit_concept_id == 8519,
        .data$denominator_value * 1000, .data$denominator_value
      ),
      numerator_value = dplyr::if_else(
        .data$numerator_unit_concept_id == 9439,
        .data$numerator_value / 1000000, .data$numerator_value
      )
    )
}
applyFormula <- function(drugExposure) {
  drugExposure |>
    dplyr::mutate(
      daily_dose = dplyr::case_when(
        is.na(.data$quantity) ~
          as.numeric(NA),
        .data$quantity <= 0 ~
          as.numeric(NA),
        .data$days_exposed <= 0 ~
          as.numeric(NA),
        .data$denominator_value <= 0 ~
          as.numeric(NA),
        .data$numerator_value <= 0 ~
          as.numeric(NA),
        .data$amount_value <= 0 ~
          as.numeric(NA),
        .data$formula_name == "concentration formulation" ~
          .data$numerator_value * .data$quantity / .data$days_exposed,
        .data$formula_name == "fixed amount formulation" ~
          .data$amount_value * .data$quantity / .data$days_exposed,
        .data$formula_name == "time based with denominator" & .data$denominator_value > 24 ~
          .data$numerator_value * 24 / .data$denominator_value,
        .data$formula_name == "time based with denominator" & .data$denominator_value <= 24 ~
          .data$numerator_value,
        .data$formula_name == "time based no denominator" ~
          .data$numerator_value * 24,
        .default = as.numeric(NA)
      )
    )
}
