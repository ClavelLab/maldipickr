# Delineate clusters from a similarity matrix

From a matrix of spectra similarity (e.g., with the cosine metric, or
Pearson product moment), infer the species clusters based on a threshold
**above** (or **equal to**) which spectra are considered alike.

## Usage

``` r
delineate_with_similarity(sim_matrix, threshold, method = "complete")
```

## Arguments

- sim_matrix:

  A \\n \times n\\ similarity matrix, with \\n\\ the number of spectra.
  Columns should be named as the rows.

- threshold:

  A numeric value indicating the minimal similarity between two spectra.
  Adjust accordingly to the similarity metric used.

- method:

  The method of hierarchical clustering to use. The default and
  recommended method is "complete", but any methods from
  [stats::hclust](https://rdrr.io/r/stats/hclust.html) are valid.

## Value

A tibble of \\n\\ rows for each spectra and 3 columns:

- `name`: the rownames of the similarity matrix indicating the spectra
  names

- `membership`: integers stating the cluster number to which the spectra
  belong to. It starts from 1 to \\c\\, the total number of clusters.

- `cluster_size`: integers indicating the total number of spectra in the
  corresponding cluster.

## Details

The similarity matrix is converted to a distance matrix by subtracting
the value one. This approach works for cosine similarity and positive
correlations that have an upper bound of 1. Clusters are then delineated
using hierarchical clustering. The default method of hierarchical
clustering is the complete linkage (also known as farthest neighbor
clustering) to ensure that the within-group minimum similarity of each
cluster respects the threshold. See the Details section of
[stats::hclust](https://rdrr.io/r/stats/hclust.html) for others valid
methods to use.

## See also

For similarity metrics:
[[`coop::tcosine`](https://rdrr.io/pkg/coop/man/cosine.html)](https://rdrr.io/cran/coop/man/cosine.html),
[[`stats::cor`](https://rdrr.io/r/stats/cor.html)](https://rdrr.io/r/stats/cor.html),
[`Hmisc::rcorr`](https://rdrr.io/cran/Hmisc/man/rcorr.html). For using
taxonomic identifications for clusters :
[delineate_with_identification](https://clavellab.github.io/maldipickr/reference/delineate_with_identification.md).
For further analyses:
[set_reference_spectra](https://clavellab.github.io/maldipickr/reference/set_reference_spectra.md).

## Examples

``` r
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
delineate_with_similarity(cosine_similarity, threshold = 0.92)
#> # A tibble: 6 × 3
#>   name         membership cluster_size
#>   <chr>             <int>        <int>
#> 1 species1_G2           1            4
#> 2 species2_E11          2            2
#> 3 species2_E12          2            2
#> 4 species3_F7           1            4
#> 5 species3_F8           1            4
#> 6 species3_F9           1            4
```
