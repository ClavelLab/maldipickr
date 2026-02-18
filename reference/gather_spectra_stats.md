# Aggregate spectra quality-check statistics

Aggregate spectra quality-check statistics

## Usage

``` r
gather_spectra_stats(check_vectors)
```

## Arguments

- check_vectors:

  A list of logical vectors from
  [check_spectra](https://clavellab.github.io/maldipickr/reference/check_spectra.md)

## Value

A tibble of one row with the following 5 columns of integers:

- `n_spectra`: total number of raw spectra.

- `n_valid_spectra`: total number of spectra passing all quality checks

- `is_empty`, `is_outlier_length` and `is_not_regular`: total of spectra
  flagged with these irregularities.

## See also

[check_spectra](https://clavellab.github.io/maldipickr/reference/check_spectra.md)

## Examples

``` r
# Get an example directory of six Bruker MALDI Biotyper spectra
directory_biotyper_spectra <- system.file(
  "toy-species-spectra",
  package = "maldipickr"
)
# Import the six spectra
spectra_list <- import_biotyper_spectra(directory_biotyper_spectra)
# Display the list of checks, with FALSE where no anomaly is detected
checks <- check_spectra(spectra_list)
# Aggregate the statistics of quality-checked spectra
gather_spectra_stats(checks)
#> # A tibble: 1 × 5
#>   n_spectra n_valid_spectra is_empty is_outlier_length is_not_regular
#>       <int>           <int>    <int>             <int>          <int>
#> 1         6               6        0                 0              0
```
