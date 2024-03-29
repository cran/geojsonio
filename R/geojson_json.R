#' Convert many input types with spatial data to geojson specified as a json
#' string
#'
#' @export
#'
#' @param input Input list, data.frame, spatial class, or sf class. Inputs can
#' also be dplyr `tbl_df` class since it inherits from `data.frame`.
#' @param lat (character) Latitude name. The default is `NULL`, and we
#' attempt to guess.
#' @param lon (character) Longitude name. The default is `NULL`, and we
#' attempt to guess.
#' @param geometry (character) One of point (Default) or polygon.
#' @param type  (character) The type of collection. One of 'auto' (default
#' for 'sf' objects), 'FeatureCollection' (default for everything else), or
#' 'GeometryCollection'. "skip" skips the coercion with package \pkg{geojson}
#' functions; skipping can save significant run time on larger geojson
#' objects. `Spatial` objects can only accept "FeatureCollection" or "skip".
#' "skip" is not available as an option for `numeric`, `list`,
#' and `data.frame` classes
#' @param group (character) A grouping variable to perform grouping for
#' polygons - doesn't apply for points
#' @param convert_wgs84 Should the input be converted to the
#' standard CRS system for GeoJSON (https://tools.ietf.org/html/rfc7946)
#' (geographic coordinate reference system, using
#' the WGS84 datum, with longitude and latitude units of decimal degrees;
#' EPSG: 4326). Default is `FALSE` though this may change in a future
#' package version. This will only work for `sf` or `Spatial`
#' objects with a CRS already defined. If one is not defined but you know
#' what it is, you may define it in the `crs` argument below.
#' @param crs The CRS of the input if it is not already defined. This can be
#' an epsg code as a four or five digit integer or a valid proj4 string.
#' This argument will be ignored if `convert_wgs84` is `FALSE` or
#' the object already has a CRS.
#' @param precision (integer) desired number of decimal places for coordinates.
#' Using fewer decimal places decreases object sizes (at the
#' cost of precision). This changes the underlying precision stored in the
#' data. `options(digits = <some number>)` changes the maximum number of
#' digits displayed (to find out what yours is set at see
#' `getOption("digits")`); the value of this parameter will change what's
#' displayed in your console up to the value of `getOption("digits")`.
#' See Precision section for more.
#' @param ... Further args passed on to internal functions. For Spatial*
#' classes, it is passed through to
#' [sf::st_write()]. For sf classes, data.frames, lists, numerics,
#' and geo_lists, it is passed through to [jsonlite::toJSON()]
#'
#' @return An object of class `geo_json` (and `json`)
#'
#' @details This function creates a geojson structure as a json character
#' string; it does not write a file - see [geojson_write()] for that
#'
#' Note that all sp class objects will output as `FeatureCollection`
#' objects, while other classes (numeric, list, data.frame) can be output as
#' `FeatureCollection` or `GeometryCollection` objects. We're working
#' on allowing `GeometryCollection` option for sp class objects.
#'
#' Also note that with sp classes we do make a round-trip, using
#' [sf::st_write()] to write GeoJSON to disk, then read it back
#' in. This is fast and we don't have to think about it too much, but this
#' disk round-trip is not ideal.
#'
#' For sf classes (sf, sfc, sfg), the following conversions are made:
#'
#' - sfg: the appropriate geometry `Point, LineString, Polygon,
#'  MultiPoint, MultiLineString, MultiPolygon, GeometryCollection`
#' - sfc: `GeometryCollection`, unless the sfc is length 1, then
#'  the geometry as above
#' - sf: `FeatureCollection`
#'
#' @section Precision:
#' Precision is handled in different ways depending on the class.
#'
#' The `digits` parameter of `jsonlite::toJSON` controls precision for classes
#' `numeric`, `list`, `data.frame`, and `geo_list`.
#'
#' For `sp` classes, precision is controlled by `sf::st_write`, being passed
#' down through [geojson_write()], then through internal function
#' `write_geojson()`, then another internal function `write_ogr_sf()`
#'
#' For `sf` classes, precision isn't quite working yet.
#'
#' @examples \dontrun{
#' # From a numeric vector of length 2, making a point type
#' geojson_json(c(-99.74134244, 32.451323223))
#' geojson_json(c(-99.74134244, 32.451323223))[[1]]
#' geojson_json(c(-99.74134244, 32.451323223), precision = 2)[[1]]
#' geojson_json(c(-99.74, 32.45), type = "GeometryCollection")
#'
#' ## polygon type
#' ### this requires numeric class input, so inputting a list will dispatch
#' ### on the list method
#' poly <- c(
#'   c(-114.345703125, 39.436192999314095),
#'   c(-114.345703125, 43.45291889355468),
#'   c(-106.61132812499999, 43.45291889355468),
#'   c(-106.61132812499999, 39.436192999314095),
#'   c(-114.345703125, 39.436192999314095)
#' )
#' geojson_json(poly, geometry = "polygon")
#'
#' # Lists
#' ## From a list of numeric vectors to a polygon
#' vecs <- list(
#'   c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0),
#'   c(100.0, 0.0)
#' )
#' geojson_json(vecs, geometry = "polygon")
#'
#' ## from a named list
#' mylist <- list(
#'   list(latitude = 30, longitude = 120, marker = "red"),
#'   list(latitude = 30, longitude = 130, marker = "blue")
#' )
#' geojson_json(mylist, lat = "latitude", lon = "longitude")
#'
#' # From a data.frame to points
#' geojson_json(us_cities[1:2, ], lat = "lat", lon = "long")
#' geojson_json(us_cities[1:2, ],
#'   lat = "lat", lon = "long",
#'   type = "GeometryCollection"
#' )
#'
#' # from data.frame to polygons
#' head(states)
#' ## make list for input to e.g., rMaps
#' geojson_json(states[1:351, ],
#'   lat = "lat", lon = "long", geometry = "polygon",
#'   group = "group"
#' )
#'
#' # from a geo_list
#' a <- geojson_list(us_cities[1:2, ], lat = "lat", lon = "long")
#' geojson_json(a)
#'
#' # sp classes
#'
#' ## From SpatialPolygons class
#' library("sp")
#' poly1 <- Polygons(list(Polygon(cbind(
#'   c(-100, -90, -85, -100),
#'   c(40, 50, 45, 40)
#' ))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(
#'   c(-90, -80, -75, -90),
#'   c(30, 40, 35, 30)
#' ))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' geojson_json(sp_poly)
#'
#' ## data.frame to geojson
#' geojson_write(us_cities[1:2, ], lat = "lat", lon = "long") %>% as.json()
#'
#' # From SpatialPoints class
#' x <- c(1, 2, 3, 4, 5)
#' y <- c(3, 2, 5, 1, 4)
#' s <- SpatialPoints(cbind(x, y))
#' geojson_json(s)
#'
#' ## From SpatialPointsDataFrame class
#' s <- SpatialPointsDataFrame(cbind(x, y), mtcars[1:5, ])
#' geojson_json(s)
#'
#' ## From SpatialLines class
#' library("sp")
#' c1 <- cbind(c(1, 2, 3), c(3, 2, 2))
#' c2 <- cbind(c1[, 1] + .05, c1[, 2] + .05)
#' c3 <- cbind(c(1, 2, 3), c(1, 1.5, 1))
#' L1 <- Line(c1)
#' L2 <- Line(c2)
#' L3 <- Line(c3)
#' Ls1 <- Lines(list(L1), ID = "a")
#' Ls2 <- Lines(list(L2, L3), ID = "b")
#' sl1 <- SpatialLines(list(Ls1))
#' sl12 <- SpatialLines(list(Ls1, Ls2))
#' geojson_json(sl1)
#' geojson_json(sl12)
#'
#' ## From SpatialLinesDataFrame class
#' dat <- data.frame(
#'   X = c("Blue", "Green"),
#'   Y = c("Train", "Plane"),
#'   Z = c("Road", "River"), row.names = c("a", "b")
#' )
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' geojson_json(sldf)
#' geojson_json(sldf)
#'
#' ## From SpatialGrid
#' x <- GridTopology(c(0, 0), c(1, 1), c(5, 5))
#' y <- SpatialGrid(x)
#' geojson_json(y)
#'
#' ## From SpatialGridDataFrame
#' sgdim <- c(3, 4)
#' sg <- SpatialGrid(GridTopology(rep(0, 2), rep(10, 2), sgdim))
#' sgdf <- SpatialGridDataFrame(sg, data.frame(val = 1:12))
#' geojson_json(sgdf)
#'
#' # From SpatialPixels
#' library("sp")
#' pixels <- suppressWarnings(
#'   SpatialPixels(SpatialPoints(us_cities[c("long", "lat")]))
#' )
#' summary(pixels)
#' geojson_json(pixels)
#'
#' # From SpatialPixelsDataFrame
#' library("sp")
#' pixelsdf <- suppressWarnings(
#'   SpatialPixelsDataFrame(
#'     points = canada_cities[c("long", "lat")],
#'     data = canada_cities
#'   )
#' )
#' geojson_json(pixelsdf)
#'
#' # From sf classes:
#' if (require(sf)) {
#'   ## sfg (a single simple features geometry)
#'   p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
#'   poly <- rbind(c(1, 1), c(1, 2), c(2, 2), c(1, 1))
#'   poly_sfg <- st_polygon(list(p1))
#'   geojson_json(poly_sfg)
#'
#'   ## sfc (a collection of geometries)
#'   p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
#'   p2 <- rbind(c(5, 5), c(5, 6), c(4, 5), c(5, 5))
#'   poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
#'   geojson_json(poly_sfc)
#'
#'   ## sf (collection of geometries with attributes)
#'   p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
#'   p2 <- rbind(c(5, 5), c(5, 6), c(4, 5), c(5, 5))
#'   poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
#'   poly_sf <- st_sf(foo = c("a", "b"), bar = 1:2, poly_sfc)
#'   geojson_json(poly_sf)
#' }
#'
#' ## Pretty print a json string
#' geojson_json(c(-99.74, 32.45))
#' geojson_json(c(-99.74, 32.45)) %>% pretty()
#'
#' # skipping the pretty geojson class coercion with the geojson pkg
#' if (require(sf)) {
#'   library(sf)
#'   p1 <- rbind(c(0, 0), c(1, 0), c(3, 2), c(2, 4), c(1, 4), c(0, 0))
#'   p2 <- rbind(c(5, 5), c(5, 6), c(4, 5), c(5, 5))
#'   poly_sfc <- st_sfc(st_polygon(list(p1)), st_polygon(list(p2)))
#'   geojson_json(poly_sfc)
#'   geojson_json(poly_sfc, type = "skip")
#' }
#' }
geojson_json <- function(input, lat = NULL, lon = NULL, group = NULL,
                         geometry = "point", type = "FeatureCollection",
                         convert_wgs84 = FALSE, crs = NULL,
                         precision = NULL, ...) {
  UseMethod("geojson_json")
}

