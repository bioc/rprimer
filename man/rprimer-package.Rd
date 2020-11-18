% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rprimer-package.R
\docType{package}
\name{rprimer-package}
\alias{rprimer}
\alias{rprimer-package}
\title{rprimer: Design (RT)-(q/d)PCR Assays from a Multiple DNA Sequence Alignment}
\description{
Functions and workflow to design
    primers, probes and (RT)-(q/d)PCR assays from a multiple DNA sequence 
    alignment. The functions are especially developed
    for sequence variable targets, such as RNA viruses. 
    Primers, probes and assays can be designed from
    user specified constraints on e.g. oligo and amplicon length, 
    GC-content, melting temperature and maximum allowed number degenerate 
    variants. Target regions with low sequence complexity are
    avoided. For primers, it is also possible to specify a threshold for minimum
    3'-end conservation and enforce a GC-clamp to increase the probability of
    amplification. Assays can be generated with or without probe, and
    can be designed upon user specified amplicon length and maximum allowed
    difference in melting temperature between primers, and between the primer
    pair and probe. Please see the package vignette for more information.
}
\details{
The three most important functions are \code{getConsensusProfile()},
\code{getOligos()} and \code{getAssays()}

For more information about rprimer and its
functionality, please see the package vignette.
}
\seealso{
Useful links:
\itemize{
  \item \url{https://github.com/sofpn/rprimer}
  \item Report bugs at \url{https://github.com/sofpn/rprimer/issues}
}

}
\author{
\strong{Maintainer}: Sofia Persson \email{sofiapersson27@gmail.com} (\href{https://orcid.org/0000-0003-2611-3030}{ORCID})

}
\keyword{internal}