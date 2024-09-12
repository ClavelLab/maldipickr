Hello CRAN team,

this patch release adds a new functions (aggregate spectra quality-check statistics) but mostly improve documentation, findability and few fixes.

Thank you for your time and engagement with the CRAN!

## R CMD check results

0 errors | 0 warnings | 0 notes

Tested locally:

* Ubuntu 20.04.6 LTS R-4.3.1

Tested remotely on R-Hub:

* gcc13 (R-devel, Fedora Linux 38)
* linux (R-devel, 22.04.4 LTS )
* macos (R-devel, x86_64-apple-darwin20): compilation failed for package ‘fs’
* macos-arm64 (R-devel, aarch64-apple-darwin20)
* windows (R-devel, Windows Server 2022)

Tested remotely (with `devtools::check_*`):

* mac release 4.4.0 (2024-04-24) aarch64-apple-darwin20
* winbuilder R Under development (unstable) (2024-09-10 r87115 ucrt): *1 NOTE* (large components version to be changed to 1.3.1 for submission)
* winbuilder R release 4.4.1 (2024-06-14 ucrt): *1 NOTE* (large components version to be changed to 1.3.1 for submission)

## revdepcheck results

There are currently no downstream dependencies for this package
