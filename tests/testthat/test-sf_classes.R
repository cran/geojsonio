skip_on_cran()

if (requireNamespace("sf", quietly = TRUE)) {

  test_that("fc utility functions work", {
    file <- example_sys_file("feature_collection.geojson")
    testfc <- st_read(file, quiet = TRUE)
    expect_equal(get_sf_column_name(testfc), "geometry")

    expect_equal(get_geometry_type(testfc$geometry), "GEOMETRY")
    expect_equal(switch_geom_type(get_geometry_type(testfc$geometry)), "GeometryCollection")
  })

  ## POINT
  p_list <- lapply(list(c(3.2, 4), c(3, 4.6), c(3.8, 4.4)), sf::st_point)
  pt_sfc <- sf::st_sfc(p_list)
  pt_sf <- sf::st_sf(x = c("a", "b", "c"), pt_sfc)

  test_that("geojson_list works with points", {
    point_sfg_list <- geojson_list(pt_sfc[[1]])
    point_sfc_list <- geojson_list(pt_sfc)
    point_sf_list <- geojson_list(pt_sf)

    expect_s3_class(point_sfg_list, "geo_list")
    expect_s3_class(point_sfc_list, "geo_list")
    expect_s3_class(point_sf_list, "geo_list")

    expect_length(point_sfg_list, 2)
    expect_equal(point_sfg_list$type, "Point")
    expect_length(point_sfg_list$coordinates, 2)

    expect_length(point_sfc_list, 2)
    expect_equal(point_sfc_list$type, "GeometryCollection")
    expect_length(point_sfc_list$geometries, 3)
    expect_equal(
      sapply(point_sfc_list$geometries, function(x) length(x$coordinates)),
      c(2, 2, 2)
    )

    expect_length(point_sf_list, 2)
    expect_equal(point_sf_list$type, "FeatureCollection")
    expect_length(point_sf_list$features, 3)
    expect_equal(
      lapply(point_sf_list$features, `[[`, "geometry"),
      point_sfc_list$geometries
    )
  })

  test_that("geojson_json works with points", {
    pt_sfg_json <- geojson_json(pt_sfc[[1]])
    pt_sfc_json <- geojson_json(pt_sfc)
    pt_sf_json <- geojson_json(pt_sf)

    expect_equal(
      pt_sfg_json,
      "{\"type\":\"Point\",\"coordinates\":[3.2,4]}",
      ignore_attr = TRUE
    )

    expect_equal(
      pt_sfc_json,
      "{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Point\",\"coordinates\":[3.2,4]},{\"type\":\"Point\",\"coordinates\":[3,4.6]},{\"type\":\"Point\",\"coordinates\":[3.8,4.4]}]}",
      ignore_attr = TRUE
    )

    expect_equal(
      pt_sf_json,
      "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"x\":\"a\"},\"geometry\":{\"type\":\"Point\",\"coordinates\":[3.2,4]}},{\"type\":\"Feature\",\"properties\":{\"x\":\"b\"},\"geometry\":{\"type\":\"Point\",\"coordinates\":[3,4.6]}},{\"type\":\"Feature\",\"properties\":{\"x\":\"c\"},\"geometry\":{\"type\":\"Point\",\"coordinates\":[3.8,4.4]}}]}",
      ignore_attr = TRUE
    )
  })

  # ## MULTIPOINT
  p <- rbind(c(3.2, 4), c(3, 4.6), c(3.8, 4.4), c(3.5, 3.8), c(3.4, 3.6), c(3.9, 4.5))
  mp_sfg <- sf::st_multipoint(p)
  mp_sfc <- sf::st_sfc(mp_sfg)
  mp_sf <- sf::st_sf(x = "a", mp_sfc)

  test_that("geojson_list works with multipoints", {
    mp_sfg_list <- geojson_list(mp_sfg)
    mp_sfc_list <- geojson_list(mp_sfc)
    mp_sf_list <- geojson_list(mp_sf)

    expect_s3_class(mp_sfg_list, "geo_list")
    expect_s3_class(mp_sfc_list, "geo_list")
    expect_s3_class(mp_sf_list, "geo_list")
  })

  test_that("geojson_json works with multipoints", {
    mp_sfg_json <- geojson_json(mp_sfg)
    mp_sfc_json <- geojson_json(mp_sfc)
    mp_sf_json <- geojson_json(mp_sf)

    expect_s3_class(mp_sfg_json, "geojson")
    expect_s3_class(mp_sfc_json, "geojson")
    expect_s3_class(mp_sf_json, "geojson")

    expect_equal(
      mp_sfg_json,
      "{\"type\":\"MultiPoint\",\"coordinates\":[[3.2,4],[3,4.6],[3.8,4.4],[3.5,3.8],[3.4,3.6],[3.9,4.5]]}",
      ignore_attr = TRUE
    )

    expect_equal(
      mp_sfc_json,
      "{\"type\":\"MultiPoint\",\"coordinates\":[[3.2,4],[3,4.6],[3.8,4.4],[3.5,3.8],[3.4,3.6],[3.9,4.5]]}",
      ignore_attr = TRUE
    )

    expect_equal(
      mp_sf_json,
      "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"x\":\"a\"},\"geometry\":{\"type\":\"MultiPoint\",\"coordinates\":[[3.2,4],[3,4.6],[3.8,4.4],[3.5,3.8],[3.4,3.6],[3.9,4.5]]}}]}",
      ignore_attr = TRUE
    )
  })

  ## POLYGON
  p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
  p2 <- rbind(c(1, 1), c(1, 2), c(2, 2), c(1, 1))
  pol_sfg <- sf::st_polygon(list(p1, p2))
  pol_sfc <- sf::st_sfc(pol_sfg)
  pol_sf <- sf::st_sf(x = "a", pol_sfc)

  test_that("geojson_list works with polygons", {
    pol_sfg_list <- geojson_list(pol_sfg)
    pol_sfc_list <- geojson_list(pol_sfc)
    pol_sf_list <- geojson_list(pol_sf)

    expect_s3_class(pol_sfg_list, "geo_list")
    expect_s3_class(pol_sfc_list, "geo_list")
    expect_s3_class(pol_sf_list, "geo_list")
  })

  test_that("geojson_json works with polygons", {
    pol_sfg_json <- geojson_json(pol_sfg)
    pol_sfc_json <- geojson_json(pol_sfc)
    pol_sf_json <- geojson_json(pol_sf)

    expect_s3_class(pol_sfg_json, "geojson")
    expect_s3_class(pol_sfc_json, "geojson")
    expect_s3_class(pol_sf_json, "geojson")

    expect_equal(
      pol_sfg_json,
      "{\"type\":\"Polygon\",\"coordinates\":[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]]}",
      ignore_attr = TRUE
    )

    expect_equal(
      pol_sfc_json,
      "{\"type\":\"Polygon\",\"coordinates\":[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]]}",
      ignore_attr = TRUE
    )

    expect_equal(
      pol_sf_json,
      "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"x\":\"a\"},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]]}}]}",
      ignore_attr = TRUE
    )
  })

  ## MULTIPOLYGON
  p3 <- rbind(c(3, 0), c(4, 0), c(4, 1), c(3, 1), c(3, 0))
  p4 <- rbind(c(3.3, 0.3), c(3.8, 0.3), c(3.8, 0.8), c(3.3, 0.8), c(3.3, 0.3))[5:1, ]
  p5 <- rbind(c(3, 3), c(4, 2), c(4, 3), c(3, 3))
  mpol_sfg <- sf::st_multipolygon(list(list(p1, p2), list(p3, p4), list(p5)))
  mpol_sfc <- sf::st_sfc(mpol_sfg)
  mpol_sf <- sf::st_sf(x = "a", mpol_sfc)

  test_that("geojson_list works with multipolygons", {
    mpol_sfg_list <- geojson_list(mpol_sfg)
    mpol_sfc_list <- geojson_list(mpol_sfc)
    mpol_sf_list <- geojson_list(mpol_sf)

    expect_s3_class(mpol_sfg_list, "geo_list")
    expect_s3_class(mpol_sfc_list, "geo_list")
    expect_s3_class(mpol_sf_list, "geo_list")
  })

  test_that("geojson_json works with multipolygons", {
    mpol_sfg_json <- geojson_json(mpol_sfg)
    mpol_sfc_json <- geojson_json(mpol_sfc)
    mpol_sf_json <- geojson_json(mpol_sf)

    expect_s3_class(mpol_sfg_json, "geojson")
    expect_s3_class(mpol_sfc_json, "geojson")
    expect_s3_class(mpol_sf_json, "geojson")

    expect_equal(
      mpol_sfg_json,
      "{\"type\":\"MultiPolygon\",\"coordinates\":[[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]],[[[3,0],[4,0],[4,1],[3,1],[3,0]],[[3.3,0.3],[3.3,0.8],[3.8,0.8],[3.8,0.3],[3.3,0.3]]],[[[3,3],[4,2],[4,3],[3,3]]]]}",
      ignore_attr = TRUE
    )

    expect_equal(
      mpol_sfc_json,
      "{\"type\":\"MultiPolygon\",\"coordinates\":[[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]],[[[3,0],[4,0],[4,1],[3,1],[3,0]],[[3.3,0.3],[3.3,0.8],[3.8,0.8],[3.8,0.3],[3.3,0.3]]],[[[3,3],[4,2],[4,3],[3,3]]]]}",
      ignore_attr = TRUE
    )

    expect_equal(
      mpol_sf_json,
      "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"x\":\"a\"},\"geometry\":{\"type\":\"MultiPolygon\",\"coordinates\":[[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]],[[[3,0],[4,0],[4,1],[3,1],[3,0]],[[3.3,0.3],[3.3,0.8],[3.8,0.8],[3.8,0.3],[3.3,0.3]]],[[[3,3],[4,2],[4,3],[3,3]]]]}}]}",
      ignore_attr = TRUE
    )
  })

  ## TO TEST

  ## LINESTRING
  s1 <- rbind(c(0, 3), c(0, 4), c(1, 5), c(2, 5))
  ls_sfg <- sf::st_linestring(s1)
  ls_sfc <- sf::st_sfc(ls_sfg)
  ls_sf <- sf::st_sf(x = "a", ls_sfc)

  test_that("geojson_list works with linestrings", {
    ls_sfg_list <- geojson_list(ls_sfg)
    ls_sfc_list <- geojson_list(ls_sfc)
    ls_sf_list <- geojson_list(ls_sf)

    expect_s3_class(ls_sfg_list, "geo_list")
    expect_s3_class(ls_sfc_list, "geo_list")
    expect_s3_class(ls_sf_list, "geo_list")
  })

  test_that("geojson_json works with multilinestrings", {
    ls_sfg_json <- geojson_json(ls_sfg)
    ls_sfc_json <- geojson_json(ls_sfc)
    ls_sf_json <- geojson_json(ls_sf)

    expect_s3_class(ls_sfg_json, "geojson")
    expect_s3_class(ls_sfc_json, "geojson")
    expect_s3_class(ls_sf_json, "geojson")

    expect_equal(
      ls_sfg_json,
      "{\"type\":\"LineString\",\"coordinates\":[[0,3],[0,4],[1,5],[2,5]]}",
      ignore_attr = TRUE
    )

    expect_equal(
      ls_sfc_json,
      "{\"type\":\"LineString\",\"coordinates\":[[0,3],[0,4],[1,5],[2,5]]}",
      ignore_attr = TRUE
    )

    expect_equal(
      ls_sf_json,
      "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"x\":\"a\"},\"geometry\":{\"type\":\"LineString\",\"coordinates\":[[0,3],[0,4],[1,5],[2,5]]}}]}",
      ignore_attr = TRUE
    )
  })

  ## MULTILINESTRING
  s2 <- rbind(c(0.2, 3), c(0.2, 4), c(1, 4.8), c(2, 4.8))
  s3 <- rbind(c(0, 4.4), c(0.6, 5))
  mls_sfg <- sf::st_multilinestring(list(s1, s2, s3))
  mls_sfc <- sf::st_sfc(mls_sfg)
  mls_sf <- sf::st_sf(x = "a", mls_sfc)

  test_that("geojson_list works with multilinestrings", {
    mls_sfg_list <- geojson_list(ls_sfg)
    mls_sfc_list <- geojson_list(ls_sfc)
    mls_sf_list <- geojson_list(ls_sf)

    expect_s3_class(mls_sfg_list, "geo_list")
    expect_s3_class(mls_sfc_list, "geo_list")
    expect_s3_class(mls_sf_list, "geo_list")
  })

  test_that("geojson_json works with multilinestrings", {
    mls_sfg_json <- geojson_json(mls_sfg)
    mls_sfc_json <- geojson_json(mls_sfc)
    mls_sf_json <- geojson_json(mls_sf)

    expect_s3_class(mls_sfg_json, "geojson")
    expect_s3_class(mls_sfc_json, "geojson")
    expect_s3_class(mls_sf_json, "geojson")

    expect_equal(
      mls_sfg_json,
      "{\"type\":\"MultiLineString\",\"coordinates\":[[[0,3],[0,4],[1,5],[2,5]],[[0.2,3],[0.2,4],[1,4.8],[2,4.8]],[[0,4.4],[0.6,5]]]}",
      ignore_attr = TRUE
    )

    expect_equal(
      mls_sfc_json,
      "{\"type\":\"MultiLineString\",\"coordinates\":[[[0,3],[0,4],[1,5],[2,5]],[[0.2,3],[0.2,4],[1,4.8],[2,4.8]],[[0,4.4],[0.6,5]]]}",
      ignore_attr = TRUE
    )

    expect_equal(
      mls_sf_json,
      "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"x\":\"a\"},\"geometry\":{\"type\":\"MultiLineString\",\"coordinates\":[[[0,3],[0,4],[1,5],[2,5]],[[0.2,3],[0.2,4],[1,4.8],[2,4.8]],[[0,4.4],[0.6,5]]]}}]}",
      ignore_attr = TRUE
    )
  })

  # ## GEOMETRYCOLLECTION
  gc_sfg <- sf::st_geometrycollection(list(mp_sfg, mpol_sfg, ls_sfg))
  gc_sfc <- sf::st_sfc(gc_sfg)
  gc_sf <- sf::st_sf(x = "a", gc_sfc)

  test_that("geojson_list works with geometry collections", {
    gc_sfg_list <- geojson_list(gc_sfg)
    gc_sfc_list <- geojson_list(gc_sfc)
    gc_sf_list <- geojson_list(gc_sf)

    expect_s3_class(gc_sfg_list, "geo_list")
    expect_s3_class(gc_sfc_list, "geo_list")
    expect_s3_class(gc_sf_list, "geo_list")
  })

  test_that("geojson_json works with geometry collections", {
    gc_sfg_json <- geojson_json(gc_sfg)
    gc_sfc_json <- geojson_json(gc_sfc)
    gc_sf_json <- geojson_json(gc_sf)

    expect_s3_class(gc_sfg_json, "geojson")
    expect_s3_class(gc_sfc_json, "geojson")
    expect_s3_class(gc_sf_json, "geojson")

    expect_equal(
      gc_sfg_json,
      "{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"MultiPoint\",\"coordinates\":[[3.2,4],[3,4.6],[3.8,4.4],[3.5,3.8],[3.4,3.6],[3.9,4.5]]},{\"type\":\"MultiPolygon\",\"coordinates\":[[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]],[[[3,0],[4,0],[4,1],[3,1],[3,0]],[[3.3,0.3],[3.3,0.8],[3.8,0.8],[3.8,0.3],[3.3,0.3]]],[[[3,3],[4,2],[4,3],[3,3]]]]},{\"type\":\"LineString\",\"coordinates\":[[0,3],[0,4],[1,5],[2,5]]}]}",
      ignore_attr = TRUE
    )

    expect_equal(
      gc_sfc_json,
      "{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"MultiPoint\",\"coordinates\":[[3.2,4],[3,4.6],[3.8,4.4],[3.5,3.8],[3.4,3.6],[3.9,4.5]]},{\"type\":\"MultiPolygon\",\"coordinates\":[[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]],[[[3,0],[4,0],[4,1],[3,1],[3,0]],[[3.3,0.3],[3.3,0.8],[3.8,0.8],[3.8,0.3],[3.3,0.3]]],[[[3,3],[4,2],[4,3],[3,3]]]]},{\"type\":\"LineString\",\"coordinates\":[[0,3],[0,4],[1,5],[2,5]]}]}",
      ignore_attr = TRUE
    )

    expect_equal(
      gc_sf_json,
      "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"x\":\"a\"},\"geometry\":{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"MultiPoint\",\"coordinates\":[[3.2,4],[3,4.6],[3.8,4.4],[3.5,3.8],[3.4,3.6],[3.9,4.5]]},{\"type\":\"MultiPolygon\",\"coordinates\":[[[[0,0],[1,0],[3,2],[2,4],[1,4],[0,0]],[[1,1],[1,2],[2,2],[1,1]]],[[[3,0],[4,0],[4,1],[3,1],[3,0]],[[3.3,0.3],[3.3,0.8],[3.8,0.8],[3.8,0.3],[3.3,0.3]]],[[[3,3],[4,2],[4,3],[3,3]]]]},{\"type\":\"LineString\",\"coordinates\":[[0,3],[0,4],[1,5],[2,5]]}]}}]}",
      ignore_attr = TRUE
    )
  })

  test_that("Deals with Z and M dimensions: points", {
    pt_xyz <- sf::st_point(c(3, 4, 5), dim = "XYZ")
    pt_xym <- sf::st_point(c(3, 4, 5), dim = "XYM")
    pt_xyzm <- sf::st_point(c(3, 4, 5, 6), dim = "XYZM")

    expect_equal(geojson_list(pt_xyz)$coordinates, c(3, 4, 5))
    expect_message(
      expect_equal(
        geojson_list(pt_xym)$coordinates,
        c(3, 4)
      ),
      "removing M dimension as not supported in GeoJSON format"
    )
    expect_message(
      expect_equal(geojson_list(pt_xyzm)$coordinates, c(3, 4, 5)),
      "removing M dimension as not supported in GeoJSON format"
    )

    p_list_xyzm <- lapply(list(c(3.2, 4, 5, 6), c(3, 4.6, 6, 7), c(3.8, 4.4, 7, 8)),
      sf::st_point,
      dim = "XYZM"
    )
    pt_sfc_xyzm <- sf::st_sfc(p_list_xyzm)
    pt_sf_xyzm <- sf::st_sf(x = c("a", "b", "c"), pt_sfc_xyzm)
  })

  test_that("Deal with M dimensions: multipoint", {
    p <- rbind(
      c(3.2, 4, 5, 6), c(3, 4.6, 7, 8), c(3.8, 4.4, 9, 10),
      c(3.5, 3.8, 11, 12), c(3.4, 3.6, 13, 14), c(3.9, 4.5, 15, 16)
    )
    mp_sfg <- sf::st_multipoint(p, dim = "XYZM")
    mp_sfc <- sf::st_sfc(mp_sfg)
    mp_sf <- sf::st_sf(x = "a", mp_sfc)

    out <- supm(geojson_list(mp_sf))
    expect_equal(dim(out$features[[1]]$geometry$coordinates), c(6, 3))
  })

  test_that("sf columns of class units are processed as numeric", {
    pol_sf$area <- structure(rep(1, nrow(pol_sf)), class = "units")

    expect_s3_class(geojson_json(pol_sf), "geojson")
    expect_equal(sf::read_sf(geojson_json(pol_sf))[["area"]], as.numeric(pol_sf$area))
  })
  
  test_that("geojson is valid with named sfc input", {
    x <- sf::st_sfc(sf::st_point(0:1), sf::st_point(1:2))

    names(x) <- 1:2

    x_json <- geojson_json(x)

    expect_equal(
      unclass(x_json),
      "{\"type\":\"GeometryCollection\",\"geometries\":[{\"type\":\"Point\",\"coordinates\":[0,1]},{\"type\":\"Point\",\"coordinates\":[1,2]}]}",
      ignore_attr = TRUE
    )
  })
}

## Big test ------------------------------------------------------
## devtools::install_github("bcgov/bcmaps")
# library(bcmaps)
# eco_sf <- sf::st_as_sf(ecoprovinces)
# eco_sf <- sf::st_transform(eco_sf, 4326)
# eco_geojson <- geojson_json(eco_sf)
# map_gist(eco_geojson)
