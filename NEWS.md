# maldipickr 1.3.0

## Fixed

* Fix non-unique names possibility during spectra processing (#37)

## Changed

* Deprecate ability to write RDS in `process_spectra()` (#38)
* Deprecate ability to read RDS in `merge_processed_spectra()`
* Change warnings in `check_spectra()` to messages pointing to use `remove_spectra()`

## Added

* Add `get_spectra_names()` to extract, format spectra names and warn against non-uniqueness
* Add `remove_spectra()` to better handle discarding raw or processed spectra
* Add `{lifecycle}` to better handle deprecation
* Add sections to the function reference list to improve clarity on website

# maldipickr 1.2.0

## Changed

* (**BREAKING**) Change homemade clustering to robust hierarchical clustering in `delineate_with_similarity()` (#32). The default method of hierarchical clustering is the complete linkage (also known as farthest neighbor clustering) to ensure that the within-group minimum similarity of each cluster respects the threshold
* Change `sapply()` calls to more type-robust `vapply()` calls

## Added

* (**BREAKING**) Set a minimum R version >= 3.2.0 (#31)
* Add hierarchical clustering linkage method as argument to `delineate_with_similarity()`
* Add tolerance argument to `check_spectra()` to allow flexible spectra length checks
* Add more unit tests to key functions: `pick_spectra()` (#26) and `merge_processed_spectra()` (#27)

## Fixed

* Fix missing spectra names when merging spectra lists with peak-less spectra
* Fix coverage update issue by adding codecov token (#34)

# maldipickr 1.1.1

## Fixed

* Fix typos for CRAN re-submission: missing brackets in reference, and spelling errors.

# maldipickr 1.1.0

## Fixed

* (URGENT) Fix `delineate_with_similarity()` that did not include friends-of-friends in clusters after removal of `{igraph}` in #18. Add a relevant similarity matrix to test it accordingly.

# maldipickr 1.0.2

## Changed

* Fix the invalid file `URIs` in `NEWS.md` and `README.md`

# maldipickr 1.0.1

## Changed

* Fix title to title case for CRAN

# maldipickr 1.0.0

## Changed

* (**BREAKING**) `read_biotyper_report()` first column is now `name` instead of `spot`, meaning `read_many_biotyper_reports()` renames all the `name` columns to `original_name`. This was to `pick_spectra()` easily usable with taxonomy identification reports (`38a614173fd21315a40e0823600a2082fa0935bb`)
* (**BREAKING**) All functions now follow the `verb_concept` nomenclature, meaning clustering functions are now renamed accordingly (#24):
    -  Change `similarity_to_clusters()` to `delineate_with_similarity()`
    -  Change `identification_to_clusters()` to `delineate_with_identification()`
* Refactor the `delineate_with_similarity()` clustering function (formerly: `similarity_to_clusters()`) without using the `{igraph}` nor `{tidygraph}` R packages, for fewer dependencies and simpler codebase (#18)
* Update the `DESCRIPTION` to include the Strejcek reference (#22) and better highlight the package added-value
* Refactor the `pkgdown` website with a more accessible font and color schema inline with the logo color palette
* Change the vignettes titles and outline to better structure the documents
* Refactor cosine similarity computation example by highlighting the dedicated `coop::tcosine()` instead of the `t() %>% coop::cosine()`

## Added

* Add long or wide output format for `read_biotyper_report()` (#12)
* Document how to quickstart with the `{maldipickr}` package for those in a hurry (#15)
* Document more precisely how to install tagged release of `{maldipickr}` package 
* Add better tests for `merge_processed_spectra()` (`b39c1313fd38239b4b1821a243c9debf467fd092`)
* Document authors list according to CRAN policy
* Add CRAN comments file to track submission notes

## Removed

* Deprecate the `CHANGELOG.md` in favor of the R specific `NEWS.md` (#20)
* Remove redundant check after symbolic links creation (#19)

## Fixed

* Fix `summarise()` usage in `pick_spectra()`, with code simplification (#11)
* Remove symbolic links created for importing acqu spectra files (#21)
* Fix CRAN warnings regarding `qpdf` (`3b19dd36a6ec0f5dc277418c98977c526981b6e3`)
* Fix masked relevant `to_pick` column in the vignette (#17)

# maldipickr 0.1.1

## Added

* Add citation file for R ([`CITATION`](https://clavellab.github.io/maldipickr/authors.html#citation)) and for GitHub `CITATION.cff`
* Add a `CHANGELOG.md` ([Common Changelog](https://common-changelog.org))

## Changed

* Improve the package description according to CRAN recommendations

# maldipickr 0.1.0

* First stable version

# maldipickr 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
