## Import data to test on
data("exampleRprimerProfile")
data("exampleRprimerOligo")
data("exampleRprimerAssay")

# .plotData ====================================================================

test_that("plotData works", {
    p <- plotData(exampleRprimerProfile)
    expect_true(ggplot2::is.ggplot(p))
    p <- plotData(exampleRprimerProfile[1:100, ], highlight = c(1, 10))
    expect_true(ggplot2::is.ggplot(p))
    expect_error(plotData(exampleRprimerProfile, highlight = TRUE))
    p <- plotData(exampleRprimerOligo)
    expect_true(ggplot2::is.ggplot(p))
    p <- plotData(exampleRprimerOligo[exampleRprimerOligo$type == "primer", ])
    expect_true(ggplot2::is.ggplot(p))
    p <- plotData(exampleRprimerOligo[1, ])
    expect_true(ggplot2::is.ggplot(p))
    p <- plotData(exampleRprimerOligo[exampleRprimerOligo$type == "probe", ])
    expect_true(ggplot2::is.ggplot(p))
    p <- plotData(exampleRprimerAssay)
    expect_true(ggplot2::is.ggplot(p))
    p <- plotData(exampleRprimerAssay[1, ])
    expect_true(ggplot2::is.ggplot(p))
    p <- plotData(exampleRprimerProfile[1:10, ], type = "nucleotide")
    expect_true(ggplot2::is.ggplot(p))
    p <- plotData(exampleRprimerProfile[1:10, ], rc = TRUE, type = "nucleotide")
    expect_true(ggplot2::is.ggplot(p))
    expect_error(plotData(exampleRprimerProfile, rc = "t", type = "nucleotide"))
    expect_error(plotData(exampleRprimerProfile, type = "nt"))
    p <- ggplot2::ggplot() +
        .themeRprimer(showXAxis = FALSE, showYAxis = FALSE)
    expect_true(ggplot2::is.ggplot(p))
})

test_that("plotData returns an error when it should", {
    expect_error(plotData(unclass(exampleRprimerProfile)))
    expect_error(plotData(exampleRprimerProfile, shadeFrom = FALSE))
    expect_error(plotData(exampleRprimerProfile, shadeTo = FALSE))
    expect_error(plotData(
        exampleRprimerProfile,
        type = "nucleotide", rc = "FALSE"
    ))
    expect_error(plotData(exampleRprimerProfile, type = ""))
    expect_error(plotData(unclass(exampleRprimerOligo)))
    expect_error(plotData(unclass(exampleRprimerAssay)))
})

test_that(".runningAverage works", {
    toTest <- runif(100)
    expect_identical(nrow(.runningAverage(toTest)), length(toTest))
    toTest <- runif(10)
    expect_identical(nrow(.runningAverage(toTest)), length(toTest))
    toTest <- runif(1000)
    expect_equal(.runningAverage(toTest, size = 100)$position[1], 50)
})
