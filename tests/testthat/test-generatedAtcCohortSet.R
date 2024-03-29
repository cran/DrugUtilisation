test_that("test same results for ingredient cohorts", {
  cdm <- DrugUtilisation::mockDrugUtilisation()

  cdm <- generateAtcCohortSet(cdm = cdm, name = "test_cohort_1")

  cdm <- DrugUtilisation::generateDrugUtilisationCohortSet(
    cdm = cdm,
    conceptSet = CodelistGenerator::getATCCodes(cdm),
    name = "test_cohort_2"
  )

  # Collect data from DuckDB tables into R data frames
  cohort_1_df <- cdm$test_cohort_1 %>% dplyr::collect()
  cohort_2_df <- cdm$test_cohort_2 %>% dplyr::collect()
  attr(cohort_1_df, "cohort_set") <- attr(cohort_1_df, "cohort_set") |>
    dplyr::select(-"dose_form")

  expect_equal(cohort_1_df, cohort_2_df)

})

