Hello CRAN team,

this release sets a minimum R version and change a homemade clustering to a robust hierarchical clustering in one of the key function.

Thank you for your time!

## R CMD check results

0 errors | 0 warnings | 0 notes

Tested locally:

* Ubuntu 22.04.3 LTS R-4.3.1

Tested remotely:

* rhub Windows Server 2022, R-release, 32/64 bit: *0 NOTE*
* rhub Fedora Linux, R-devel, clang, gfortran: *2 NOTES*
* rhub Ubuntu Linux 20.04.1 LTS, R-release, GCC: *2 NOTES*
* rhub Windows Server 2022, R-devel, 64 bit: *4 NOTES*
* winbuilder R Under development (unstable) (2023-10-24 r85407 ucrt): *1 NOTE*

### NOTES

```
* checking CRAN incoming feasibility ... [12s] NOTE
Maintainer: 'Charlie Pauvert <cpauvert@ukaachen.de>'

Version contains large components (1.1.1.9000)
```

on: rhub Fedora Linux / rhub Ubuntu Linux / rhub Windows R-devel / winbuilder

=> _The submitted version will be 1.2.0_


```
* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
Skipping checking math rendering: package 'V8' unavailable
```

on: rhub Fedora Linux / rhub Ubuntu Linux / rhub Windows R-devel

```
* checking for non-standard things in the check directory ... NOTE
Skipping checking math rendering: package 'V8' unavailable
Found the following files/directories:
  ''NULL''
```

on: rhub Windows R-devel

```
* checking for detritus in the temp directory ... NOTE
  'lastMiKTeXException'
Found the following files/directories:
```

on: rhub Windows R-devel

=> _The last 3 notes relate to the testing environment not to the package_


## revdepcheck results

There are currently no downstream dependencies for this package
