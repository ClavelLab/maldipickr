# maldipickr

``` r

library(maldipickr)
```

## Quickstart

The [maldipickr](https://github.com/ClavelLab/maldipickr) package helps
microbiologists reduce duplicate/clonal bacteria from their cultures and
eventually exclude previously selected bacteria.
[maldipickr](https://github.com/ClavelLab/maldipickr) achieve this feat
by grouping together data from MALDI Biotyper and helps choose
representative bacteria from each group using user-relevant metadata – a
process known as **cherry-picking**.

[maldipickr](https://github.com/ClavelLab/maldipickr) cherry-picks
bacterial isolates with MALDI Biotyper:

- [using taxonomic identification
  report](#using-taxonomic-identification-report)
- [using spectra data](#using-spectra-data)

### Using taxonomic identification report

First make sure [maldipickr](https://github.com/ClavelLab/maldipickr) is
installed and loaded, alternatively [follow the instructions to install
the
package](https://clavellab.github.io/maldipickr/index.html#installation).

Cherry-picking four isolates based on their taxonomic identification by
the MALDI Biotyper is done in a few steps with
[maldipickr](https://github.com/ClavelLab/maldipickr).

#### Get example data

We import an example Biotyper CSV report and glimpse at the table.

``` r

report_tbl <- read_biotyper_report(
  system.file("biotyper_unknown.csv", package = "maldipickr")
)
report_tbl %>%
  dplyr::select(name, bruker_species, bruker_log) %>% knitr::kable()
```

| name              | bruker_species               | bruker_log |
|:------------------|:-----------------------------|-----------:|
| unknown_isolate_1 | not reliable identification  |       1.33 |
| unknown_isolate_2 | not reliable identification  |       1.40 |
| unknown_isolate_3 | Faecalibacterium prausnitzii |       1.96 |
| unknown_isolate_4 | Faecalibacterium prausnitzii |       2.07 |

#### Delineate clusters and cherry-pick

Delineate clusters from the identifications after filtering the reliable
ones and cherry-pick one representative spectra.

Unreliable identifications based on the log-score are replaced by “not
reliable identification”, but stay tuned as they do not represent the
same isolates!

``` r

report_tbl <- report_tbl %>%
  dplyr::mutate(
      bruker_species = dplyr::if_else(bruker_log >= 2, bruker_species,
                                      "not reliable identification")
  )
knitr::kable(report_tbl)
```

| name | sample_name | hit_rank | bruker_quality | bruker_species | bruker_taxid | bruker_hash | bruker_log |
|:---|:---|---:|:---|:---|---:|:---|---:|
| unknown_isolate_1 | NA | 1 | \- | not reliable identification | NA | 3e920566-2734-43dd-85d0-66cf23a2d6ef | 1.33 |
| unknown_isolate_2 | NA | 1 | \- | not reliable identification | NA | 88a85875-eeb5-4858-966e-98a077325dc3 | 1.40 |
| unknown_isolate_3 | NA | 1 | \+ | not reliable identification | 137408536 | 2d266f20-5428-428d-96ec-ddd40200794b | 1.96 |
| unknown_isolate_4 | NA | 1 | +++ | Faecalibacterium prausnitzii | 137408536 | 2d266f20-5428-428d-96ec-ddd40200794b | 2.07 |

The chosen ones are indicated by `to_pick` column.

``` r

report_tbl %>%
  delineate_with_identification() %>%
  pick_spectra(report_tbl, criteria_column = "bruker_log") %>%
  dplyr::relocate(name, to_pick, bruker_species) %>% 
  knitr::kable()
#> Generating clusters from single report
```

| name | to_pick | bruker_species | membership | cluster_size | sample_name | hit_rank | bruker_quality | bruker_taxid | bruker_hash | bruker_log |
|:---|:---|:---|---:|---:|:---|---:|:---|---:|:---|---:|
| unknown_isolate_1 | TRUE | not reliable identification | 2 | 1 | NA | 1 | \- | NA | 3e920566-2734-43dd-85d0-66cf23a2d6ef | 1.33 |
| unknown_isolate_2 | TRUE | not reliable identification | 3 | 1 | NA | 1 | \- | NA | 88a85875-eeb5-4858-966e-98a077325dc3 | 1.40 |
| unknown_isolate_3 | TRUE | not reliable identification | 4 | 1 | NA | 1 | \+ | 137408536 | 2d266f20-5428-428d-96ec-ddd40200794b | 1.96 |
| unknown_isolate_4 | TRUE | Faecalibacterium prausnitzii | 1 | 1 | NA | 1 | +++ | 137408536 | 2d266f20-5428-428d-96ec-ddd40200794b | 2.07 |

### Using spectra data

In parallel to taxonomic identification reports,
[maldipickr](https://github.com/ClavelLab/maldipickr) process spectra
data. Make sure [maldipickr](https://github.com/ClavelLab/maldipickr) is
installed and loaded, alternatively [follow the instructions to install
the
package](https://clavellab.github.io/maldipickr/index.html#installation).

Cherry-picking six isolates from three species based on their spectra
data obtained from the MALDI Biotyper is done in a few steps with
[maldipickr](https://github.com/ClavelLab/maldipickr).

#### Get example data

We set up the directory location of our example spectra data, but adjust
for your requirements. We import and process the spectra which gives us
a named list of three objects: spectra, peaks and metadata (more details
in Value section of
[`process_spectra()`](https://clavellab.github.io/maldipickr/reference/process_spectra.md)).

``` r

spectra_dir <- system.file("toy-species-spectra", package = "maldipickr")

processed <- spectra_dir %>%
  import_biotyper_spectra() %>%
  process_spectra()
```

#### Delineate clusters and cherry-pick

Delineate spectra clusters using Cosine similarity and cherry-pick one
representative spectra. The chosen ones are indicated by `to_pick`
column.

``` r

processed %>%
  list() %>%
  merge_processed_spectra() %>%
  coop::tcosine() %>%
  delineate_with_similarity(threshold = 0.92) %>%
  set_reference_spectra(processed$metadata) %>%
  pick_spectra() %>%
  dplyr::relocate(name, to_pick) %>% 
  knitr::kable()
```

| name         | to_pick | membership | cluster_size |      SNR | peaks | is_reference |
|:-------------|:--------|-----------:|-------------:|---------:|------:|:-------------|
| species1_G2  | FALSE   |          1 |            4 | 5.089590 |    21 | FALSE        |
| species2_E11 | FALSE   |          2 |            2 | 5.543735 |    22 | FALSE        |
| species2_E12 | TRUE    |          2 |            2 | 5.633540 |    23 | TRUE         |
| species3_F7  | FALSE   |          1 |            4 | 4.889949 |    26 | FALSE        |
| species3_F8  | TRUE    |          1 |            4 | 5.558884 |    25 | TRUE         |
| species3_F9  | FALSE   |          1 |            4 | 5.398429 |    25 | FALSE        |

This provides only a brief overview of the features of
[maldipickr](https://github.com/ClavelLab/maldipickr), browse the other
vignettes to learn more about additional features.

## Session information

``` r

sessionInfo()
#> R version 4.6.0 (2026-04-24)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.4 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
#>  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
#>  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
#> [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
#> 
#> time zone: UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices datasets  utils     methods   base     
#> 
#> other attached packages:
#> [1] maldipickr_1.3.1.9000
#> 
#> loaded via a namespace (and not attached):
#>  [1] jsonlite_2.0.0           dplyr_1.2.1              compiler_4.6.0          
#>  [4] renv_1.0.3               MALDIquant_1.22.3        tidyselect_1.2.1        
#>  [7] parallel_4.6.0           tidyr_1.3.2              jquerylib_0.1.4         
#> [10] systemfonts_1.3.2        textshaping_1.0.5        yaml_2.3.12             
#> [13] fastmap_1.2.0            R6_2.6.1                 generics_0.1.4          
#> [16] knitr_1.51               tibble_3.3.1             desc_1.4.3              
#> [19] readBrukerFlexData_1.9.3 bslib_0.11.0             pillar_1.11.1           
#> [22] rlang_1.2.0              cachem_1.1.0             xfun_0.57               
#> [25] fs_2.1.0                 sass_0.4.10              cli_3.6.6               
#> [28] pkgdown_2.2.0            withr_3.0.2              magrittr_2.0.5          
#> [31] digest_0.6.39            lifecycle_1.0.5          vctrs_0.7.3             
#> [34] evaluate_1.0.5           glue_1.8.1               ragg_1.5.2              
#> [37] coop_0.6-3               rmarkdown_2.31           purrr_1.2.2             
#> [40] tools_4.6.0              pkgconfig_2.0.3          htmltools_0.5.9
```