# spatial classes from sp --------------------------
#' @export
geojson_json.SpatialPolygons <- function(input, lat = NULL, lon = NULL,
                                         group = NULL, geometry = "point", type = "FeatureCollection",
                                         convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type_sp(type)
  geoclass(geojson_rw(input,
    target = "char", convert_wgs84 = convert_wgs84,
    crs = crs, precision = precision
  ), type = type)
}

#' @export
geojson_json.SpatialPolygonsDataFrame <- function(input, lat = NULL, lon = NULL,
                                                  group = NULL, geometry = "point", type = "FeatureCollection",
                                                  convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type_sp(type)
  geoclass(geojson_rw(input,
    target = "char", convert_wgs84 = convert_wgs84,
    crs = crs, precision = precision
  ), type = type)
}

#' @export
geojson_json.SpatialPoints <- function(input, lat = NULL, lon = NULL,
                                       group = NULL, geometry = "point", type = "FeatureCollection",
                                       convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type_sp(type)
  dat <- SpatialPointsDataFrame(input, data.frame(dat = 1:NROW(input@coords)))
  geoclass(geojson_rw(dat,
    target = "char", convert_wgs84 = convert_wgs84,
    crs = crs, precision = precision
  ), type = type)
}

#' @export
geojson_json.SpatialPointsDataFrame <- function(input, lat = NULL, lon = NULL,
                                                group = NULL, geometry = "point", type = "FeatureCollection",
                                                convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type_sp(type)
  geoclass(geojson_rw(input,
    target = "char", convert_wgs84 = convert_wgs84,
    crs = crs, precision = precision
  ), type = type)
}

