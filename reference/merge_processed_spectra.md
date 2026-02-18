# Merge multiple processed spectra and peaks

Aggregate multiple processed spectra, their associated peaks and
metadata into a feature matrix and a concatenated metadata table.

## Usage

``` r
merge_processed_spectra(
  processed_spectra,
  remove_peakless_spectra = TRUE,
  interpolate_missing = TRUE
)
```

## Arguments

- processed_spectra:

  A [list](https://rdrr.io/r/base/list.html) of the processed spectra
  and associated peaks and metadata in two possible formats:

  - A list of **in-memory objects** (named `spectra`, `peaks`,
    `metadata`) produced by
    [process_spectra](https://clavellab.github.io/maldipickr/reference/process_spectra.md).
    Named lists will have names dropped, see Note.

  - **\[deprecated\]** A list of **paths** to RDS files produced by
    [process_spectra](https://clavellab.github.io/maldipickr/reference/process_spectra.md)
    when using the `rds_prefix` option.

- remove_peakless_spectra:

  A logical indicating whether to discard the spectra without detected
  peaks.

- interpolate_missing:

  A logical indicating if intensity values for missing peaks should be
  interpolated from the processed spectra signal or left NA which would
  then be converted to 0.

## Value

A *n*×*p* matrix, with *n* spectra as rows and *p* features as columns
that are the peaks found in all the processed spectra.

## Note

When aggregating multiple runs of processed spectra, if a named list is
provided, note that the names will be dropped, to prevent further
downstream issues when these names were being appended to the rownames
of the matrix thus preventing downstream metadata merge.

## See also

[process_spectra](https://clavellab.github.io/maldipickr/reference/process_spectra.md),
the "Value" section in
[[`MALDIquant::intensityMatrix`](https://rdrr.io/pkg/MALDIquant/man/intensityMatrix-functions.html)](https://rdrr.io/cran/MALDIquant/man/intensityMatrix-functions.html)

## Examples

``` r
# Get an example directory of six Bruker MALDI Biotyper spectra
directory_biotyper_spectra <- system.file(
  "toy-species-spectra",
  package = "maldipickr"
)
# Import the six spectra
spectra_list <- import_biotyper_spectra(directory_biotyper_spectra)
# Transform the spectra signals according to Strejcek et al. (2018)
processed <- process_spectra(spectra_list)
# Merge the spectra to produce the feature matrix
fm <- merge_processed_spectra(list(processed))
# The feature matrix has 6 spectra as rows and
#  35 peaks as columns
dim(fm)
#> [1]  6 35
# Notice the difference when the interpolation is turned off
fm_no_interpolation <- merge_processed_spectra(
  list(processed),
  interpolate_missing = FALSE
)
sum(fm == 0) # 0
#> [1] 0
sum(fm_no_interpolation == 0) # 68
#> [1] 68

# Multiple runs can be aggregated using list()
# Merge the spectra to produce the feature matrix
fm_all <- merge_processed_spectra(list(processed, processed, processed))
# The feature matrix has 3×6=18 spectra as rows and
#  35 peaks as columns
dim(fm_all)
#> [1] 18 35

# If using a list, names will be dropped and are not propagated to the matrix.
if (FALSE) { # \dontrun{
fm_all <- merge_processed_spectra(
 list("A" = processed, "B" = processed, "C" = processed))
any(grepl("A|B|C", rownames(fm_all))) # FALSE
 } # }
```
