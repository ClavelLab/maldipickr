
<!-- README.md is generated from README.Rmd. Please edit that file -->

# maldipickr <img src="man/figures/logo.png" align="right" height="138" />

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![R-CMD-check](https://github.com/ClavelLab/maldipickr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ClavelLab/maldipickr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of [`maldipickr`](https://github.com/ClavelLab/maldipickr) is
to provide documented and tested R functions to dereplicate
matrix-assisted laser desorption/ionization-time-of-flight (MALDI-TOF)
data and cherry-pick representative spectra.

## Under the hood

This R package is developed towards the spectra generated by the Bruker
MALDI Biotyper device. The
[`maldipickr`](https://github.com/ClavelLab/maldipickr) package is built
from a suite of Rmarkdown files using the
[`fusen`](https://thinkr-open.github.io/fusen/) package by Rochette S
(2023). It relies on:

1.  the [`MALDIquant`](https://cran.r-project.org/package=MALDIquant)
    package from Gibb & Strimmer (2012) for spectra functions
2.  the work of Strejcek et al. (2018) for the dereplication procedure.

## Installation

You can install the development version of
[`maldipickr`](https://github.com/ClavelLab/maldipickr) from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ClavelLab/maldipickr", build_vignettes = TRUE)
```

## Usage

The package provides functions to:

1.  Import spectra (with
    [`import_biotyper_spectra()`](https://clavellab.github.io/maldipickr/reference/import_biotyper_spectra.html))
    and identification reports from Bruker MALDI Biotyper into R (with
    [`read_biotyper_report()`](https://clavellab.github.io/maldipickr/reference/read_biotyper_report.html)).
2.  Process, dereplicate (with
    [`process_spectra()`](https://clavellab.github.io/maldipickr/reference/process_spectra.html)
    and
    [`similarity_to_clusters()`](https://clavellab.github.io/maldipickr/reference/similarity_to_clusters.html))
    and cherry-pick representative spectra
    ([`pick_spectra()`](https://clavellab.github.io/maldipickr/reference/pick_spectra.html)).

## Disclaimer

The developers of this package are not affiliated with the company
Bruker, therefore this package is independent of the company and is
distributed under the GPL-3.0 License.

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