#' @export
geojson_json.SpatialLines <- function(input, lat = NULL, lon = NULL,
                                      group = NULL, geometry = "point", type = "FeatureCollection",
                                      convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type_sp(type)
  geoclass(geojson_rw(input,
    target = "char", convert_wgs84 = convert_wgs84,
    crs = crs, precision = precision
  ), type = type)
}

#' @export
geojson_json.SpatialLinesDataFrame <- function(input, lat = NULL, lon = NULL,
                                               group = NULL, geometry = "point", type = "FeatureCollection",
                                               convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type_sp(type)
  geoclass(geojson_rw(input,
    target = "char", convert_wgs84 = convert_wgs84,
    crs = crs, precision = precision
  ), type = type)
}

#' @export
geojson_json.SpatialGrid <- function(input, lat = NULL, lon = NULL,
                                     group = NULL, geometry = "point", type = "FeatureCollection",
                                     convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type_sp(type)
  geoclass(geojson_rw(input,
    target = "char", convert_wgs84 = convert_wgs84,
    crs = crs, precision = precision
  ), type = type)
}

#' @export
geojson_json.SpatialGridDataFrame <- function(input, lat = NULL, lon = NULL,
                                              group = NULL, geometry = "point",
                                              type = "FeatureCollection",
                                              convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type_sp(type)
  geoclass(geojson_rw(input,
    target = "char", convert_wgs84 = convert_wgs84,
    crs = crs, precision = precision
  ), type = type)
}

