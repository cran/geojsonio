test_that("precision argument works with polygons", {
  skip_on_travis()
  skip_on_cran()
  
  poly <- c(c(-114.345703125,39.436192999314095),
            c(-114.345703125,43.45291889355468),
            c(-106.61132812499999,43.45291889355468),
            c(-106.61132812499999,39.436192999314095),
            c(-114.345703125,39.436192999314095))
  gwf1 <- withr::local_tempfile(fileext = ".topojson")
  a <- supw(supm(topojson_write(poly, geometry = "polygon", file = gwf1)))
  expect_s3_class(a, "topojson_file")
  a_txt <- gsub("\\s+", " ", paste0(readLines(gwf1), collapse = ""))
  expect_equal(
    a_txt,
    "{\"type\":\"Topology\",\"objects\":{\"foo\":{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Polygon\",\"arcs\":[[0]],\"properties\":{\"dummy\":0}}]}},\"arcs\":[[[-114.345703125,39.436192999314095],[-114.345703125,43.45291889355468],[-106.61132812499999,43.45291889355468],[-106.61132812499999,39.436192999314095],[-114.345703125,39.436192999314095]]],\"bbox\":[-114.345703125,39.436192999314095,-106.61132812499999,43.45291889355468]}"
  )
  
  gwf2 <- withr::local_tempfile(fileext = ".topojson")
  b <- supw(supm(topojson_write(poly, geometry = "polygon", precision = 2, file = gwf2)))
  expect_s3_class(b, "topojson_file")
  b_txt <- gsub("\\s+", " ", paste0(readLines(gwf2), collapse = ""))
  expect_equal(
    b_txt,
    "{\"type\":\"Topology\",\"objects\":{\"foo\":{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Polygon\",\"arcs\":[[0]],\"properties\":{\"dummy\":0}}]}},\"arcs\":[[[-114.35,39.44],[-114.35,43.45],[-106.61,43.45],[-106.61,39.44],[-114.35,39.44]]],\"bbox\":[-114.35,39.44,-106.61,43.45]}"
  )
})

test_that("precision argument works with points", {
  skip_on_travis()
  skip_on_cran()
  
  gwf3 <- withr::local_tempfile(fileext = ".topojson")
  cc <- supm(topojson_write(us_cities[1:2,], lat = 'lat', lon = 'long', precision = 2, file = gwf3))
  expect_s3_class(cc, "topojson_file")
  cc_txt <- gsub("\\s+", " ", paste0(readLines(gwf3), collapse = ""))
  expect_equal(
    cc_txt,
    "{\"type\":\"Topology\",\"objects\":{\"foo\":{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Point\",\"coordinates\":[-99.74,32.45],\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":113888,\"lat\":32.45,\"long\":-99.74,\"capital\":0}},{\"type\":\"Point\",\"coordinates\":[-81.52,41.08],\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":206634,\"lat\":41.08,\"long\":-81.52,\"capital\":0}}]}},\"arcs\":[],\"bbox\":[-99.74,32.45,-81.52,41.08]}"
  )
  
  gwf4 <- withr::local_tempfile(fileext = ".topojson")
  d <- supm(topojson_write(us_cities[1:2,], lat = 'lat', lon = 'long', precision = 1, file = gwf4))
  expect_s3_class(d, "topojson_file")
  d_txt <- gsub("\\s+", " ", paste0(readLines(gwf4), collapse = ""))
  expect_equal(
    d_txt,
    "{\"type\":\"Topology\",\"objects\":{\"foo\":{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Point\",\"coordinates\":[-99.7,32.5],\"properties\":{\"name\":\"Abilene TX\",\"country.etc\":\"TX\",\"pop\":113888,\"lat\":32.45,\"long\":-99.74,\"capital\":0}},{\"type\":\"Point\",\"coordinates\":[-81.5,41.1],\"properties\":{\"name\":\"Akron OH\",\"country.etc\":\"OH\",\"pop\":206634,\"lat\":41.08,\"long\":-81.52,\"capital\":0}}]}},\"arcs\":[],\"bbox\":[-99.7,32.5,-81.5,41.1]}"
  )
})

