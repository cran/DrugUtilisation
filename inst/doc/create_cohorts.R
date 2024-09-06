## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(DrugUtilisation)

cdm <- mockDrugUtilisation(numberIndividuals = 100, seed = 1)

cdm

## -----------------------------------------------------------------------------
conceptSet <- list(acetaminophen = c(1, 2, 3))
conceptSet

## -----------------------------------------------------------------------------
conceptSet <- list(acetaminophen = c(1, 2, 3)) |> omopgenerics::newCodelist()
conceptSet
conceptSet$acetaminophen

## -----------------------------------------------------------------------------
conceptSet <- list(acetaminophen = dplyr::tibble(
  concept_id = 1125315,
  excluded = FALSE,
  descendants = TRUE,
  mapped = FALSE
)) |>
  omopgenerics::newConceptSetExpression()
conceptSet
conceptSet$acetaminophen

## -----------------------------------------------------------------------------
library(CodelistGenerator)

## -----------------------------------------------------------------------------
codes <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
codes[["161_acetaminophen"]]

## -----------------------------------------------------------------------------
codes <- codesFromConceptSet(path = system.file("acetaminophen.json", package = "DrugUtilisation"), cdm = cdm)
codes

## ----echo = FALSE, fig.width = 7, fig.height = 4------------------------------
dplyr::tibble(
  drug_exposure_id = c(1, 2, 3, 4),
  start = as.Date(c("2020-01-01", "2020-01-20", "2020-03-15", "2020-04-20")),
  end = as.Date(c("2020-01-30", "2020-02-15", "2020-04-19", "2020-05-15"))
) |>
  tidyr::pivot_longer(c("start", "end")) |>
  dplyr::mutate(lab = format(value, "%d %b")) |>
  ggplot2::ggplot(ggplot2::aes(x = value, y = drug_exposure_id, group = drug_exposure_id, label = lab)) +
  ggplot2::geom_point(size = 5) +
  ggplot2::geom_line(linewidth = 2) +
  ggplot2::lims(y = c(0.5, 4.5)) +
  ggplot2::geom_text(nudge_y = 0.2) +
  ggplot2::geom_line(
    data = dplyr::tibble(
      y = c(1.5, 2.5, 3.5),
      type = c("overlap", "gap", "gap"),
      start = as.Date(c("2020-01-20", "2020-03-15", "2020-04-20")),
      end = as.Date(c("2020-01-30", "2020-02-15", "2020-04-19"))
    ) |>
      tidyr::pivot_longer(c("start", "end")),
    mapping = ggplot2::aes(x = value, y = y, group = y, color = type),
    inherit.aes = FALSE,
    linewidth = 2
  ) +
  ggtext::geom_richtext(
    data = dplyr::tibble(
      y = c(1.5, 2.5, 3.5),
      type = c("overlap", "gap", "gap"),
      lab = c("overlap", "gap = 29 days", "gap = 1 day"),
      start = as.Date(c("2020-01-25", "2020-03-01", "2020-04-19"))
    ),
    mapping = ggplot2::aes(x = start, y = y, group = y, color = type, label = lab),
    inherit.aes = FALSE,
    nudge_y = 0.2
  ) +
  # ggplot2::ggtitle("subject_id = 1") +
  ggplot2::ylab("Drug exposure id") +
  ggplot2::xlab("Time") +
  ggplot2::theme(legend.position = "none")

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x <- dplyr::tibble(
  "cohort_definition_id" = 1L,
  "subject_id" = 1L,
  "cohort_start_date" = as.Date(c("2020-01-01", "2020-03-15", "2020-04-20")),
  "cohort_end_date" = as.Date(c("2020-02-15", "2020-04-19", "2020-05-15"))
)
print(x)
x |>
  dplyr::mutate(record_id = dplyr::row_number()) |>
  tidyr::pivot_longer(c("cohort_start_date", "cohort_end_date")) |>
  ggplot2::ggplot(ggplot2::aes(x = value, y = 1, group = record_id, label = value)) +
  ggplot2::geom_line(linewidth = 1.5) +
  ggplot2::geom_point(size = 3, shape = 15, ggplot2::aes(color = name)) +
  ggplot2::lims(y = c(0.5, 1.5)) +
  ggplot2::ylab(" ") +
  ggplot2::xlab("Time") +
  ggplot2::theme(legend.position = "none", axis.ticks.y = ggplot2::element_blank())

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x <- dplyr::tibble(
  "cohort_definition_id" = 1L,
  "subject_id" = 1L,
  "cohort_start_date" = as.Date(c("2020-01-01", "2020-03-15")),
  "cohort_end_date" = as.Date(c("2020-02-15", "2020-05-15"))
)
print(x)
x |>
  dplyr::mutate(record_id = dplyr::row_number()) |>
  tidyr::pivot_longer(c("cohort_start_date", "cohort_end_date")) |>
  ggplot2::ggplot(ggplot2::aes(x = value, y = 1, group = record_id, label = value)) +
  ggplot2::geom_line(linewidth = 1.5) +
  ggplot2::geom_point(size = 3, shape = 15, ggplot2::aes(color = name)) +
  ggplot2::lims(y = c(0.5, 1.5)) +
  ggplot2::ylab(" ") +
  ggplot2::xlab("Time") +
  ggplot2::theme(legend.position = "none", axis.ticks.y = ggplot2::element_blank())

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x <- dplyr::tibble(
  "cohort_definition_id" = 1L,
  "subject_id" = 1L,
  "cohort_start_date" = as.Date(c("2020-01-01")),
  "cohort_end_date" = as.Date(c("2020-05-15"))
)
print(x)
x |>
  dplyr::mutate(record_id = dplyr::row_number()) |>
  tidyr::pivot_longer(c("cohort_start_date", "cohort_end_date")) |>
  ggplot2::ggplot(ggplot2::aes(x = value, y = 1, group = record_id, label = value)) +
  ggplot2::geom_line(linewidth = 1.5) +
  ggplot2::geom_point(size = 3, shape = 15, ggplot2::aes(color = name)) +
  ggplot2::lims(y = c(0.5, 1.5)) +
  ggplot2::ylab(" ") +
  ggplot2::xlab("Time") +
  ggplot2::theme(legend.position = "none", axis.ticks.y = ggplot2::element_blank())