#' @export
geojson_json.SpatialPixels <- function(input, lat = NULL, lon = NULL,
                                       group = NULL, geometry = "point", type = "FeatureCollection",
                                       convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type_sp(type)
  geoclass(geojson_rw(input,
    target = "char", convert_wgs84 = convert_wgs84,
    crs = crs, precision = precision
  ), type = type)
}

#' @export
geojson_json.SpatialPixelsDataFrame <- function(input, lat = NULL, lon = NULL,
                                                group = NULL, geometry = "point", type = "FeatureCollection",
                                                convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type_sp(type)
  geoclass(geojson_rw(input,
    target = "char", convert_wgs84 = convert_wgs84,
    crs = crs, precision = precision
  ), type = type)
}

# sf classes ---------------------------------

#' @export
geojson_json.sf <- function(input, lat = NULL, lon = NULL, group = NULL,
                            geometry = "point", type = "auto", convert_wgs84 = FALSE, crs = NULL,
                            precision = NULL, ...) {
  geoclass(
    as.json(geojson_list(input,
      convert_wgs84 = convert_wgs84, crs = crs,
      precision = precision
    ), ...), type
  )
}

#' @export
geojson_json.sfc <- function(input, lat = NULL, lon = NULL, group = NULL,
                             geometry = "point", type = "auto",
                             convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  geoclass(
    as.json(geojson_list(input,
      convert_wgs84 = convert_wgs84,
      crs = crs, precision = precision
    ), ...), type
  )
}

#' @export
geojson_json.sfg <- function(input, lat = NULL, lon = NULL, group = NULL,
                             geometry = "point", type = "auto",
                             convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  geoclass(as.json(geojson_list(input, precision = precision), ...), type)
}

# regular R classes --------------------------
#' @export
geojson_json.numeric <- function(input, lat = NULL, lon = NULL, group = NULL,
                                 geometry = "point", type = "FeatureCollection",
                                 convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type(type)
  geoclass(
    to_json(num_to_geo_list(input, geometry, type), precision, ...),
    type
  )
}

#' @export
geojson_json.data.frame <- function(input, lat = NULL, lon = NULL, group = NULL,
                                    geometry = "point", type = "FeatureCollection",
                                    convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type(type)
  tmp <- guess_latlon(names(input), lat, lon)
  res <- df_to_geo_list(input, tmp$lat, tmp$lon, geometry, type, group)
  geoclass(to_json(res, precision, ...), type)
}

#' @export
geojson_json.list <- function(input, lat = NULL, lon = NULL, group = NULL,
                              geometry = "point", type = "FeatureCollection",
                              convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  check_type(type)
  if (geometry == "polygon") lint_polygon_list(input)
  tmp <- if (!is.named(input)) {
    list(lon = NULL, lat = NULL)
  } else {
    guess_latlon(names(input[[1]]), lat, lon)
  }
  res <- list_to_geo_list(input, tmp$lat, tmp$lon, geometry, type,
    unnamed = !is.named(input), group
  )
  geoclass(to_json(res, precision, ...), type)
}

#' @export
geojson_json.geo_list <- function(input, lat = NULL, lon = NULL, group = NULL,
                                  geometry = "point", type = "FeatureCollection",
                                  convert_wgs84 = FALSE, crs = NULL, precision = NULL, ...) {
  geoclass(to_json(input, precision, ...), type)
}

check_type_sp <- function(x) {
  types <- c("FeatureCollection", "skip")
  if (!x %in% types) {
    stop(
      "'type' must be one of: ",
      paste0(types, collapse = ", ")
    )
  }
}
