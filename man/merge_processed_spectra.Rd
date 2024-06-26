% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/merge_processed_spectra.R
\name{merge_processed_spectra}
\alias{merge_processed_spectra}
\title{Merge multiple processed spectra and peaks}
\usage{
merge_processed_spectra(
  processed_spectra,
  remove_peakless_spectra = TRUE,
  interpolate_missing = TRUE
)
}
\arguments{
\item{processed_spectra}{A \link{list} of the processed spectra and associated peaks and metadata in two possible formats:
\itemize{
\item A list of \strong{in-memory objects} (named \code{spectra}, \code{peaks}, \code{metadata}) produced by \link{process_spectra}. Named lists will have names dropped, see Note.
\item \ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}} A list of \strong{paths} to RDS files produced by \link{process_spectra} when using the \code{rds_prefix} option.
}}

\item{remove_peakless_spectra}{A logical indicating whether to discard the spectra without detected peaks.}

\item{interpolate_missing}{A logical indicating if intensity values for missing peaks should be interpolated from the processed spectra signal or left NA which would then be converted to 0.}
}
\value{
A \emph{n}×\emph{p} matrix, with \emph{n} spectra as rows and \emph{p} features as columns that are the peaks found in all the processed spectra.
}
\description{
Aggregate multiple processed spectra, their associated peaks and metadata into a feature matrix and a concatenated metadata table.
}
\note{
When aggregating multiple runs of processed spectra, if a named list is
provided, note that the names will be dropped, to prevent further downstream
issues when these names were being appended to the rownames of the matrix
thus preventing downstream metadata merge.
}
\examples{
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
# Notice the difference when the interpolation is turned off
fm_no_interpolation <- merge_processed_spectra(
  list(processed),
  interpolate_missing = FALSE
)
sum(fm == 0) # 0
sum(fm_no_interpolation == 0) # 68

# Multiple runs can be aggregated using list()
# Merge the spectra to produce the feature matrix
fm_all <- merge_processed_spectra(list(processed, processed, processed))
# The feature matrix has 3×6=18 spectra as rows and
#  35 peaks as columns
dim(fm_all)

# If using a list, names will be dropped and are not propagated to the matrix.
\dontrun{
fm_all <- merge_processed_spectra(
 list("A" = processed, "B" = processed, "C" = processed))
any(grepl("A|B|C", rownames(fm_all))) # FALSE
 }

}
\seealso{
\link{process_spectra}, the "Value" section in \href{https://rdrr.io/cran/MALDIquant/man/intensityMatrix-functions.html}{\code{MALDIquant::intensityMatrix}}
}
