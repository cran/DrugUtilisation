test_that("test summariseTreatment", {
  cdm <- mockDrugUtilisation(con = connection(), writeSchema = schema(), seed = 1)
  expect_no_error(
    x <- cdm$cohort1 |>
      summariseTreatment(
        treatmentCohortName = "cohort2",
        window = list(c(0, 30), c(31, 365))
      )
  )
  expect_true(inherits(x, "summarised_result"))
  expect_true(all(x$variable_level |> unique() == c("cohort_1", "cohort_2", "cohort_3", "untreated", "not in observation")))
  expect_true(all(x$additional_level |> unique() == c("0 to 30", "31 to 365")))

  # test concept works
  cdm <- generateDrugUtilisationCohortSet(
    cdm = cdm,
    conceptSet = list("a" = 1503327, "c" = 43135274, "b" = 2905077),
    name = "dus_cohort"
  )
  expect_no_error(
    x <- cdm$cohort1 |>
      summariseTreatment(
        treatmentCohortName = "dus_cohort",
        window = list(c(0, Inf))
      )
  )
  expect_true(inherits(x, "summarised_result"))
  expect_true(all(
    x |> dplyr::filter(group_level == "cohort_1") |> dplyr::pull("variable_level") ==
      c("a", "a", "b", "b", "c", "c", "untreated", "untreated", "not in observation", "not in observation")
  ))
  expect_true(all(x$additional_level |> unique() == c("0 to inf")))

  # test order in cohort works
  expect_no_error(
    x <- cdm$cohort1 |>
      summariseTreatment(
        treatmentCohortName = "cohort2",
        treatmentCohortId = c(3, 2),
        window = list(c(0, 30), c(31, 365))
      )
  )
  expect_true(inherits(x, "summarised_result"))
  expect_true(all(x$variable_level |> unique() == c("cohort_2", "cohort_3", "untreated", "not in observation")))
  expect_true(all(x$additional_level |> unique() == c("0 to 30", "31 to 365")))

  # test suppress
  x_sup <- omopgenerics::suppress(x, minCellCount = 100)
  expect_true(all(
    x_sup |>
      dplyr::filter(estimate_value != "0") |>
      dplyr::pull("estimate_value") == "-"
  ))

  mockDisconnect(cdm = cdm)
})

test_that("test addTreatment", {
  cdm <- mockDrugUtilisation(con = connection(), writeSchema = schema(), seed = 1)
  expect_no_error(
    x <- cdm$cohort1 |>
      addTreatment(
        treatmentCohortName = "cohort2",
        window = list(c(0, 30), c(31, 365)),
        mutuallyExclusive = FALSE
      )
  )
  mockDisconnect(cdm = cdm)
})

