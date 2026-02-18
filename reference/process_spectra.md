# Process Bruker MALDI Biotyper spectra *à la* Strejcek et al. (2018)

Process Bruker MALDI Biotyper spectra *à la* Strejcek et al. (2018)

## Usage

``` r
process_spectra(
  spectra_list,
  spectra_names = get_spectra_names(spectra_list),
  rds_prefix = deprecated()
)
```

## Arguments

- spectra_list:

  A list of
  [MALDIquant::MassSpectrum](https://rdrr.io/pkg/MALDIquant/man/MassSpectrum-class.html)
  objects.

- spectra_names:

  A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
  (or [data.frame](https://rdrr.io/r/base/data.frame.html)) of sanitized
  spectra names by default from
  [get_spectra_names](https://clavellab.github.io/maldipickr/reference/get_spectra_names.md).
  If provided manually, the column `sanitized_name` will be used to name
  the spectra.

- rds_prefix:

  **\[deprecated\]** Writing to disk as RDS is no longer supported. A
  character indicating the prefix for the `.RDS` output files to be
  written in the `processed` directory. By default, no prefix are given
  and thus no files are written.

## Value

A named list of three objects:

- `spectra`: a list the length of the spectra list of
  [MALDIquant::MassSpectrum](https://rdrr.io/pkg/MALDIquant/man/MassSpectrum-class.html)
  objects.

- `peaks`: a list the length of the spectra list of
  [MALDIquant::MassPeaks](https://rdrr.io/pkg/MALDIquant/man/MassPeaks-class.html)
  objects.

- `metadata`: a tibble indicating the median signal-to-noise ratio
  (`SNR`) and peaks number for all spectra list (`peaks`), with spectra
  names in the `name` column.

## Details

Based on the original implementation, the function performs the
following tasks:

1.  Square-root transformation

2.  Mass range trimming to 4-10 kDa as they were deemed most determinant
    by Strejcek et al. (2018)

3.  Signal smoothing using the Savitzky-Golay method and a half window
    size of 20

4.  Baseline correction with the SNIP procedure

5.  Normalization by Total Ion Current

6.  Peak detection using the SuperSmoother procedure and with a
    signal-to-noise ratio above 3

7.  Peak filtering. This step has been added to discard peaks with a
    negative signal-to-noise ratio probably due to being on the edge of
    the mass range.

## Note

The original R code on which this function is based is accessible at:
<https://github.com/strejcem/MALDIvs16S>

## References

Strejcek M, Smrhova T, Junkova P & Uhlik O (2018). “Whole-Cell MALDI-TOF
MS versus 16S rRNA Gene Analysis for Identification and Dereplication of
Recurrent Bacterial Isolates.” *Frontiers in Microbiology* 9
<doi:10.3389/fmicb.2018.01294>.

## See also

[import_biotyper_spectra](https://clavellab.github.io/maldipickr/reference/import_biotyper_spectra.md)
and
[check_spectra](https://clavellab.github.io/maldipickr/reference/check_spectra.md)
for the inputs and
[merge_processed_spectra](https://clavellab.github.io/maldipickr/reference/merge_processed_spectra.md)
for further analysis.

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
# Overview of the list architecture that is returned
#  with the list of processed spectra, peaks identified and the
#  metadata table
str(processed, max.level = 2)
#> List of 3
#>  $ spectra :List of 6
#>   ..$ species1_G2 :Formal class 'MassSpectrum' [package "MALDIquant"] with 3 slots
#>   ..$ species2_E11:Formal class 'MassSpectrum' [package "MALDIquant"] with 3 slots
#>   ..$ species2_E12:Formal class 'MassSpectrum' [package "MALDIquant"] with 3 slots
#>   ..$ species3_F7 :Formal class 'MassSpectrum' [package "MALDIquant"] with 3 slots
#>   ..$ species3_F8 :Formal class 'MassSpectrum' [package "MALDIquant"] with 3 slots
#>   ..$ species3_F9 :Formal class 'MassSpectrum' [package "MALDIquant"] with 3 slots
#>  $ peaks   :List of 6
#>   ..$ species1_G2 :Formal class 'MassPeaks' [package "MALDIquant"] with 4 slots
#>   ..$ species2_E11:Formal class 'MassPeaks' [package "MALDIquant"] with 4 slots
#>   ..$ species2_E12:Formal class 'MassPeaks' [package "MALDIquant"] with 4 slots
#>   ..$ species3_F7 :Formal class 'MassPeaks' [package "MALDIquant"] with 4 slots
#>   ..$ species3_F8 :Formal class 'MassPeaks' [package "MALDIquant"] with 4 slots
#>   ..$ species3_F9 :Formal class 'MassPeaks' [package "MALDIquant"] with 4 slots
#>  $ metadata: tibble [6 × 3] (S3: tbl_df/tbl/data.frame)
# A detailed view of the metadata with the median signal-to-noise
#  ratio (SNR) and the number of peaks
processed$metadata
#> # A tibble: 6 × 3
#>   name           SNR peaks
#>   <chr>        <dbl> <int>
#> 1 species1_G2   5.09    21
#> 2 species2_E11  5.54    22
#> 3 species2_E12  5.63    23
#> 4 species3_F7   4.89    26
#> 5 species3_F8   5.56    25
#> 6 species3_F9   5.40    25
```
