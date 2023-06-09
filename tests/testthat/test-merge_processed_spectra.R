# WARNING - Generated by {fusen} from dev/dereplicate-spectra.Rmd: do not edit by hand

directory_biotyper_spectra <- system.file("toy-species-spectra", package = "maldipickr")
spectra_list_test <- import_biotyper_spectra(directory_biotyper_spectra)[1:2]
processed_test <- process_spectra(spectra_list_test)
test_that("merge_processed_spectra works", {
  expect_equal(
    dim(merge_processed_spectra(list(processed_test))),
    c(2, 26)
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
  expect_error(
    list(
      createMassSpectrum(
        mass = 4500:5000,
        intensity = rep(0, 501),
        metaData = list(fullName = "foo")
      )
    ) %>% process_spectra() %>%
      list() %>% merge_processed_spectra(),
    "no list of MALDIquant::MassPeaks objects!"
  )
})
