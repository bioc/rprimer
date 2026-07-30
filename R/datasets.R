#' Example datasets
#'
#' @name example-datasets
#'
#' @description
#' The purpose of these datasets is to illustrate the functionality of
#' rprimer. The following datasets are provided:
#'
#' \itemize{
#' \item \code{exampleRprimerAlignment} - a \code{MultipleAlignment::DNAMultipleAlignment}
#' object (Carlson & Aboyoun, 2020)
#' containing an alignment of 50 hepatitis E virus
#' sequences collected from NCBI GenBank. See
#' "documentation_example_alignment.txt" within the inst/script folder of this
#' package for more details.
#' \item \code{exampleRprimerProfile} - an \code{RprimerProfile} object, generated
#' from the alignment above.
#' \item \code{exampleRprimerOligo} - an \code{RprimerOligo} object, generated from
#' the consensus profile above.
#' \item \code{exampleRprimerAssay} - an \code{RprimerAssay} object, generated from
#' the oligos above.
#' \item \code{exampleRprimerMatchOligo} - an \code{RprimerMatchOligo} object,
#' describing how well some oligos match with the sequences in
#' exampleRprimerAlignment.
#' \item \code{exampleRprimerMatchAssay} - an \code{RprimerMatchAssay} object,
#' describing how well some assays match with the seuqences in
#' exampleRprimerAlignment.
#' }
#'
#' @references
#' M. Carlson and P. Aboyoun (2026). MultipleAlignment:
#' Representation of multiple sequence alignments in Bioconductor.
#' R package version 0.99.5.
NULL

#' @rdname example-datasets
#'
#' @usage data("exampleRprimerAlignment")
"exampleRprimerAlignment"

#' @rdname example-datasets
#'
#' @usage data("exampleRprimerProfile")
"exampleRprimerProfile"

#' @rdname example-datasets
#'
#' @usage data("exampleRprimerOligo")
"exampleRprimerOligo"

#' @rdname example-datasets
#'
#' @usage data("exampleRprimerAssay")
"exampleRprimerAssay"

#' @rdname example-datasets
#'
#' @usage data("exampleRprimerMatchOligo")
"exampleRprimerMatchOligo"

#' @rdname example-datasets
#'
#' @usage data("exampleRprimerMatchAssay")
"exampleRprimerMatchAssay"
