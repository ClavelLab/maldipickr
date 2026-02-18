# Identify the wells on the plate's edge

Identify the wells on the plate's edge

## Usage

``` r
is_well_on_edge(
  well_number,
  plate_layout = c(96, 384),
  edges = c("top", "bottom", "left", "right"),
  details = FALSE
)
```

## Arguments

- well_number:

  A vector of positive numeric well identifier

- plate_layout:

  An integer indicating the maximum number of well on the plate

- edges:

  A character vector pointing which plate edges should be considered

- details:

  A logical controlling whether a
  [data.frame](https://rdrr.io/r/base/data.frame.html) with more details
  should be returned

## Value

A logical vector, the same length as `well_number` indicating whether
the well is on the edge. If `details = TRUE`, the function returns a
[data.frame](https://rdrr.io/r/base/data.frame.html) that complements
the logical vector with the `well_number`, row and column positions.

## Details

Flag the wells located on the edges of a 96- or 384-well plate, based on
the following well numbering:

- Well numbers start at 1

- Well are numbered from left to right and then top to bottom of the
  plate.

## Examples

``` r
# Logical vector indicating whether the wells are on the four edges
is_well_on_edge(1:96, plate_layout = 96)
#>  [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#> [13]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [25]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [37]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [49]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [61]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [73]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [85]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
# More details can be obtained to verify the results
well_df <- is_well_on_edge(1:96, plate_layout = 96, details = TRUE)
# And the resulting prediction displayed
matrix(well_df$is_edge, ncol = max(well_df$col), byrow = TRUE)
#>      [,1]  [,2]  [,3]  [,4]  [,5]  [,6]  [,7]  [,8]  [,9] [,10] [,11] [,12]
#> [1,] TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#> [2,] TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [3,] TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [4,] TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [5,] TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [6,] TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [7,] TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [8,] TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
```
