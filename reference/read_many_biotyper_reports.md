# Importing a list of Bruker MALDI Biotyper CSV reports

Importing a list of Bruker MALDI Biotyper CSV reports

## Usage

``` r
read_many_biotyper_reports(path_to_reports, report_ids, best_hits = TRUE, ...)
```

## Arguments

- path_to_reports:

  A vector of paths to the csv files to be imported by
  [`read_biotyper_report()`](https://clavellab.github.io/maldipickr/reference/read_biotyper_report.md).

- report_ids:

  A vector of character names for each of the reports.

- best_hits:

  A logical indicating whether to return only the best hit in the
  [`read_biotyper_report()`](https://clavellab.github.io/maldipickr/reference/read_biotyper_report.md)
  function.

- ...:

  Name-value pairs to be passed on to
  [`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html)

## Value

A tibble just like the one returned by the
[`read_biotyper_report()`](https://clavellab.github.io/maldipickr/reference/read_biotyper_report.md)
function, except that the name of the spot of the MALDI target (i.e.,
plate) is registered to the `original_name` column (instead of the
`name` column), and the column `name` consist in the provided
`report_ids` used as a prefix of the `original_name` column.

## Note

The report identifiers are sanitized to convert all dashes (`-`) as
underscores (`_`).

## See also

[read_biotyper_report](https://clavellab.github.io/maldipickr/reference/read_biotyper_report.md)

## Examples

``` r
# List of Bruker MALDI Biotyper reports
reports_paths <- system.file(
  c("biotyper.csv", "biotyper.csv", "biotyper.csv"),
  package = "maldipickr"
)
# Read the list of reports and combine them in a single tibble
read_many_biotyper_reports(
  reports_paths,
  report_ids = c("first", "second", "third"),
  # Additional metadata below are passed to dplyr::mutate
  growth_temperature = 37.0
)
#> # A tibble: 9 × 10
#>   name          original_name sample_name hit_rank bruker_quality bruker_species
#>   <chr>         <chr>         <chr>          <int> <chr>          <chr>         
#> 1 first_targetA targetA       NA                 1 -              not reliable …
#> 2 first_targetB targetB       NA                 1 +++            Escherichia c…
#> 3 first_targetC targetC       NA                 1 +++            Kosakonia cow…
#> 4 second_targe… targetA       NA                 1 -              not reliable …
#> 5 second_targe… targetB       NA                 1 +++            Escherichia c…
#> 6 second_targe… targetC       NA                 1 +++            Kosakonia cow…
#> 7 third_targetA targetA       NA                 1 -              not reliable …
#> 8 third_targetB targetB       NA                 1 +++            Escherichia c…
#> 9 third_targetC targetC       NA                 1 +++            Kosakonia cow…
#> # ℹ 4 more variables: bruker_taxid <dbl>, bruker_hash <chr>, bruker_log <dbl>,
#> #   growth_temperature <dbl>
```
