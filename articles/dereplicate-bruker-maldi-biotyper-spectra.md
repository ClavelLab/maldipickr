# Dereplicate Bruker MALDI Biotyper spectra

``` r
library(maldipickr)
```

Bacterial colony identification with the Bruker MALDI Biotyper is a
high-throughput method with the built-in tools, provided that the
selected bacteria belong to the internal database.

Scientific projects where the number of unknown bacteria is expected to
be high needs reference-free methods to be able to reduce the redundancy
of isolated bacterial colonies, a process called *dereplication*.

[Strejcek *et al.* (2018)](https://doi.org/10.3389/fmicb.2018.01294)
proposed such a method by processing the spectra and suggest similarity
thresholds between spectra above which spectra, and therefore the
measured bacterial colonies, can be considered identical at a given
taxonomic rank. Their processing procedure is implemented in the
[`{maldipickr}`](https://github.com/ClavelLab/maldipickr) package and
illustrated in the following vignette.

In addition, we provide functions to enable the dereplication of
different batches of Bruker MALDI Biotyper runs and combine the results,
in order to be able to delineate the clusters from a common similarity
matrix.

More importantly, we provide a function to select a spectra to be picked
in each cluster, a process called *cherry-picking*, depending on
external metadata and potential out-groups to be excluded for the
current cherry-picking steps.

## Process Bruker MALDI Biotyper spectra

### Process from raw spectra to peak filtering

From the imported raw data from the Bruker MALDI Biotyper, the
processing of the spectra is based on the original implementation, and
run the following tasks:

1.  Square-root transformation
2.  Mass range trimming to 4-10 kDa as they were deemed most determinant
    by Strejcek et al. (2018)
3.  Signal smoothing using the Savitzky-Golay method and a half window
    size of 20
4.  Baseline correction with the SNIP procedure
5.  Normalization by Total Ion Current
6.  Peak detection using the SuperSmoother procedure and with a
    signal-to-noise ratio above 3
7.  Peak filtering. This step has been added to discard peaks with a
    negative signal-to-noise ratio probably due to being on the edge of
    the mass range.

The full procedure is illustrated in the example below. While in this
case, all the resulting processed spectra, peaks and final spectra
metadata are stored in-memory, the
[`process_spectra()`](https://clavellab.github.io/maldipickr/reference/process_spectra.html)
function enables storing these files locally for scalable
high-throughput analyses.

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

### Merge multiple processed spectra

During high-throughput analyses, multiples runs of Bruker MALDI Biotyper
are expected resulting in several batches of spectra to be processed and
compared. While their processing is natively independent, and could
natively be run in parallel, the integration of the batches for their
comparison needs an additional step.

The
[`merge_processed_spectra()`](https://clavellab.github.io/maldipickr/reference/merge_processed_spectra.html)
function aggregates the processed spectra and bins together the detected
peaks, with a tolerance of $0.002$ between the average peak values in
the bin (see
[`MALDIquant::binPeaks`](https://rdrr.io/cran/MALDIquant/man/binPeaks-functions.html)),
which translate to a tolerance of 2000 ppm. This binning step results in
a $n \times p$ feature matrix (or intensity matrix), with $n$ rows for
$n$ processed spectra (peak-less spectra are discarded) and $p$ columns
for the $p$ peaks masses.

By default, as in the Strejeck et al. (2018) procedure, the intensity
values for spectra with missing peaks are interpolated from the
processed spectra signal. The current function enables the analyst to
decide whether to interpolate the values or leave missing peaks as `NA`
which would then be converted to an null intensity value.

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
# Merge the spectra to produce the feature matrix
fm <- merge_processed_spectra(list(processed))
# The feature matrix has 6 spectra as rows and
#  35 peaks as columns
dim(fm)
#> [1]  6 35
# Notice the difference when the interpolation is turned off
fm_no_interpolation <- merge_processed_spectra(
  list(processed),
  interpolate_missing = FALSE
)
sum(fm == 0) # 0
#> [1] 0
sum(fm_no_interpolation == 0) # 68
#> [1] 68

# Multiple runs can be aggregated using list()
# Merge the spectra to produce the feature matrix
fm_all <- merge_processed_spectra(list(processed, processed, processed))
# The feature matrix has 3×6=18 spectra as rows and
#  35 peaks as columns
dim(fm_all)
#> [1] 18 35

# If using a list, names will be dropped and are not propagated to the matrix.
#' \dontrun{
#' fm_all <- merge_processed_spectra(
#'  list("A" = processed, "B" = processed, "C" = processed))
#' any(grepl("A|B|C", rownames(fm_all))) # FALSE
#'  }
#' 
```

### Compute a similarity matrix between all processed spectra (not included)

Once all the batches of spectra have been processed together, we can use
a distance metric to evaluate how close the spectra are to one another.
[Strejcek *et al.* (2018)](https://doi.org/10.3389/fmicb.2018.01294)
recommend the *cosine* metric to compare the spectra and they use the
fast implementation in the
[`{coop}`](https://cran.r-project.org/package=coop) package.

While we do not provide specific functions to generate the similarity
matrix, we illustrate below how it can be easily computed. Note that the
feature matrix from
[`merge_processed_spectra()`](https://clavellab.github.io/maldipickr/reference/merge_processed_spectra.html)
has spectra as rows and peaks values as columns. So to get a similarity
matrix between spectra, either the feature matrix must be transposed or
a dedicated function must be used.

``` r
# A. Compute the similarity matrix on the transposed feature matrix
#   using Pearson correlation coefficient
sim_matrix <- stats::cor(t(fm), method = "pearson")

# B.1 Install the coop package
# install.packages("coop")

# B.2 Compute the similarity matrix on the rows of the feature matrix
sim_matrix <- coop::tcosine(fm)
```

## Delineate clusters of spectra

### From a similarity matrix

#### Similarity to clusters

When the similarity matrix is computed between all pairs of the studied
spectra, the next step is to delineate clusters of spectra in order to
dereplicate the measured bacterial colonies, that is to find which are
nearly identical colonies.

The
[`delineate_with_similarity()`](https://clavellab.github.io/maldipickr/reference/delineate_with_similarity.html)
is agnostic of the similarity metric used provided that the upper bound
is one and that a numeric threshold relevant to the metric used is
given. We recommend the cosine metric or the Pearson product moment.

Hierarchical clustering will then group spectra in the same cluster only
if the similarity between the spectra is **above** (or **equal to**) the
provided threshold. The default and recommended method is the *complete
linkage*, also known as the farthest neighbor, to ensure that the
within-group minimum similarity of each cluster respects the threshold.

Finally, a table summarizes for each spectra, to which cluster number it
was assigned to and the size of the cluster, which is the total number
of spectra in the cluster.

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

#### Set a reference spectrum for each cluster

Once the table of clusters is generated from the similarity matrix, a
reference spectrum can be assigned to each cluster.

We choose to define high-quality spectra as representative spectra of
the clusters using internal information. That is, representative spectra
have, within their cluster, the highest median signal-to-noise ratio and
then the highest number of detected peaks.

The function
[`set_reference_spectra()`](https://clavellab.github.io/maldipickr/reference/set_reference_spectra.html)
does not change the order of the cluster table but merely adds an
additional column `is_reference` to indicate whether the corresponding
spectrum is representative of the cluster.

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

### From taxonomic identifications

An alternative to the similarity matrix approach from the previous
section is to rely on the taxonomic identification of the spectra to
delineate clusters. To do so, we must use the Bruker MALDI Biotyper
report from the Compass software that summarize the identification of
the microorganisms using its internal database. Once the report or
reports are imported (in R using
[`read_biotyper_report()`](https://clavellab.github.io/maldipickr/reference/read_biotyper_report.html)),
the function
[`delineate_with_identification()`](https://clavellab.github.io/maldipickr/reference/delineate_with_identification.html)
will group spectra based on their identifications.

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

Clusters generated from taxonomic identifications can not use the
function
[`set_reference_spectra()`](https://clavellab.github.io/maldipickr/reference/set_reference_spectra.html)
as the latter relies on peaks information that is not disclosed in the
Biotyper report.

Therefore, users interested in cherry-picking spectra using taxonomic
identifications should use the
[`pick_spectra()`](https://clavellab.github.io/maldipickr/reference/pick_spectra.html)
function described below with the combination of the input and output
tables of the
[`delineate_with_identification()`](https://clavellab.github.io/maldipickr/reference/delineate_with_identification.html)
function to pick for instance spectra with the highest log score (using
`criteria_column = "bruker_log"`).

### Import clusters results generated by SPeDE

Raw spectra can also be processed and clustered by another approach,
named [`SPeDE`](https://github.com/LM-UGent/SPeDE), developed by Dumolin
et al. (2019). The resulting dereplication step produces a comma
separated table. The example below illustrates how to import this table
into R to be consistent with the dereplication table generated within
the [`{maldipickr}`](https://github.com/ClavelLab/maldipickr) package.

``` r
# Reformat the output from SPeDE table
# https://github.com/LM-UGent/SPeDE
import_spede_clusters(
  system.file("spede.csv", package = "maldipickr")
)
#> # A tibble: 6 × 5
#>   name         membership cluster_size quality is_reference
#>   <chr>             <dbl>        <int> <chr>   <lgl>       
#> 1 species1_G2           1            1 GREEN   TRUE        
#> 2 species2_E11          2            2 ORANGE  FALSE       
#> 3 species2_E12          2            2 GREEN   TRUE        
#> 4 species3_F7           3            1 GREEN   TRUE        
#> 5 species3_F8           4            2 ORANGE  FALSE       
#> 6 species3_F9           4            2 GREEN   TRUE
```

## Cherry-pick Bruker MALDI Biotyper spectra

When isolating bacteria from an environment, experimenters want to be
thorough but also work-, time- and cost-savvy. One approach is to reduce
the redundancy of the bacterial isolates by analyzing their MALDI-TOF
spectra from the Bruker Biotyper. All the steps previously described in
this vignette consisted of processing the spectra to be able to pick
only non-redundant spectra, using the
[`pick_spectra()`](https://clavellab.github.io/maldipickr/reference/pick_spectra.html)
function.

The function, as illustrated in the examples below, can pick spectra
using different types of inputs:

- the reference spectra information that is present in the cluster table
  (after using
  [`delineate_with_similarity()`](https://clavellab.github.io/maldipickr/reference/delineate_with_similarity.html)
  or
  [`import_spede_clusters()`](https://clavellab.github.io/maldipickr/reference/import_spede_clusters.html)
  functions; see example 1)
- an external metadata table containing a variable (e.g., optical
  density, fluorescence) to be maximized (default) or minimized per
  cluster (see example 2)

Spectra, and clusters, can also be excluded from the cherry-picking
decision, a procedure termed *masking* here. We distinguish two types of
mask that are implemented in the
[`pick_spectra()`](https://clavellab.github.io/maldipickr/reference/pick_spectra.html)
function:

- **soft mask** that discards the spectra only, if they correspond for
  instance to low-quality sample, negative control samples (see example
  3)
- **hard mask** that discards the spectra *and their clusters* (see
  example 4). This is particularly useful if some spectra have been
  previously picked. For instance, to exclude colonies grown and picked
  24h after streaking when comparing with colonies grown for 72h.

Advanced users can also provide directly a cluster table with a custom
sort by cluster to accommodate complex design.

Ultimately, the function delivers a table with as many rows as the
cluster table with an additional logical column named `to_pick` to
indicate whether the colony associated with the spectra should be picked
(`TRUE`) or not picked (`FALSE`).

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

## References

- Dumolin C, Aerts M, Verheyde B, Schellaert S, Vandamme T, Van Der
  Jeugt F, De Canck E, Cnockaert M, Wieme AD, Cleenwerck I, Peiren J,
  Dawyndt P, Vandamme P, & Carlier A. (2019). “Introducing SPeDE:
  High-Throughput Dereplication and Accurate Determination of Microbial
  Diversity from Matrix-Assisted Laser Desorption–Ionization Time of
  Flight Mass Spectrometry Data”. *MSystems* 4(5).
  <doi:10.1128/msystems.00437-19>.
- Strejcek M, Smrhova T, Junkova P & Uhlik O (2018). “Whole-Cell
  MALDI-TOF MS versus 16S rRNA Gene Analysis for Identification and
  Dereplication of Recurrent Bacterial Isolates.” *Frontiers in
  Microbiology* 9 <doi:10.3389/fmicb.2018.01294>.
