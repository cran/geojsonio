% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geo_topo.R
\name{geo2topo}
\alias{geo2topo}
\alias{topo2geo}
\title{GeoJSON to TopoJSON and back}
\usage{
geo2topo(x, object_name = "foo", quantization = 0, ...)

topo2geo(x, ...)
}
\arguments{
\item{x}{GeoJSON or TopoJSON as a character string, json, a file path, or
url}

\item{object_name}{(character) name to give to the TopoJSON object created.
Default: "foo"}

\item{quantization}{(numeric) quantization parameter, use this to
quantize geometry prior to computing topology. Typical values are powers of
ten (\code{1e4}, \code{1e5}, ...), default is \code{0} to not perform quantization.
For more information about quantization, see this by Mike Bostock
https://stackoverflow.com/questions/18900022/topojson-quantization-vs-simplification/18921214#18921214}

\item{...}{for \code{geo2topo} args passed  on to
\code{\link[jsonlite:fromJSON]{jsonlite::fromJSON()}}, and for \code{topo2geo} args passed  on to
\code{\link[sf:st_read]{sf::st_read()}}}
}
\value{
An object of class \code{json}, of either GeoJSON or TopoJSON
}
\description{
GeoJSON to TopoJSON and back
}
\examples{
# geojson to topojson
x <- '{"type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
z <- geo2topo(x)
jsonlite::prettify(z)
\dontrun{
library(leaflet)
leaflet() \%>\%
  addProviderTiles(provider = "Stamen.Terrain") \%>\%
  addTopoJSON(z)
}

# geojson to topojson as a list
x <- list(
  '{"type": "LineString", "coordinates": [ [100, 0], [101, 1] ]}',
  '{"type": "LineString", "coordinates": [ [110, 0], [110, 1] ]}',
  '{"type": "LineString", "coordinates": [ [120, 0], [121, 1] ]}'
)
geo2topo(x)

# change the object name created
x <- '{"type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
geo2topo(x, object_name = "HelloWorld")
geo2topo(x, object_name = "4")

x <- list(
  '{"type": "LineString", "coordinates": [ [100, 0], [101, 1] ]}',
  '{"type": "LineString", "coordinates": [ [110, 0], [110, 1] ]}',
  '{"type": "LineString", "coordinates": [ [120, 0], [121, 1] ]}'
)
geo2topo(x, "HelloWorld")
geo2topo(x, c("A", "B", "C"))


# topojson to geojson
w <- topo2geo(z)
jsonlite::prettify(w)

## larger examples
file <- system.file("examples", "us_states.topojson", package = "geojsonio")
topo2geo(file)
}
\seealso{
\code{\link[=topojson_write]{topojson_write()}}, \code{\link[=topojson_read]{topojson_read()}}
}