## ----messages = TRUE----------------------------------------------------------
codes <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
names(codes) <- "acetaminophen"
cdm <- generateDrugUtilisationCohortSet(cdm = cdm, name = "acetaminophen_cohort", conceptSet = codes, gapEra = 30)
cdm

## -----------------------------------------------------------------------------
cdm$drug_exposure |>
  dplyr::filter(drug_concept_id %in% !!codes$acetaminophen & person_id == 69)

## -----------------------------------------------------------------------------
cdm$acetaminophen_cohort |>
  dplyr::filter(subject_id == 69)

## -----------------------------------------------------------------------------
attrition(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
cdm$drug_exposure |>
  dplyr::filter(drug_concept_id %in% !!codes$acetaminophen & person_id == 50)

## -----------------------------------------------------------------------------
cdm$acetaminophen_cohort |>
  dplyr::filter(subject_id == 50)

## -----------------------------------------------------------------------------
settings(cdm$acetaminophen_cohort)
cohortCount(cdm$acetaminophen_cohort)
cohortCodelist(cdm$acetaminophen_cohort, cohortId = 1)

## -----------------------------------------------------------------------------
cdm$acetaminophen_cohort <- cdm$acetaminophen_cohort |>
  requirePriorDrugWashout(days = 365)

## -----------------------------------------------------------------------------
cdm$acetaminophen_cohort

## -----------------------------------------------------------------------------
settings(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
cohortCount(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
attrition(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
codes <- getDrugIngredientCodes(cdm = cdm, name = c("metformin", "simvastatin"))
cdm <- generateDrugUtilisationCohortSet(cdm = cdm, name = "my_cohort", conceptSet = codes, gapEra = 30)
cdm
settings(cdm$my_cohort)
cdm$my_new_cohort <- cdm$my_cohort |>
  requirePriorDrugWashout(days = 365, cohortId = 2, name = "my_new_cohort")
cdm
attrition(cdm$my_new_cohort)

## -----------------------------------------------------------------------------
cdm$acetaminophen_cohort <- cdm$acetaminophen_cohort |>
  requireIsFirstDrugEntry()

## -----------------------------------------------------------------------------
cdm$acetaminophen_cohort

## -----------------------------------------------------------------------------
settings(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
cohortCount(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
attrition(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
cdm$acetaminophen_cohort <- cdm$acetaminophen_cohort |>
  requireObservationBeforeDrug(days = 365)

## -----------------------------------------------------------------------------
cdm$acetaminophen_cohort

## -----------------------------------------------------------------------------
settings(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
cohortCount(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
attrition(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
cdm$acetaminophen_cohort <- cdm$acetaminophen_cohort |>
  requireDrugInDateRange(
    indexDate = "cohort_start_date",
    dateRange = as.Date(c("2000-01-01", "2020-12-31"))
  )

## -----------------------------------------------------------------------------
cdm$acetaminophen_cohort

## -----------------------------------------------------------------------------
settings(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
cohortCount(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
attrition(cdm$acetaminophen_cohort)

## -----------------------------------------------------------------------------
cdm$my_new_cohort <- cdm$my_new_cohort |>
  requireDrugInDateRange(dateRange = as.Date(c(NA, "2010-12-31")))
attrition(cdm$my_new_cohort)

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x <- dplyr::tibble(
  "cohort_start_date" = as.Date(c("2010-03-01", "2011-02-15", "2012-03-05", "2013-06-15")),
  "cohort_end_date" = as.Date(c("2010-05-15", "2012-01-01", "2012-05-12", "2013-08-12"))
)
y <- dplyr::tibble(
  start = x$cohort_end_date[-nrow(x)] + 1, end = x$cohort_start_date[-1] - 1
) |>
  dplyr::mutate(
    record_id = dplyr::row_number(),
    distance = as.numeric(end - start + 1),
    mean = start + distance / 2,
    distance = paste0(distance, " days")
  ) |>
  tidyr::pivot_longer(c("start", "end"))
x |>
  dplyr::mutate(record_id = dplyr::row_number()) |>
  tidyr::pivot_longer(c("cohort_start_date", "cohort_end_date")) |>
  ggplot2::ggplot(ggplot2::aes(x = value, y = 1, group = record_id, label = value)) +
  ggplot2::geom_line(linewidth = 1.5) +
  ggplot2::lims(y = c(0.8, 1.2)) +
  ggplot2::geom_point(
    ggplot2::aes(x = as.Date("2010-01-01"), y = 1),
    shape = 23, color = "#00AF6A", size = 5, fill = "#00AF6A"
  ) +
  ggplot2::geom_text(
    ggplot2::aes(x = as.Date("2010-01-01"), y = 0.92, label = "Start observation", hjust = "left"),
    color = "#00AF6A"
  ) +
  ggplot2::geom_line(
    data = y,
    ggplot2::aes(x = value, y = 1.05, group = record_id, color = "red"),
    linewidth = 1.1
  ) +
  ggplot2::geom_text(data = y, ggplot2::aes(x = mean, y = 1.09, label = distance), nudge_y = 0.008) +
  ggplot2::xlim(as.Date(c("2010-01-01", "2014-01-01"))) +
  ggplot2::ylab("") +
  ggplot2::xlab("Time") +
  ggplot2::theme(
    legend.position = "none",
    axis.ticks.y = ggplot2::element_blank(),
    axis.text.y = ggplot2::element_blank()
  )

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
colours <- c("#ffb3b3", "#2d862d")
doplot <- function(x) {
  x |>
    dplyr::mutate(record_id = dplyr::row_number()) |>
    tidyr::pivot_longer(c("cohort_start_date", "cohort_end_date")) |>
    ggplot2::ggplot(ggplot2::aes(
      x = value, y = 1, group = record_id, label = value, color = color
    )) +
    ggplot2::geom_line(linewidth = 1.5) +
    ggplot2::lims(y = c(0.75, 1.25)) +
    ggplot2::xlim(as.Date(c("2010-01-01", "2014-01-01"))) +
    ggplot2::ylab("") +
    ggplot2::xlab("Time") +
    ggplot2::scale_color_manual(values = colours) +
    ggplot2::theme(
      legend.position = "none",
      axis.ticks.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank()
    )
}
x <- dplyr::tibble(
  "cohort_start_date" = as.Date(c("2010-03-01", "2011-02-15", "2012-03-05", "2013-06-15")),
  "cohort_end_date" = as.Date(c("2010-05-15", "2012-01-01", "2012-05-12", "2013-08-12"))
)
x |>
  dplyr::mutate(color = as.factor(c(1, 0, 0, 0))) |>
  doplot() +
  ggplot2::ggtitle("first + washout")

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x |>
  dplyr::mutate(color = as.factor(c(0, 0, 0, 1))) |>
  doplot() +
  ggplot2::ggtitle("washout + first")

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x |>
  dplyr::mutate(color = as.factor(c(0, 0, 0, 0))) |>
  doplot() +
  ggplot2::ggtitle("first + minObs")

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x |>
  dplyr::mutate(color = as.factor(c(0, 1, 0, 0))) |>
  doplot() +
  ggplot2::ggtitle("minObs + first")

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x |>
  dplyr::mutate(color = as.factor(c(0, 0, 0, 0))) |>
  doplot() +
  ggplot2::ggtitle("first + 2011-2012")

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x |>
  dplyr::mutate(color = as.factor(c(0, 1, 0, 0))) |>
  doplot() +
  ggplot2::ggtitle("2011-2012 + first")

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x |>
  dplyr::mutate(color = as.factor(c(0, 0, 0, 1))) |>
  doplot() +
  ggplot2::ggtitle("washout + first")

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x |>
  dplyr::mutate(color = as.factor(c(0, 1, 0, 1))) |>
  doplot() +
  ggplot2::ggtitle("minObs + washout")

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x |>
  dplyr::mutate(color = as.factor(c(0, 0, 0, 0))) |>
  doplot() +
  ggplot2::ggtitle("washout + 2011-2012")

## ----echo = FALSE, fig.width = 7, fig.height = 2------------------------------
x |>
  dplyr::mutate(color = as.factor(c(0, 1, 0, 0))) |>
  doplot() +
  ggplot2::ggtitle("2011-2012 + washout")

