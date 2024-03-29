test_that("projections works with different projection names", {
  skip_on_cran()

  expect_type(projections("albers"), "character")
  expect_type(projections("orthographic"), "character")
  expect_type(projections("conicEqualArea"), "character")
  expect_type(projections("stereographic"), "character")
  expect_type(projections("conicEquidistant"), "character")

  expect_equal(projections("albers"), "d3.geo.albers()")
  expect_equal(projections("orthographic"), "d3.geo.orthographic()")
})

test_that("projections works with rotate parameter", {
  skip_on_cran()

  aa <- projections(proj = "albers", rotate = "[98 + 00 / 60, -35 - 00 / 60]", scale = 5700)

  expect_type(aa, "character")
  expect_match(aa, "geo.albers")
  expect_match(aa, "rotate")
  expect_match(aa, "scale")
})

test_that("projections works with scale parameter", {
  skip_on_cran()

  aa <- projections(proj = "albers", scale = 5700)

  expect_type(aa, "character")
  expect_match(aa, "scale\\(5700\\)")
})

test_that("projections works with translate parameter", {
  skip_on_cran()

  aa <- projections(proj = "albers", translate = "[55 * width / 100, 52 * height / 100]")

  expect_type(aa, "character")
  expect_match(aa, "translate")
  expect_match(aa, "width")
})

test_that("projections works with clipAngle parameter", {
  skip_on_cran()

  aa <- projections(proj = "albers", clipAngle = 90)

  expect_type(aa, "character")
  expect_match(aa, "clipAngle")
})

test_that("projections fails well", {
  skip_on_cran()

  expect_error(projections(), "You must provide a character string to 'proj'")
  ## FIXME - add tests for, and make changes to fxn, for forcing inputs to be of correct type

  expect_error(
    projections("alber"),
    "no match for 'proj' parameter input"
  )
})
