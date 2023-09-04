
<!-- README.md is generated from README.Rmd. Please edit that file -->

# maldipickr <img src="man/figures/logo.png" align="right" height="138" />

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-CMD-check](https://github.com/ClavelLab/maldipickr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ClavelLab/maldipickr/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/github/ClavelLab/maldipickr/branch/main/graph/badge.svg?token=JQABKDK2MB)](https://codecov.io/github/ClavelLab/maldipickr)
<!-- badges: end -->

The goal of [`{maldipickr}`](https://github.com/ClavelLab/maldipickr) is
to provide documented and tested R functions to dereplicate
matrix-assisted laser desorption/ionization-time-of-flight (MALDI-TOF)
data and cherry-pick representative spectra of microbial isolates.

## Quickstart: cherry-pick bacterial isolates

### From MALDI BioTyper spectra data

``` r
library(maldipickr)
# Set up the directory location of your spectra data
spectra_dir <- system.file("toy-species-spectra", package = "maldipickr")

# Import and process the spectra
processed <- spectra_dir %>%
  import_biotyper_spectra() %>%
  process_spectra()

# Delineate spectra clusters using Cosine similarity
#  and cherry-pick one representative spectra.
#  The chosen ones are indicated by `to_pick` column
processed %>%
  list() %>%
  merge_processed_spectra() %>%
  t() %>%
  coop::cosine() %>%
  similarity_to_clusters(threshold = 0.92) %>%
  set_reference_spectra(processed$metadata) %>%
  pick_spectra() %>%
  dplyr::relocate(name, to_pick)
#> # A tibble: 6 × 7
#>   name         to_pick membership cluster_size   SNR peaks is_reference
#>   <chr>        <lgl>        <int>        <int> <dbl> <dbl> <lgl>       
#> 1 species1_G2  FALSE            1            4  5.09    21 FALSE       
#> 2 species2_E11 FALSE            2            2  5.54    22 FALSE       
#> 3 species2_E12 TRUE             2            2  5.63    23 TRUE        
#> 4 species3_F7  FALSE            1            4  4.89    26 FALSE       
#> 5 species3_F8  TRUE             1            4  5.56    25 TRUE        
#> 6 species3_F9  FALSE            1            4  5.40    25 FALSE
```

## Installation

You can install the development version of
[`{maldipickr}`](https://github.com/ClavelLab/maldipickr) from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ClavelLab/maldipickr", build_vignettes = TRUE)
```

## Usage

The comprehensive vignettes will walk you through the package functions
and showcase how to:

1.  [Import spectra data and identification reports from Bruker MALDI
    Biotyper into
    R](https://clavellab.github.io/maldipickr/articles/import-data-from-bruker-maldi-biotyper.html).
2.  [Process, dereplicate and cherry-pick representative spectra, from
    simple to complex
    design](https://clavellab.github.io/maldipickr/articles/dereplicate-bruker-maldi-biotyper-spectra.html).

## Acknowledgments

This R package is developed for spectra data generated by the Bruker
MALDI Biotyper device. The
[`{maldipickr}`](https://github.com/ClavelLab/maldipickr) package is
built from a suite of Rmarkdown files using the
[`{fusen}`](https://thinkr-open.github.io/fusen/) package by Rochette S
(2023). It relies on:

1.  the [`{MALDIquant}`](https://cran.r-project.org/package=MALDIquant)
    package from Gibb & Strimmer (2012) for spectra functions
2.  the work of Strejcek et al. (2018) for the dereplication procedure.

### Disclaimer

The developers of this package are part of the [Clavel
Lab](https://www.clavel.ukaachen.de) and are not affiliated with the
company Bruker, therefore this package is independent of the company and
is distributed under the [GPL-3.0 License](LICENSE.md).

The hexagonal logo was created by Charlie Pauvert and uses the
[Hack](https://sourcefoundry.org/hack) font and a color palette
generated at <https://coolors.co>.

## References

- Gibb S & Strimmer K (2012). “MALDIquant: a versatile R package for the
  analysis of mass spectrometry data”. *Bioinformatics* 28, 2270-2271.
  <https://doi.org/10.1093/bioinformatics/bts447>.
- Rochette S (2023). “fusen: Build a Package from Rmarkdown Files”.
  <https://thinkr-open.github.io/fusen/>,
  <https://github.com/Thinkr-open/fusen>.
- Strejcek M, Smrhova T, Junkova P & Uhlik O (2012). “Whole-Cell
  MALDI-TOF MS versus 16S rRNA Gene Analysis for Identification and
  Dereplication of Recurrent Bacterial Isolates.” *Frontiers in
  Microbiology* 9 <https://doi.org/10.3389/fmicb.2018.01294>.
