test_that("topojson_read works with file inputs", {
  skip_on_cran()

  file <- example_sys_file("us_states.topojson")
  aa <- topojson_read(file, stringsAsFactors = TRUE)
  df <- as.data.frame(aa)

  expect_s3_class(aa, "sf")
  expect_s3_class(df, "data.frame")
  expect_named(df, c("id", "geometry"))
  expect_s3_class(df$id, "factor")
  expect_s3_class(df$geometry, "sfc")
  expect_s3_class(df$geometry[[1]], "sfg")
})

test_that("topojson_read works with file inputs: stringsAsFactors works", {
  skip_on_cran()

  file <- example_sys_file("us_states.topojson")
  aa <- topojson_read(file, stringsAsFactors = FALSE)
  df <- as.data.frame(aa)
  expect_type(df$id, "character")
})

test_that("topojson_read works with url inputs", {
  skip_on_cran()
  skip_if_offline()

  url <- "https://raw.githubusercontent.com/shawnbot/d3-cartogram/master/data/us-states.topojson"
  aa <- topojson_read(url)
  df <- as.data.frame(aa)

  expect_s3_class(aa, "sf")
  expect_s3_class(df, "data.frame")
  expect_named(df, c("id", "geometry"))
})

test_that("topojson_read works with as.location inputs", {
  skip_on_cran()

  file <- example_sys_file("us_states.topojson")
  aa <- topojson_read(as.location(file))
  df <- as.data.frame(aa)

  expect_s3_class(aa, "sf")
  expect_s3_class(df, "data.frame")
})

test_that("topojson_read works with .json extension", {
  skip_on_cran()

  file <- withr::local_tempfile(fileext = ".json")
  cat('{"type":"Topology","objects":{"foo":{"type":"LineString","arcs":[0]}},"arcs":[[[100,0],[101,1]]],"bbox":[100,0,101,1]}',
    file = file
  )
  aa <- topojson_read(file)

  expect_s3_class(aa, "sf")
})
