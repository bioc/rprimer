
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start --> [![R build
status](https://github.com/sofpn/rprimer/workflows/R-CMD-check/badge.svg)](https://github.com/sofpn/rprimer/actions)
<!-- badges: end -->

### Installation

You can install the development version of rprimer from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("sofpn/rprimer")
```

### Initial setup

``` r
# library(rprimer)
devtools::load_all(".")
library(magrittr)
```

### Introduction

In this document, I demonstrate how to use rprimer by designing an
RT-qPCR assay for detection of Hepatitis E virus (HEV).

### Step 0: Import alignment and mask positions with high gap frequency

For this part, I use previously existing functionality from the
Biostrings-package.

Align the target sequences of interest and import using
`Biostrings::readDNAMultipleAlignment()`. Mask positions with high gap
frequency using `Biostrings::maskGaps()`.

The file “example\_alignment” is provided with the package and consists
of 100 HEV sequences.

``` r
infile <- system.file('extdata', 'example_alignment.txt', package = 'rprimer')

myAlignment <- infile %>%
  Biostrings::readDNAMultipleAlignment(., format = "fasta") %>%
  Biostrings::maskGaps(., min.fraction = 0.5, min.block.width = 1)
```

### Step 1: `getAlignmentProfile()`

The first step is to retrieve the consensus matrix by using
`getAlignmentProfile()`, which is a wrapper around
`Biostrings::consensusMatrix()`. Positions that are masked in the
alignment are removed.

``` r
myAlignmentProfile <- getAlignmentProfile(myAlignment)
myAlignmentProfile[ , 1:30] ## View the first 30 bases 
#> class: RprimerProfile 
#> dim: 6 30 
#> metadata(0):
#> assays(1): x
#> rownames(6): A C ... - other
#> rowData names(0):
#> colnames(30): 1 2 ... 29 30
#> colData names(0):
```

The nucleotide distribution/sequence conservation at specific positions
can be visualized using `rpPlot()`. The `rc` option regulates whether
the alignment should be displayed as a reverse complement or not.

``` r
rpPlot(myAlignmentProfile[, 1:30], rc = FALSE) ## Plot the first 30 bases 
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

### Step 2: `getAlignmentProperties()`

`getAlignmentProperties()` takes an alignment profile as input and
returns a tibble (a data frame) with the following sequence properties:

  - Majority. The majority consensus sequence (the most frequently
    occurring nucleotide).
  - IUPAC. The IUPAC-consensus sequence, which includes wobble bases
    according to the IUPAC-nomenclature. All nucleotides with a
    proportion higher than or equal to the `iupacThreshold` will be
    included in the IUPAC-consensus sequence.
  - Gaps. The proportion of gaps.
  - Identity. The proportion of the most frequently occurring base.
  - Entropy. The Shannon entropy, which is a measurement of variability.
    A value of zero indicate no variability and a high value indicate
    high variability.

<!-- end list -->

``` r
myAlignmentProperties <- getAlignmentProperties(
  myAlignmentProfile, iupacThreshold = 0.05
)
head(myAlignmentProperties)
#> # A tibble: 6 x 6
#>   Position Majority IUPAC  Gaps Identity Entropy
#>      <int> <chr>    <chr> <dbl>    <dbl>   <dbl>
#> 1        1 G        G     0.41      1       0   
#> 2        2 G        G     0.290     1       0   
#> 3        3 C        C     0.290     1       0   
#> 4        4 A        A     0.290     1       0   
#> 5        5 G        G     0.290     0.99    0.11
#> 6        6 A        A     0.290     1       0
```

### Step 3: `getOligos()`

`getOligos()` searches for oligos that fulfill the following
constraints:

  - `maxGapFrequency` Maximum gap frequency, defaults to 0.1
  - `length` Oligo length, defaults to 18-22.
  - `maxDegeneracy` Maximum number of degenerate variants of each oligo,
    defaults to 4.
  - `gcClamp` If oligos must have a GC-clamp to be considered as valid
    (recommended for primers), defaults to `TRUE`.
  - `avoid3endRuns` If oligos with more than two runs of the same
    nucleotide at the terminal 3’ end should be excluded (recommended
    for primers), defaults to `TRUE`.
  - `avoid5endG` If oligos with a G at the terminal 5’ end should be
    avoided (recommended for probes), defaults to `FALSE`.
  - `minEndIdentity` Optional. Minimum allowed identity at the 3’ end
    (i.e. the last five bases). If set to 1, ………………..
  - `gcRange` GC-content-range, defaults to 0.45-0.55.
  - `tmRange` melting temperature (Tm) range, defaults to 48-65.
  - `concOligo` Oligo concentration (for Tm calculation), defaults to
    5e-07 M (500 nM)
  - `concNa` Sodium ion concentration (for Tm calculation), defaults to
    0.05 M (50 mM).
  - `showAllVariants` If sequence, GC-content and Tm should be presented
    for all variants of each oligo (in case of degenerate bases),
    defaults to `TRUE`.

In addition, `get_oligos()` avoids oligos:

  - With more than than three consecutive runs of the same dinucleotide
    (e.g. “TATATATA”)
  - With more than four consecutive runs of the same nucleotide
    (e.g. “AAAAA”)
  - That are duplicated (to prevent binding at several places on the
    genome)

Tm is calculated using the nearest-neighbor method. See
`?rprimer::getOligos` for a detailed description and references.

``` r
## Design primers with default settings  
myPrimers <- getOligos(myAlignmentProperties)
head(myPrimers)
#> # A tibble: 6 x 15
#>   Begin   End Length Majority Majority_RC GC_majority Tm_majority Identity IUPAC
#>   <int> <int>  <int> <chr>    <chr>             <dbl>       <dbl>    <dbl> <chr>
#> 1    27    44     18 <NA>     AAACTGATGG~         0.5        55.6     0.97 <NA> 
#> 2    28    45     18 <NA>     TAAACTGATG~         0.5        54.9     0.97 <NA> 
#> 3    43    60     18 TTATCAA~ <NA>                0.5        55.3     0.97 TYAT~
#> 4    44    61     18 TATCAAG~ <NA>                0.5        55.1     0.97 YATY~
#> 5    55    72     18 CTGGCAT~ <NA>                0.5        53.2     0.98 CTGG~
#> 6    64    81     18 <NA>     CCTGCTCAAT~         0.5        51.7     0.99 <NA> 
#> # ... with 6 more variables: IUPAC_RC <chr>, Degeneracy <int>, All <list>,
#> #   All_RC <list>, GC_all <list>, Tm_all <list>

## Design probes 
```

### Step 4: `getAssays()`

`getAssays()` finds pairs of forward and reverse primers that fulfill
the following criteria:

  - `length` Amplicon length. The default is 65-120.

  - `max_tm_difference` The maximum Tm difference between the two
    primers (absolute value, in C). The default is 1. Note that
    Tm-difference is calculated from the majority oligos, and may thus
    be misleading for degenerate (IUPAC) oligos. Here, `tmDifference` is
    the acceptable difference in Tm between the primers and probe. It is
    calculated by subtracting the Tm of the probe with the average Tm of
    the primer pair. Hence, a negative Tm-difference means that the Tm
    of the probe is lower than the average Tm of the primer pair. Note
    that the Tm-difference is calculated from the majority oligos, and
    may thus be misleading for degenerate (IUPAC) oligos.

Assays are displayed in a tibble (see below). An error message will
return if no assays are found.
