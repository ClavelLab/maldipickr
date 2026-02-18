# Import data from Bruker MALDI Biotyper

``` r
library(maldipickr)
```

The matrix-assisted laser desorption/ionization-time-of-flight
(MALDI-TOF) technology is coupled with mass spectrometry in the Bruker
MALDI Biotyper device in order to identify microorganisms. The device
generates two types of data:

1.  A report of the identification using its proprietary database of
    mass spectrum projections (MSPs).
2.  The raw mass spectrometry data.

The following vignette describe how to streamline the import of these
two types of data into R using the
[`{maldipickr}`](https://github.com/ClavelLab/maldipickr) package

## Importing generated reports from the Bruker MALDI Biotyper device

### Importing a single report

The Bruker MALDI Biotyper generates a report via the Compass software
summarizing the identification of the microorganisms using its internal
database. While the file is separated by semi-colons, it contains no
headers. The report has many columns in a *wide* format to describe the
ten hits when identification is feasible, or only a few when no
identification was possible. All-in-all, this makes the table import
into R and its manipulation relatively painful.

Below is an example of an import of a single Bruker MALDI Biotyper
report into a [`{tibble}`](https://tibble.tidyverse.org). By default,
only the best hit of each colony is reported. All hits can be reported
as well, in the *long* format (`long_format = TRUE`), for further
explorations with the [`{tidyverse}`](https://tidyverse.tidyverse.org/)
suite.

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

### Importing multiple reports

During large-scale analysis, batches of identification are run and can
easily be imported using the `read_many_biotyper_reports` function along
with their custom-made metadata.

Below is an example of such usage, where one report was artificially
extended into multiple reports.

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

## Importing spectra from the Bruker MALDI Biotyper device

Other than the identification reports, the Bruker MALDI Biotyper device
outputs the raw data used for the identification (if not the database)
in the form of mass spectra. Thankfully, the
[`{MALDIquant}`](https://strimmerlab.github.io/software/maldiquant/) and
[`{readBrukerFlexData}`](https://cran.r-project.org/package=readBrukerFlexData)
packages help users import and manipulate these data in R.

### Importing multiple spectra from a directory hierarchy

However, when the Bruker MALDI Biotyper device produces `acqus` files
(instead of the native `acqu` files), the
[`readBrukerFlexDir()`](https://rdrr.io/cran/readBrukerFlexData/man/readBrukerFlexDir.html)
function from the
[`{readBrukerFlexData}`](https://cran.r-project.org/package=readBrukerFlexData)
package will fail with the following error message:

    Error in .readAcquFile(fidFile = fidFile, verbose = verbose) :
    File ‘/data/maldi_dir/targetA/0_D10/1/1SLin/acqu’ doesn't exists!

The following
[`import_biotyper_spectra()`](https://clavellab.github.io/maldipickr/reference/import_biotyper_spectra.html))
function used in the example below circumvent this error by creating a
symbolic link and conveniently helps removing calibration samples.

The toy dataset bundled with this package is a subset of a dataset in
the
[`{MALDIquantExamples}`](https://github.com/sgibb/MALDIquantExamples)
package and consist here of six spectra: \* 1 replicate of species 1 \*
2 replicates of species 2 \* 3 replicates of species 3

``` r
# Get an example directory of six Bruker MALDI Biotyper spectra
directory_biotyper_spectra <- system.file(
  "toy-species-spectra",
  package = "maldipickr"
)
# Import the six spectra
spectra_list <- import_biotyper_spectra(directory_biotyper_spectra)
# Display the list of spectra
spectra_list
#> [[1]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1962.222 - 20146.522
#> Range of intensity values: 2.4e+02 - 3.608e+04 
#> Memory usage             : 337.062 KiB         
#> Name                     : species1.G2         
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.5/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species1/0_G2/1/1SLin/fid
#> 
#> [[2]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1962.222 - 20146.522
#> Range of intensity values: 1.82e+02 - 1.006e+04
#> Memory usage             : 337.062 KiB         
#> Name                     : species2.E11        
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.5/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species2/0_E11/1/1SLin/fid
#> 
#> [[3]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1962.222 - 20146.522
#> Range of intensity values: 3.25e+02 - 2.115e+04
#> Memory usage             : 337.062 KiB         
#> Name                     : species2.E12        
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.5/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species2/0_E12/1/1SLin/fid
#> 
#> [[4]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1961.215 - 20135.904
#> Range of intensity values: 1.94e+02 - 2.055e+04
#> Memory usage             : 337.062 KiB         
#> Name                     : species3.F7         
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.5/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species3/0_F7/1/1SLin/fid
#> 
#> [[5]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1961.215 - 20135.904
#> Range of intensity values: 1.6e+02 - 1.814e+04 
#> Memory usage             : 337.062 KiB         
#> Name                     : species3.F8         
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.5/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species3/0_F8/1/1SLin/fid
#> 
#> [[6]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1961.215 - 20135.904
#> Range of intensity values: 1.59e+02 - 1.449e+04
#> Memory usage             : 337.062 KiB         
#> Name                     : species3.F9         
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.5/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species3/0_F9/1/1SLin/fid
```

### Evaluate the quality of the spectra

Once the spectra are imported, the
[`check_spectra()`](https://clavellab.github.io/maldipickr/reference/check_spectra.html)
function can easily assess whether all the spectra in the list are not
empty, of the same length and correspond to profile data. If some
spectra do not satisfy these criteria, the function will exit with a
warning and indicate the faulty spectra. Either way, the function
outputs a list of logical vectors (`TRUE` or `FALSE`) indicating whether
each of the spectra are empty (`is_empty`), of an odd length
(`is_outlier_length`) or not a profile spectra (`is_not_regular`).

``` r
# Get an example directory of six Bruker MALDI Biotyper spectra
directory_biotyper_spectra <- system.file(
  "toy-species-spectra",
  package = "maldipickr"
)
# Import the six spectra
spectra_list <- import_biotyper_spectra(directory_biotyper_spectra)
# Display the list of checks, with FALSE where no anomaly is detected
check_spectra(spectra_list)
#> $is_empty
#> [1] FALSE FALSE FALSE FALSE FALSE FALSE
#> 
#> $is_outlier_length
#> [1] FALSE FALSE FALSE FALSE FALSE FALSE
#> 
#> $is_not_regular
#> [1] FALSE FALSE FALSE FALSE FALSE FALSE
# The overall sanity can be checked with Reduce
Reduce(any, check_spectra(spectra_list)) # Should be FALSE
#> [1] FALSE
```
