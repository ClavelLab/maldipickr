# Evaluate the spectra regularities

Assess whether all the spectra in the list are not empty, of the same
length and correspond to profile data.

## Usage

``` r
check_spectra(spectra_list, tolerance = sqrt(.Machine$double.eps))
```

## Arguments

- spectra_list:

  A list of
  [MALDIquant::MassSpectrum](https://rdrr.io/pkg/MALDIquant/man/MassSpectrum-class.html)
  objects

- tolerance:

  A numeric indicating the accepted tolerance to the spectra length. The
  default value is the machine numerical precision and is close to
  1.5e-8.

## Value

A list of logical vectors of length `spectra_list` indicating if the
spectra are empty (`is_empty`), of an odd length (`is_outlier_length`)
or not a profile spectra (`is_not_regular`).

## See also

[process_spectra](https://clavellab.github.io/maldipickr/reference/process_spectra.md)

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
check_spectra(spectra_list)
#> $is_empty
#> [1] FALSE FALSE FALSE FALSE FALSE FALSE
#> 
#> $is_outlier_length
#> [1] FALSE FALSE FALSE FALSE FALSE FALSE
#> 
#> $is_not_regular
#> [1] FALSE FALSE FALSE FALSE FALSE FALSE
#> 
# The overall sanity can be checked with Reduce
Reduce(any, check_spectra(spectra_list)) # Should be FALSE
#> [1] FALSE
```
