# Extract spectra names and check for uniqueness

Given the list of raw spectra, `get_spectra_names()` extracts the
spectra names using the file metadata, and warns if the associated
sanitized names are not unique.

## Usage

``` r
get_spectra_names(spectra_list)
```

## Arguments

- spectra_list:

  A list of
  [MALDIquant::MassSpectrum](https://rdrr.io/pkg/MALDIquant/man/MassSpectrum-class.html)
  objects.

## Value

A tibble with four columns

- `sanitized_name`: spectra names based on `fullName` where dots and
  dashes are converted to underscores

- `name`: spectra name using the `name` label in the spectra metadata

- `fullName`: spectra full name using the `fullName` label in the
  spectra metadata

- `file`: the path to the raw spectra data

## Examples

``` r
# Get an example directory of six Bruker MALDI Biotyper spectra
directory_biotyper_spectra <- system.file(
  "toy-species-spectra",
  package = "maldipickr"
)
# Import the six spectra
spectra_list <- import_biotyper_spectra(directory_biotyper_spectra)
# Extract the names
get_spectra_names(spectra_list)
#> # A tibble: 6 × 4
#>   sanitized_name name         fullName     file                                 
#>   <chr>          <chr>        <chr>        <chr>                                
#> 1 species1_G2    species1.G2  species1.G2  /home/runner/.cache/R/renv/library/m…
#> 2 species2_E11   species2.E11 species2.E11 /home/runner/.cache/R/renv/library/m…
#> 3 species2_E12   species2.E12 species2.E12 /home/runner/.cache/R/renv/library/m…
#> 4 species3_F7    species3.F7  species3.F7  /home/runner/.cache/R/renv/library/m…
#> 5 species3_F8    species3.F8  species3.F8  /home/runner/.cache/R/renv/library/m…
#> 6 species3_F9    species3.F9  species3.F9  /home/runner/.cache/R/renv/library/m…

# Artificially create duplicated entries to show the warning
get_spectra_names(spectra_list[c(1,1)])
#> Warning: Non-unique values in spectra names!
#> 
#> Quickfix: use `dplyr::mutate(sanitized_name = base::make.unique(sanitized_name))`
#> # A tibble: 2 × 4
#>   sanitized_name name        fullName    file                                   
#>   <chr>          <chr>       <chr>       <chr>                                  
#> 1 species1_G2    species1.G2 species1.G2 /home/runner/.cache/R/renv/library/mal…
#> 2 species1_G2    species1.G2 species1.G2 /home/runner/.cache/R/renv/library/mal…
```
