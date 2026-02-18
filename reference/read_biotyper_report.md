# Importing Bruker MALDI Biotyper CSV report

The header-less table exported by the Compass software in the Bruker
MALDI Biotyper device is separated by semi-colons and has empty columns
which prevent an easy import in R. This function reads the report
correctly as a tibble.

## Usage

``` r
read_biotyper_report(path, best_hits = TRUE, long_format = TRUE)
```

## Arguments

- path:

  Path to the semi-colon separated table

- best_hits:

  A logical indicating whether to return only the best hits for each
  target analyzed

- long_format:

  A logical indicating whether the table is in the long format (many
  rows) or wide format (many columns) when showing all the hits. This
  option has no effect when `best_hits = TRUE`.

## Value

A tibble of 8 columns (`best_hits = TRUE`) or 52 columns
(`best_hits = FALSE`). See Details for the description of the columns.

## Details

The header-less table contains identification information for each
target processed by the Biotyper device and once processed by the
`read_biotyper_report`, the following seven columns are available in the
tibble, *when using the `best_hits = TRUE` option*:

- `name`: a character indicating the name of the spot of the MALDI
  target (i.e., plate)

- `sample_name`: the character string provided during the preparation of
  the MALDI target (i.e., plate)

- `hit_rank`: an integer indicating the rank of the hit for the
  corresponding target and identification

- `bruker_quality`: a character encoding the quality of the
  identification with potentially multiple "+" symbol or only one "-"

- `bruker_species`: the species name associated with the MALDI spectrum
  analyzed.

- `bruker_taxid`: the NCBI Taxonomy Identifier of the species name in
  the column species

- `bruker_hash`: a hash from an undocumented checksum function probably
  to encode the database entry.

- `bruker_log`: the log-score of the identification.

When all hits are returned (with `best_hits = FALSE`), the default
output format is the long format (`long_format = TRUE`), meaning that
the previous columns remain unchanged, but all hits are now returned,
thus increasing the number of rows.

When all hits are returned (with `best_hits = FALSE`) *using the wide
format*
(`long_format = FALSE), the two columns `name`and`sample_name`remains unchanged, but the five columns prefixed by`bruker\_\`
contain the hit rank, **creating a tibble of 52 columns**:

- `bruker_01_quality`

- `bruker_01_species`

- `bruker_01_taxid`

- `bruker_01_hash`

- `bruker_01_log`

- `bruker_02_quality`

- ...

- `bruker_10_species`

- `bruker_10_taxid`

- `bruker_10_hash`

- `bruker_10_log`

## Note

A report that contains only spectra with no peaks found will return a
tibble of 0 rows and a warning message.

## See also

[read_many_biotyper_reports](https://clavellab.github.io/maldipickr/reference/read_many_biotyper_reports.md)

## Examples

``` r
# Get a example Bruker report
biotyper <- system.file("biotyper.csv", package = "maldipickr")
# Import the report as a tibble
report_tibble <- read_biotyper_report(biotyper)
# Display the tibble
report_tibble
#> # A tibble: 3 × 8
#>   name    sample_name hit_rank bruker_quality bruker_species        bruker_taxid
#>   <chr>   <chr>          <int> <chr>          <chr>                        <dbl>
#> 1 targetA NA                 1 -              not reliable identif…           NA
#> 2 targetB NA                 1 +++            Escherichia coli               562
#> 3 targetC NA                 1 +++            Kosakonia cowanii           208223
#> # ℹ 2 more variables: bruker_hash <chr>, bruker_log <dbl>
```
