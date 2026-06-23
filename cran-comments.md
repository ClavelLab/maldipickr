Hello CRAN team,

this patch release fixes premature NA if samples were incorrectly named, and adds the proper citation to the peer-reviewed article.

Thank you for your time and engagement with the CRAN!

## R CMD check results

0 errors | 0 warnings | 0 notes

Tested locally:

* Ubuntu 20.04.6 LTS R-4.3.1

Tested remotely on R-Hub via Github Actions:

* gcc16 (R-devel)
* linux (R-devel)
* macos (R-devel): no runner picked up so ran another mac test with devtools
* macos-arm64 (R-devel)
* windows (R-devel)

Tested remotely (with `devtools::check_*`):

* mac release 4.6.0 r-release-macosx-arm64
* winbuilder R Under development (unstable) (2026-06-19 r90183 ucrt)


## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
