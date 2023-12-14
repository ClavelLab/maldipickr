Hello CRAN team,

this release helps users to ensure unique names during spectra processing and better handle discarding spectra. It also deprecates now unecessary RDS read/write features. The notes were the same as for v1.2.0 release.

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
* winbuilder R Under development (unstable) (2023-12-12 r85669 ucrt): *1 NOTE*

### NOTES

```
* checking CRAN incoming feasibility ... [24s] NOTE
Maintainer: 'Charlie Pauvert <cpauvert@ukaachen.de>'

Version contains large components (1.2.0.9000)
```

on: rhub Fedora Linux / rhub Ubuntu Linux / rhub Windows R-devel / winbuilder

=> _The submitted version will be 1.3.0_


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
