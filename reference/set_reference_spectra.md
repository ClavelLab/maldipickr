# Set a reference spectrum for each cluster

Define a high-quality spectra as a representative spectra of the cluster
based on the highest median signal-to-noise ratio and the number of
detected peaks

## Usage

``` r
set_reference_spectra(cluster_df, metadata_df)
```

## Arguments

- cluster_df:

  A tibble of *n* rows for each spectra produced by
  [delineate_with_similarity](https://clavellab.github.io/maldipickr/reference/delineate_with_similarity.md)
  function with at least the following columns:

  - `name`: the rownames of the similarity matrix indicating the spectra
    names

  - `membership`: integers stating the cluster number to which the
    spectra belong to. It starts from 1 to *c*, the total number of
    clusters.

  - `cluster_size`: integers indicating the total number of spectra in
    the corresponding cluster.

- metadata_df:

  A tibble of *n* rows for each spectra produced by the
  [process_spectra](https://clavellab.github.io/maldipickr/reference/process_spectra.md)
  function with median signal-to-noise ratio (`SNR`), peaks number
  (`peaks`), and spectra names in the `name` column.

## Value

A merged tibble in the same order as `cluster_df` with both the columns
of `cluster_df` and `metadata_df`, as well as a logical column
`is_reference` indicating if the spectrum is the reference spectra of
the cluster.

## See also

[delineate_with_similarity](https://clavellab.github.io/maldipickr/reference/delineate_with_similarity.md),
[pick_spectra](https://clavellab.github.io/maldipickr/reference/pick_spectra.md)

## Examples

``` r
# Get an example directory of six Bruker MALDI Biotyper spectra
# Import the six spectra and
# Transform the spectra signals according to Strejcek et al. (2018)
processed <- system.file(
  "toy-species-spectra",
  package = "maldipickr"
) %>%
  import_biotyper_spectra() %>%
  process_spectra()

# Toy similarity matrix between the six example spectra of
#  three species. The cosine metric is used and a value of
#  zero indicates dissimilar spectra and a value of one
#  indicates identical spectra.
cosine_similarity <- matrix(
  c(
    1, 0.79, 0.77, 0.99, 0.98, 0.98,
    0.79, 1, 0.98, 0.79, 0.8, 0.8,
    0.77, 0.98, 1, 0.77, 0.77, 0.77,
    0.99, 0.79, 0.77, 1, 1, 0.99,
    0.98, 0.8, 0.77, 1, 1, 1,
    0.98, 0.8, 0.77, 0.99, 1, 1
  ),
  nrow = 6,
  dimnames = list(
    c(
      "species1_G2", "species2_E11", "species2_E12",
      "species3_F7", "species3_F8", "species3_F9"
    ),
    c(
      "species1_G2", "species2_E11", "species2_E12",
      "species3_F7", "species3_F8", "species3_F9"
    )
  )
)
# Delineate clusters based on a 0.92 threshold applied
#  to the similarity matrix
clusters <- delineate_with_similarity(
  cosine_similarity,
  threshold = 0.92
)

# Set reference spectra with the toy example
set_reference_spectra(clusters, processed$metadata)
#> # A tibble: 6 × 6
#>   name         membership cluster_size   SNR peaks is_reference
#>   <chr>             <int>        <int> <dbl> <int> <lgl>       
#> 1 species1_G2           1            4  5.09    21 FALSE       
#> 2 species2_E11          2            2  5.54    22 FALSE       
#> 3 species2_E12          2            2  5.63    23 TRUE        
#> 4 species3_F7           1            4  4.89    26 FALSE       
#> 5 species3_F8           1            4  5.56    25 TRUE        
#> 6 species3_F9           1            4  5.40    25 FALSE       
```
