# Delineate clusters from taxonomic identifications

From the report of taxonomic identification produced by the Bruker MALDI
Biotyper spectra sharing the same identification are labeled in the same
cluster. Spectra with unknown identification (e.g., due to database
completeness) are set in unique cluster.

## Usage

``` r
delineate_with_identification(tibble_report)
```

## Arguments

- tibble_report:

  A tibble of *n* rows, with *n* the number of spectra, produced by
  [`read_biotyper_report()`](https://clavellab.github.io/maldipickr/reference/read_biotyper_report.md)
  or
  [`read_many_biotyper_reports()`](https://clavellab.github.io/maldipickr/reference/read_many_biotyper_reports.md).
  The long format and the best hits options are expected to be used in
  these functions to produce a compliant input tibble.

## Value

A tibble of *n* rows for each spectra and 3 columns:

- `name`: the spectra names from the `name` column from the output of
  either
  [`read_biotyper_report()`](https://clavellab.github.io/maldipickr/reference/read_biotyper_report.md)
  or
  [`read_many_biotyper_reports()`](https://clavellab.github.io/maldipickr/reference/read_many_biotyper_reports.md).

- `membership`: integers stating the cluster number to which the spectra
  belong to. It starts from 1 to *c*, the total number of clusters.

- `cluster_size`: integers indicating the total number of spectra in the
  corresponding cluster.

## Details

As all unknown identification are considered unique clusters *within one
input tibble*, it is important to consider whether the taxonomic
identifications come from a single report or multiple reports, depending
on the research question. A message is displayed to confirm from which
type of reports the delineation was done.

## See also

[delineate_with_similarity](https://clavellab.github.io/maldipickr/reference/delineate_with_similarity.md)

## Examples

``` r
report_unknown <- read_biotyper_report(
  system.file("biotyper_unknown.csv", package = "maldipickr")
)
delineate_with_identification(report_unknown)
#> Generating clusters from single report
#> # A tibble: 4 × 3
#>   name              membership cluster_size
#>   <chr>                  <int>        <int>
#> 1 unknown_isolate_1          2            1
#> 2 unknown_isolate_2          3            1
#> 3 unknown_isolate_3          1            2
#> 4 unknown_isolate_4          1            2
```
