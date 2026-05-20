# Importing spectra from the Bruker MALDI Biotyper device

This function is a wrapper around the
[`readBrukerFlexData::readBrukerFlexDir()`](https://rdrr.io/pkg/readBrukerFlexData/man/readBrukerFlexDir.html)
to read both `acqus` and `acqu` MALDI files.

## Usage

``` r
import_biotyper_spectra(
  biotyper_directory,
  remove_calibration = c("BTS", "Autocalibration")
)
```

## Arguments

- biotyper_directory:

  A path to the folder tree with the spectra to be imported.

- remove_calibration:

  A vector of characters used as regex to indicate which (calibration)
  spectra are going to be removed.

## Value

A list of
[MALDIquant::MassSpectrum](https://rdrr.io/pkg/MALDIquant/man/MassSpectrum-class.html)
objects

## Details

When using
[`readBrukerFlexData::readBrukerFlexDir()`](https://rdrr.io/pkg/readBrukerFlexData/man/readBrukerFlexDir.html)
on `acqus` files (instead of the native `acqu` files), the function will
fail with the following error message:

    Error in .readAcquFile(fidFile = fidFile, verbose = verbose) :
    File ‘/data/maldi_dir/targetA/0_D10/1/1SLin/acqu’ doesn't exists!

But it turns out that `acqu` and `acqus` files [are the
same](https://github.com/sgibb/readBrukerFlexData/wiki/acqu-file), so
the function here create `acqu` symbolic links that point to `acqus`
files.

## See also

[check_spectra](https://clavellab.github.io/maldipickr/reference/check_spectra.md),
[process_spectra](https://clavellab.github.io/maldipickr/reference/process_spectra.md)

## Examples

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
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.6/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species1/0_G2/1/1SLin/fid
#> 
#> [[2]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1962.222 - 20146.522
#> Range of intensity values: 1.82e+02 - 1.006e+04
#> Memory usage             : 337.062 KiB         
#> Name                     : species2.E11        
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.6/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species2/0_E11/1/1SLin/fid
#> 
#> [[3]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1962.222 - 20146.522
#> Range of intensity values: 3.25e+02 - 2.115e+04
#> Memory usage             : 337.062 KiB         
#> Name                     : species2.E12        
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.6/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species2/0_E12/1/1SLin/fid
#> 
#> [[4]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1961.215 - 20135.904
#> Range of intensity values: 1.94e+02 - 2.055e+04
#> Memory usage             : 337.062 KiB         
#> Name                     : species3.F7         
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.6/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species3/0_F7/1/1SLin/fid
#> 
#> [[5]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1961.215 - 20135.904
#> Range of intensity values: 1.6e+02 - 1.814e+04 
#> Memory usage             : 337.062 KiB         
#> Name                     : species3.F8         
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.6/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species3/0_F8/1/1SLin/fid
#> 
#> [[6]]
#> S4 class type            : MassSpectrum        
#> Number of m/z values     : 20882               
#> Range of m/z values      : 1961.215 - 20135.904
#> Range of intensity values: 1.59e+02 - 1.449e+04
#> Memory usage             : 337.062 KiB         
#> Name                     : species3.F9         
#> File                     : /home/runner/.cache/R/renv/library/maldipickr-8ce40efa/R-4.6/x86_64-pc-linux-gnu/maldipickr/toy-species-spectra/species3/0_F9/1/1SLin/fid
#> 
```
