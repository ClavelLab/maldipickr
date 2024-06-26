# WARNING - Generated by {fusen} from dev/dereplicate-spectra.Rmd: do not edit by hand

directory_biotyper_spectra <- system.file("toy-species-spectra", package = "maldipickr")
spectra_list_test <- import_biotyper_spectra(directory_biotyper_spectra)[1:2]
processed_test <- process_spectra(spectra_list_test)
test_that("merge_processed_spectra works", {
  expect_no_error(
    fm <- merge_processed_spectra(list(processed_test))
  )
  expect_equal(
    dim(fm), c(2, 26)
  )
  expect_identical(
    sum(fm == 0), 0L
  )
  expect_no_error(
    fm_multiple <- merge_processed_spectra(
      list("with_name_bar" = processed_test, "with_name_foo" = processed_test)
    )
  )
  expect_equal(
    dim(fm_multiple), c(4, 26)
  )
})
test_that("merge_processed_spectra works without interpolation", {
  expect_no_error(
    fm_no_interpolation <- merge_processed_spectra(
      list(processed_test),
      interpolate_missing = FALSE
    )
  )
  expect_equal(
    dim(fm_no_interpolation), c(2, 26)
  )
  expect_identical(
    sum(fm_no_interpolation == 0), 9L
  )
})
test_that("merge_processed_spectra fails with the wrong input", {
  expect_error(
    merge_processed_spectra(list()),
    "is not a list or it is an empty list."
  )
  expect_error(
    merge_processed_spectra("foo"),
    "is not a list or it is an empty list."
  )
})

test_that("merge_processed_spectra fails with only empty peaks", {
  expect_warning(
      empty_peaks <- list(
        createMassSpectrum(
          mass = 4500:5000,
          intensity = rep(0, 501),
          metaData = list(fullName = "foo")
        )
      ) %>% process_spectra(spectra_names = tibble::tibble(sanitized_name = "foo")),
    "MassSpectrum object is empty!"
  )
  expect_warning(
    expect_error(
      list(empty_peaks) %>%
        merge_processed_spectra(),
      "no list of MALDIquant::MassPeaks objects!"
    ),
    "No peaks were detected in the following spectra, so they will be removed"
  )
})

# How to create the RDS example for testing `merge_processed_spectra`
# three_spectra_with_one_peakless <- c(
#   spectra_list_test,
#   createMassSpectrum(
#     mass = 2000:20000,
#     intensity = rep.int(3L, 18001),
#     metaData = list(fullName = "peakless.H12")
#   )
# )
# three_processed_spectra_with_one_peakless <- process_spectra(
#   three_spectra_with_one_peakless,
#   rds_prefix = "three_processed_spectra_with_one_peakless"
# )
test_that("merge_processed_spectra works with one peakless spectra and RDS input", {
  expect_warning(
    three_processed_spectra_with_one_peakless <- merge_processed_spectra(
      list(
        system.file("three_processed_spectra_with_one_peakless.RDS",
                  package = "maldipickr")
      )
    ),
    "No peaks were detected in the following spectra, so they will be removed"
  )
  expect_equal(
    dim(three_processed_spectra_with_one_peakless), c(2, 26)
  )
  expect_identical(
    sum(three_processed_spectra_with_one_peakless == 0), 0L
  )
})