test_that("precision argument works with sp objects", {
  skip_on_travis()
  skip_on_cran()
  
  poly1 <- Polygons(list(Polygon(cbind(c(-100.111,-90.111,-85.111,-100.111),
                                       c(40.111,50.111,45.111,40.111)))), "1")
  poly2 <- Polygons(list(Polygon(cbind(c(-90.111,-80.111,-75.111,-90.111),
                                       c(30.111,40.111,35.111,30.111)))), "2")
  sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
  
  gwf5 <- withr::local_tempfile(fileext = ".topojson")
  e <- supm(topojson_write(sp_poly, file = gwf5))
  expect_s3_class(e, "topojson_file")
  e_txt <- gsub("\\s+", " ", paste0(readLines(gwf5), collapse = ""))
  expect_equal(e_txt, "{\"type\":\"Topology\",\"objects\":{\"foo\":{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Polygon\",\"arcs\":[[0]],\"properties\":{\"dummy\":0}},{\"type\":\"Polygon\",\"arcs\":[[1]],\"properties\":{\"dummy\":0}}]}},\"arcs\":[[[-100.111,40.111],[-90.111,50.111],[-85.111,45.111],[-100.111,40.111]],[[-90.111,30.111],[-80.111,40.111],[-75.111,35.111],[-90.111,30.111]]],\"bbox\":[-100.111,30.111,-75.111,50.111]}")
  
  gwf6 <- withr::local_tempfile(fileext = ".topojson")
  f <- supm(topojson_write(sp_poly, precision = 2, file = gwf6))
  expect_s3_class(f, "topojson_file")
  f_txt <- gsub("\\s+", " ", paste0(readLines(gwf6), collapse = ""))
  expect_equal(f_txt, "{\"type\":\"Topology\",\"objects\":{\"foo\":{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Polygon\",\"arcs\":[[0]],\"properties\":{\"dummy\":0}},{\"type\":\"Polygon\",\"arcs\":[[1]],\"properties\":{\"dummy\":0}}]}},\"arcs\":[[[-100.11,40.11],[-90.11,50.11],[-85.11,45.11],[-100.11,40.11]],[[-90.11,30.11],[-80.11,40.11],[-75.11,35.11],[-90.11,30.11]]],\"bbox\":[-100.11,30.11,-75.11,50.11]}")
})

test_that("topojson_write detects inproper polygons passed as lists inputs", {
  good <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,0.0))
  bad <- list(c(100.0,0.0), c(101.0,0.0), c(101.0,1.0), c(100.0,1.0), c(100.0,1))
  
  # fine
  gwf7 <- withr::local_tempfile(fileext = ".topojson")
  fine <- supw(supm(topojson_write(good, geometry = "polygon", file = gwf7)))
  expect_s3_class(fine, "topojson_file")
  expect_type(fine[[1]], "character")
  
  # bad
  expect_error(topojson_write(bad, geometry = "polygon"),
               "First and last point in a polygon must be identical")
  
  # doesn't matter if geometry != polygon
  expect_s3_class(supm(topojson_write(bad)), "topojson_file")
})

test_that("topojson_write unclasses columns with special classes so writeOGR works", {
  skip_if_not_installed("sf")
  poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
                                       c(40,50,45,40)))), "1")
  spdf <- SpatialPolygonsDataFrame(SpatialPolygons(list(poly1), 1L),
                                   data.frame(a = structure(1.5, class = "units"),
                                              b = ordered("z")))
  gwf8 <- withr::local_tempfile(fileext = ".topojson")
  expect_s3_class(topojson_write(spdf, file = gwf8), "topojson_file")
  spdf2 <- as(sf::st_read(gwf8, quiet = TRUE, stringsAsFactors = FALSE), "Spatial")
  expect_type(spdf2@data$a, "double")
  expect_type(spdf2@data$b, "character")
})

test_that("topojson_write works with different object name", {
  vec <- c(-99.74, 32.45)
  gwf9 <- withr::local_tempfile(fileext = ".topojson")
  x <- topojson_write(vec, file = gwf9, object_name = "California")
  expect_s3_class(x, "topojson_file")
  expect_true(grepl("California", readLines(gwf9)))
  # quantization=0 : no transform/scale/translate attribute
  expect_false(grepl("transform", readLines(gwf9)))
  expect_false(grepl("scale", readLines(gwf9)))
  expect_false(grepl("translate", readLines(gwf9)))
})


test_that("topojson_write works with quantization > 0", {
  vec <- c(-99.74, 32.45)
  gwf9 <- withr::local_tempfile(fileext = ".topojson")
  x <- topojson_write(vec, file = gwf9, quantization = 1e4)
  expect_s3_class(x, "topojson_file")
  expect_true(grepl("transform", readLines(gwf9)))
  expect_true(grepl("scale", readLines(gwf9)))
  expect_true(grepl("translate", readLines(gwf9)))
})
