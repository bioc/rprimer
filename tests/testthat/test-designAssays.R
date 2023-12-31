## Import data to test on
data("exampleRprimerOligo")
x <- exampleRprimerOligo

# assays =======================================================================

test_that("designAssays returns an error when it sould", {
    expect_error(designAssays(unclass(x)))
    expect_error(designAssays(x, length = c(39, 120)))
    expect_error(designAssays(x, length = c(40, 50001)))
    expect_error(designAssays(x, tmDifferencePrimers = FALSE))
})

test_that("designAssays works", {
    test <- designAssays(x)
    expect_s4_class(test, "RprimerAssay")
})

# .pairPrimers =================================================================

# .combinePrimers ==============================================================

test_that(".combinePrimers works", {
    test <- .combinePrimers(x,
        length = c(100, 2000), tmDifferencePrimers = 2
    )
    expect_true(all(test$length >= 100))
    expect_true(all(test$length <= 2000))
    expect_equal(test$end - test$start, test$length - 1)
    expect_error(.combinePrimers(x[1, ]))
    expect_true(all(abs(test$tmMeanFwd - test$tmMeanRev) <= 2))
})

# .identifyProbes ==============================================================

test_that(".identifyProbes works", {
    assays <- .combinePrimers(x)
    test <- .identifyProbes(assays, x[x$type == "probe", ])
    expect_equal(nrow(assays), length(test))
})

# .extractProbes ===============================================================

test_that(".extractProbes works", {
    assays <- .combinePrimers(x)
    probes <- .identifyProbes(assays, x[x$type == "probe", ])
    test <- .extractProbes(assays, probes)
    expect_true(all(test$startPr - test$endFwd >= 1))
    expect_true(all(test$startRev - test$endPr >= 1))
})

# .addProbes ===================================================================

# .beautifyPrimers =============================================================

# .beautifyProbes ==============================================================
