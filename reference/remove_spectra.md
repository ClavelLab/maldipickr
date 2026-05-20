# Remove (raw or processed) spectra

The `remove_spectra()` function is used to discard specific spectra from
(1) raw spectra list by removing them, or (2) processed spectra by
removing them from the spectra, peaks and metadata objects.

## Usage

``` r
remove_spectra(spectra_list, to_remove)
```

## Arguments

- spectra_list:

  A list of
  [MALDIquant::MassSpectrum](https://rdrr.io/pkg/MALDIquant/man/MassSpectrum-class.html)
  objects OR A list of processed spectra from
  [process_spectra](https://clavellab.github.io/maldipickr/reference/process_spectra.md)

- to_remove:

  The spectra to be removed. In the case of raw spectra: a logical
  vector same size of `spectra_list` or from
  [check_spectra](https://clavellab.github.io/maldipickr/reference/check_spectra.md)
  function. In the case of processed spectra: names of the spectra as
  formatted in
  [get_spectra_names](https://clavellab.github.io/maldipickr/reference/get_spectra_names.md)
  in the `sanitized_name` column.

## Value

The same object as `spectra_list` minus the spectra in `to_remove`.

## Examples

``` r
# Get an example directory of six Bruker MALDI Biotyper spectra
directory_biotyper_spectra <- system.file(
  "toy-species-spectra",
  package = "maldipickr"
)
# Import only the first two spectra
spectra_list <- import_biotyper_spectra(directory_biotyper_spectra)[1:2]
# Introduce artificially an empty raw spectra
spectra_list <- c(spectra_list, MALDIquant::createMassSpectrum(0, 0))
# Empty spectra are detected by `check_spectra()`
#   and can be removed by `remove_spectra()`
spectra_list %>% 
  remove_spectra(to_remove = check_spectra(.))
#> Some spectra are incorrect (empty, outlier length or irregular).
#> They can be removed using `remove_spectra()`
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

# Get an example processed spectra
processed_path <- system.file(
    "three_processed_spectra_with_one_peakless.RDS",
    package = "maldipickr")
processed <- readRDS(processed_path) %>% list()

# Remove a specific spectra
remove_spectra(processed, "empty_H12")
#> $spectra
#> $spectra$species1_G2
#> S4 class type            : MassSpectrum      
#> Number of m/z values     : 7867              
#> Range of m/z values      : 4000.066 - 9999.46
#> Range of intensity values: 0e+00 - 2.181e-03 
#> Memory usage             : 133.625 KiB       
#> Name                     : species1.G2       
#> File                     : /maldipickr/inst/toy-species-spectra/species1/0_G2/1/1SLin/fid
#> 
#> $spectra$species2_E11
#> S4 class type            : MassSpectrum      
#> Number of m/z values     : 7867              
#> Range of m/z values      : 4000.066 - 9999.46
#> Range of intensity values: 0e+00 - 2.58e-03  
#> Memory usage             : 133.625 KiB       
#> Name                     : species2.E11      
#> File                     : /maldipickr/inst/toy-species-spectra/species2/0_E11/1/1SLin/fid
#> 
#> 
#> $peaks
#> $peaks$species1_G2
#> S4 class type            : MassPeaks            
#> Number of m/z values     : 21                   
#> Range of m/z values      : 4030.815 - 9989.171  
#> Range of intensity values: 3.871e-04 - 2.181e-03
#> Range of snr values      : 3.623 - 10.382       
#> Memory usage             : 11.352 KiB           
#> Name                     : species1.G2          
#> File                     : /maldipickr/inst/toy-species-spectra/species1/0_G2/1/1SLin/fid
#> 
#> $peaks$species2_E11
#> S4 class type            : MassPeaks           
#> Number of m/z values     : 22                  
#> Range of m/z values      : 4031.408 - 9990.106 
#> Range of intensity values: 2.034e-04 - 2.58e-03
#> Range of snr values      : 3.14 - 11.027       
#> Memory usage             : 11.375 KiB          
#> Name                     : species2.E11        
#> File                     : /maldipickr/inst/toy-species-spectra/species2/0_E11/1/1SLin/fid
#> 
#> 
#> $metadata
#> # A tibble: 2 × 3
#>   name           SNR peaks
#>   <chr>        <dbl> <int>
#> 1 species1_G2   5.09    21
#> 2 species2_E11  5.54    22
#> 
```
