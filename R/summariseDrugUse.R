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
#' `r lifecycle::badge("defunct")`
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
summariseDrugUse <- function(cohort,
                             cdm = lifecycle::deprecated(),
                             strata = list(),
                             estimates = c(
                               "min", "q05", "q25", "median", "q75", "q95",
                               "max", "mean", "sd", "count_missing",
                               "percentage_missing"
                             ),
                             minCellCount = lifecycle::deprecated()) {
  lifecycle::deprecate_stop(
    when = "0.7.0",
    what = "summariseDrugUse()",
    with = "summariseDrugUtilisation()"
  )
}
