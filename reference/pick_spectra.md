# Cherry-pick Bruker MALDI Biotyper spectra

Using the clusters information, and potential additional metadata as
external criteria, spectra are labeled as to be picked for each cluster.
Note that some spectra and therefore clusters can be explicitly removed
(*masked*) from the picking decision if they have been previously picked
or should be discarded, using logical columns in the metadata table. If
no metadata are provided, the reference spectra of each cluster will be
picked.

## Usage

``` r
pick_spectra(
  cluster_df,
  metadata_df = NULL,
  criteria_column = NULL,
  hard_mask_column = NULL,
  soft_mask_column = NULL,
  is_descending_order = TRUE,
  is_sorted = FALSE
)
```

## Arguments

- cluster_df:

  A tibble with clusters information from the
  [delineate_with_similarity](https://clavellab.github.io/maldipickr/reference/delineate_with_similarity.md)
  or the
  [import_spede_clusters](https://clavellab.github.io/maldipickr/reference/import_spede_clusters.md)
  function.

- metadata_df:

  Optional tibble with relevant metadata to guide the picking process
  (e.g., OD600).

- criteria_column:

  Optional character indicating the column in `metadata_df` to be used
  as a criteria.

- hard_mask_column:

  Column name in the `cluster_df` or `metadata_df` tibble indicating
  whether the spectra, **and the clusters to which they belong** should
  be discarded (`TRUE`) or not (`FALSE`) before the picking decision.

- soft_mask_column:

  Column name in the `cluster_df` or `metadata_df` tibble indicating
  whether the spectra should be discarded (`TRUE`) or not (`FALSE`)
  before the picking decision.

- is_descending_order:

  Optional logical indicating whether to sort the `criteria_column` from
  the highest-to-lowest value (`TRUE`) or lowest-to-highest (`FALSE`).

- is_sorted:

  Optional logical to indicate that the `cluster_df` is already sorted
  by cluster based on (usually multiple) internal criteria to pick the
  first of each cluster. This flag is **overridden** if a `metadata_df`
  is provided.

## Value

A tibble with as many rows as `cluster_df` with an additional logical
column named `to_pick` to indicate whether the colony associated to the
spectra should be picked. If `metadata_df` is provided, then additional
columns from this tibble are added to the returned tibble.

## See also

[delineate_with_similarity](https://clavellab.github.io/maldipickr/reference/delineate_with_similarity.md),
[set_reference_spectra](https://clavellab.github.io/maldipickr/reference/set_reference_spectra.md).
For a useful utility function to soft-mask specific spectra:
[is_well_on_edge](https://clavellab.github.io/maldipickr/reference/is_well_on_edge.md).

## Examples

``` r
# 0. Load a toy example of a tibble of clusters created by
#   the `delineate_with_similarity` function.
clusters <- readRDS(
  system.file("clusters_tibble.RDS",
    package = "maldipickr"
  )
)
# 1. By default and if no other metadata are provided,
#   the function picks reference spectra for each clusters.
#
# N.B: The spectra `name` and `to_pick` columns are moved to the left
# only for clarity using the `relocate()` function.
#
pick_spectra(clusters) %>%
  dplyr::relocate(name, to_pick) # only for clarity
#> # A tibble: 6 × 7
#>   name         to_pick membership cluster_size   SNR peaks is_reference
#>   <chr>        <lgl>        <int>        <int> <dbl> <dbl> <lgl>       
#> 1 species1_G2  FALSE            1            4  5.09    21 FALSE       
#> 2 species2_E11 FALSE            2            2  5.54    22 FALSE       
#> 3 species2_E12 TRUE             2            2  5.63    23 TRUE        
#> 4 species3_F7  FALSE            1            4  4.89    26 FALSE       
#> 5 species3_F8  TRUE             1            4  5.56    25 TRUE        
#> 6 species3_F9  FALSE            1            4  5.40    25 FALSE       

# 2.1 Simulate OD600 values with uniform distribution
#  for each of the colonies we measured with
#  the Bruker MALDI Biotyper
set.seed(104)
metadata <- dplyr::transmute(
  clusters,
  name = name, OD600 = runif(n = nrow(clusters))
)
metadata
#> # A tibble: 6 × 2
#>   name         OD600
#>   <chr>        <dbl>
#> 1 species1_G2  0.364
#> 2 species2_E11 0.772
#> 3 species2_E12 0.735
#> 4 species3_F7  0.973
#> 5 species3_F8  0.740
#> 6 species3_F9  0.201

# 2.2 Pick the spectra based on the highest
#   OD600 value per cluster
pick_spectra(clusters, metadata, "OD600") %>%
  dplyr::relocate(name, to_pick) # only for clarity
#> # A tibble: 6 × 8
#>   name         to_pick membership cluster_size   SNR peaks is_reference OD600
#>   <chr>        <lgl>        <int>        <int> <dbl> <dbl> <lgl>        <dbl>
#> 1 species1_G2  FALSE            1            4  5.09    21 FALSE        0.364
#> 2 species2_E11 TRUE             2            2  5.54    22 FALSE        0.772
#> 3 species2_E12 FALSE            2            2  5.63    23 TRUE         0.735
#> 4 species3_F7  TRUE             1            4  4.89    26 FALSE        0.973
#> 5 species3_F8  FALSE            1            4  5.56    25 TRUE         0.740
#> 6 species3_F9  FALSE            1            4  5.40    25 FALSE        0.201

# 3.1 Say that the wells on the right side of the plate are
#   used for negative controls and should not be picked.
metadata <- metadata %>% dplyr::mutate(
  well = gsub(".*[A-Z]([0-9]{1,2}$)", "\\1", name) %>%
    strtoi(),
  is_edge = is_well_on_edge(
    well_number = well, plate_layout = 96, edges = "right"
  )
)

# 3.2 Pick the spectra after discarding (or soft masking)
#   the spectra indicated by the `is_edge` column.
pick_spectra(clusters, metadata, "OD600",
  soft_mask_column = "is_edge"
) %>%
  dplyr::relocate(name, to_pick) # only for clarity
#> # A tibble: 6 × 10
#>   name      to_pick membership cluster_size   SNR peaks is_reference OD600  well
#>   <chr>     <lgl>        <int>        <int> <dbl> <dbl> <lgl>        <dbl> <int>
#> 1 species1… FALSE            1            4  5.09    21 FALSE        0.364     2
#> 2 species2… TRUE             2            2  5.54    22 FALSE        0.772    11
#> 3 species2… FALSE            2            2  5.63    23 TRUE         0.735    12
#> 4 species3… TRUE             1            4  4.89    26 FALSE        0.973     7
#> 5 species3… FALSE            1            4  5.56    25 TRUE         0.740     8
#> 6 species3… FALSE            1            4  5.40    25 FALSE        0.201     9
#> # ℹ 1 more variable: is_edge <lgl>

# 4.1 Say that some spectra were picked before
#   (e.g., in the column F) in a previous experiment.
# We do not want to pick clusters with those spectra
#   included to limit redundancy.
metadata <- metadata %>% dplyr::mutate(
  picked_before = grepl("_F", name)
)
# 4.2 Pick the spectra from clusters without spectra
#   labeled as `picked_before` (hard masking).
pick_spectra(clusters, metadata, "OD600",
  hard_mask_column = "picked_before"
) %>%
  dplyr::relocate(name, to_pick) # only for clarity
#> # A tibble: 6 × 11
#>   name      to_pick membership cluster_size   SNR peaks is_reference OD600  well
#>   <chr>     <lgl>        <int>        <int> <dbl> <dbl> <lgl>        <dbl> <int>
#> 1 species1… FALSE            1            4  5.09    21 FALSE        0.364     2
#> 2 species2… TRUE             2            2  5.54    22 FALSE        0.772    11
#> 3 species2… FALSE            2            2  5.63    23 TRUE         0.735    12
#> 4 species3… FALSE            1            4  4.89    26 FALSE        0.973     7
#> 5 species3… FALSE            1            4  5.56    25 TRUE         0.740     8
#> 6 species3… FALSE            1            4  5.40    25 FALSE        0.201     9
#> # ℹ 2 more variables: is_edge <lgl>, picked_before <lgl>
```
