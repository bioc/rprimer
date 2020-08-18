
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Installation

You can install the development version of rprimer from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("sofpn/rprimer")
```

## Initial setup

``` r
# library(rprimer)
devtools::load_all(".")
library(magrittr)
```

## Import alignment and get sequence information

Prepare a .txt-file with an alignment of the sequences of interest (in
fasta format), and import it using `read_fasta_alignment()`. In this
example, I use an alignment with 100 HEV sequences that I have collected
from GenBank, which is provided with the package.

``` r
# Enter the filename of your alignment
infile <- system.file('extdata', 'example_alignment.txt', package = 'rprimer')

# Import the alignment and get sequence information
my_sequence_properties <- infile %>%
  read_fasta_alignment %>%
  remove_gaps(., threshold = 0.5)  %>%
  {select_roi(., from = 4000, to = 6000) ->> my_alignment} %>%
  {sequence_profile(.) ->> my_sequence_profile} %>%
  sequence_properties(., iupac_threshold = 0.1)
```

  - `remove_gaps()` is optional, and removes positions with a gap
    proportion higher than the stated `threshold` (the default is 0.5,
    i.e. 50 %).

  - `select_roi()` is optional, and selects a region of interest (ROI)
    within the alignment.

  - `sequence_profile()` takes an alignment as input and returns a
    matrix with the proportion of each nucleotide at each position in
    the alignment.

  - `sequence_properties()` takes a sequence profile as input and
    returns a tibble (a data frame) with information on majority and
    iupac consensus sequence, gap frequency, nucleotide identity and
    Shannon entropy.

These data can be visualized with `rp_plot()`:

``` r
rp_plot(my_alignment)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

``` r
rp_plot(my_sequence_profile, from = 20, to = 40, rc = FALSE)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

``` r
rp_plot(my_sequence_properties)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

## Get primers and probes

`get_oligos()` takes sequence properties as input and searches for
oligos that fulfill the following criteria:

  - `max_gap_frequency` Maximum allowed gap frequency. The default is
    0.1.

  - `length` Oligo length. The default is 18-22.

  - `max_degenerates` The maximum number of degenerate positions in each
    oligo. The default is 2.

  - `max_degeneracy` The maximum number of degenerate variants of each
    oligo. The default is 4.

  - `avoid_3end_ta` If oligos with a T or an A at the 3’ end should be
    avoided (recommended for primers to enhance specificity). The
    default is `TRUE`.

  - `avoid_3end_runs` If oligos with more than two runs of the same
    nucleotide at the 3’ end should be excluded (recommended for primers
    to avoid mispriming). The default is `TRUE`.

  - `avoid_gc_rich_3end` If oligos with more than three G or C within
    the last five bases of the 3’ end should be excluded (recommended
    for primers to avoid mispriming). The default is `TRUE`.

  - `avoid_5end_g` If oligos with a G at the 5’ end should be avoided
    (recommended for probes). The default is `FALSE`.

  - `gc_range` GC-content-range (proportion, not %). The default is
    0.45-0.55.

  - `tm_range` melting temperature (Tm) range. The default is 48-65
    degrees Celcius. Tm is calculated using the nearest-neighbor method.
    See `?rprimer::get_oligos` for a detailed description and
    references.

  - `conc_oligo` Oligo concentration (for Tm calculation). The default
    is 5e-07 M (500 nM).

  - `conc_na` Sodium ion concentration (for Tm calculation). The default
    is 0.05 M (50 mM).

In addition, `get_oligos()` avoids oligos:

  - With more than than three consecutive runs of the same dinucleotide
    (e.g. “TATATATA”)

  - With more than four consecutive runs of the same nucleotide
    (e.g. “AAAAA”)

  - That are duplicated (to prevent binding at several places on the
    genome)

<!-- end list -->

``` r
my_primers <- get_oligos(
  my_sequence_properties,
  target = my_alignment,
  max_gap_frequency = 0.05,
  length = 18:22,
  max_degenerates = 1,
  max_degeneracy = 2,
  avoid_3end_ta = TRUE,
  avoid_3end_runs = TRUE,
  avoid_gc_rich_3end = TRUE,
  avoid_5end_g = FALSE,
  gc_range = c(0.45, 0.60),
  tm_range = c(55, 70),
  conc_oligo = 5e-07,
  conc_na = 0.05
)

my_probes <- get_oligos(
  my_sequence_properties,
  target = my_alignment,
  max_gap_frequency = 0.05,
  length = 18:24,
  max_degenerates = 2,
  max_degeneracy = 4,
  avoid_3end_ta = FALSE,
  avoid_3end_runs = FALSE,
  avoid_gc_rich_3end = FALSE,
  avoid_5end_g = TRUE,
  gc_range = c(0.45, 0.60),
  tm_range = c(55, 70),
  conc_oligo = 2.5e-07,
  conc_na = 0.05
)
```

## Get assays and add probes

`get_assays()` finds pairs of forward and reverse primers that fulfill
the following criteria:

  - `length` Amplicon length. The default is 65-120.

  - `max_tm_difference` The maximum Tm difference between the two
    primers (absolute value, in C). The default is 1. Note that
    Tm-difference is calculated from the majority oligos, and may thus
    be misleading for degenerate (IUPAC) oligos.

Probes can be added to assays with `add_probes()`. Here, `tm_difference`
is the acceptable difference in Tm between the primers and probe. It is
calculated by subtracting the Tm of the probe with the average Tm of the
primer pair. Hence, a negative Tm-difference means that the Tm of the
probe is lower than the average Tm of the primer pair. Note that the
Tm-difference is calculated from the majority oligos, and may thus be
misleading for degenerate (IUPAC) oligos.

Assays are displayed in a tibble (see below). An error message will
return if no assays are found.

``` r
my_assays <- get_assays(
  my_primers, 
  length = 60:90, 
  max_tm_difference = 2
  ) %>%
  add_probes(
    ., my_probes, 
    tm_difference = c(-3, 5)
  )
```

## Save the data (if you want to)

Alignments, sequence properties, primer, probe and assay candidates can
be exported using `rp_save()`.

``` r
# rp_save(my_alignment, filename = "my_alignment")
# rp_save(my_sequence_properties, filename = "my_sequence_properties")
# rp_save(my_assays, filename = "my_assays")
```

## Select an assay and generate a report

You can select an assay and generate a report, for instance:

``` r
my_assays <- dplyr::arrange(my_assays, pm_majority_all)

selected_assay <- my_assays[1, ] # Select an assay

# write_report(
#  filename = "my_assay",
#  selected_assay,
#  my_sequence_profile,
#  my_sequence_properties,
#  comment = "my new RT-qPCR assay :)"
# )
```

It is also possible to generate reports for all assays, for instance:

``` r
# purrr::walk(seq_len(nrow(my_assays)), function(i) {
#  write_report(
#    filename = paste0("my_assay_report_", i),
#    my_assays[i, ],
#    my_sequence_profile,
#    my_sequence_properties,
#   comment = paste("my new hepatitis E virus assay, number", i)
#  )
#})
```
