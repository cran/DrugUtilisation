test_that("test benchmarking function", {
  skip_on_cran()

  con <- duckdb::dbConnect(duckdb::duckdb(), CDMConnector::eunomiaDir())
  cdm <- CDMConnector::cdmFromCon(
    con = con, cdmSchema = "main", writeSchema = "main"
  )

  initialTables <- omopgenerics::listSourceTables(cdm =  cdm)

  expect_no_error(result <- benchmarkDrugUtilisation(cdm = cdm))
  expect_true(inherits(result, "summarised_result"))

  finalTables <- omopgenerics::listSourceTables(cdm =  cdm) |>
    purrr::keep(\(x) !startsWith(x, "og_"))
  expect_identical(initialTables, finalTables)

  cdm <- CDMConnector::generateConceptCohortSet(
    cdm = cdm,
    conceptSet = list(viral_sinusitis = 40481087),
    name = "indication",
    limit = "all",
    end = 0
  )
  expect_no_error(benchmarkDrugUtilisation(
    cdm = cdm, indicationCohort = "indication"
  ))

  mockDisconnect(cdm = cdm)
})
