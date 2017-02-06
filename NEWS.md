gejsonio 0.3.2
==============

### BUG FIXES

* Fix to tests for internal fxn `convert_wgs84` to do minimal test of 
output, and to conditionally test only if `sf` is available (#103)


gejsonio 0.3.0
==============

### NEW FEATURES

* `geojson_json`, `geojson_list`, and `geojson_write` gain new S3 methods: 
`sf`, `sfc`, and `sfg` - the three classes in the `sf` package (#95)
* `geojson_json`, `geojson_list`, and `geojson_write` gain two new 
parameters each: `convert_wgs84` (boolean) to convert to WGS84 or not (the 
projection assumed for GeoJSON)  and `crs` to assign a CRS if known 
(#101) (#102)

### MINOR IMPROVEMENTS

* `geojson_json()` for non-sp classes now only keeps seven decimal places 
in the coordinates. This follows the default that GDAL uses.
* Now namespacing base package calls for `methods`/`stats`/`utils`
instead of importing them
* Improved documentation for `method` parameter in `geojson_read`
clarifying what the options are for (#93) thanks @bhaskarvk
* Internal fxn `to_json` now defaults to 7 digits, which is used in 
`as.json` and `geojson_json` (#96)

### BUG FIXES

* Fix to `geojson_read` to read correctly from a URL - in addition
to file paths (#91) (#92) thanks @lecy
* Fix to `geojson_read` to read non-`.geojson` extensions (#93)
thanks @bhaskarvk


geojsonio 0.2.0
===============

### MINOR IMPROVEMENTS

* Major performance improvement for `geojson_json()` - moved to 
reading in json with `readr::read_file()` (#85) thanks @javrucebo !
* Now requiring explicit versions of some package dependencies
* Removed the startup message

### BUG FIXES

* Changed `file_to_geojson()` to use `httr::write_disk()` instead of 
`download.file()` (#83) thanks @patperu

### DEPRECATED AND DEFUNCT

* The two linting functions in this package, `lint()` and `validate()`
are now deprecated, and will be defunct in the next version of this 
package. See the new package `geojsonlint` on CRAN for linting 
geojson functionality (#82)

geojsonio 0.1.8
===============

### NEW FEATURES

* New method `geojson_sp.json()` added to `geojson_sp()` to handle json
class inputs

### MINOR IMPROVEMENTS

* Added `encodin="UTF-8"` to `httr::content()` calls

### BUG FIXES

* `geojson_write()` didn't overwrite existing files despite saying so.
New parameter added to the function `overwrite` to specify whether to
overwrite a function or not, which defaults to `TRUE` (#81)
thanks @Robinlovelace !

geojsonio 0.1.6
===============

### NEW FEATURES

* New function `geojson_sp()` to convert output of `geojson_list()` or
`geojson_json()` to spatial classes (e.g., `SpatialPointsDataFrame`) (#71)

### MINOR IMPROVEMENTS

* Startup message added to notify users to ideally update to `rgdal > v1.1-1`
given fix to make writing multipolygon objects to geojson correct (#69)
* Filled out test suite more (#46)

### BUG FIXES

* Fix to `lint()` function, due to bug in passing data to the Javascript
layer (#73)
* Fixes to `as.json()` (#76)

geojsonio 0.1.4
===============

### NEW FEATURES

* New function `map_leaf()` uses the `leaflet` package to make maps, with
S3 methods for most spatial classes as well as most R classes, including
data.frame's, lists, vectors, file inputs, and more (#48)
* `geojson_read()` now optionally can give back a spatial class object,
just a convenience in case you want to not get back geojson, but a
spatial class (#60)

### MINOR IMPROVEMENTS

* Now that `leaflet` R package is on CRAN, put back in examples using
it to make maps (#49)
* Added a linter for list inputs comined with `geometry="polygon"` to
all `geojson_*()` functions that have `.list` methods. This checks to
make sure inputs have the same first and last coordinate pairs to
close the polygon (#34)

### BUG FIXES

* Importing all non-base R funtions, including from `methods`, `stats` and `utils`
packages (#62)
* Fixed bug in `geojson_write()` in which geojson style names were altered
on accident (#56)

geojsonio 0.1.0
===============

### NEW FEATURES

* released to CRAN
