## ----echo=FALSE----------------------------------------------------------
library("knitr")
hook_output <- knitr::knit_hooks$get("output")
knitr::knit_hooks$set(output = function(x, options) {
   lines <- options$output.lines
   if (is.null(lines)) {
     return(hook_output(x, options))  # pass to default hook
   }
   x <- unlist(strsplit(x, "\n"))
   more <- "..."
   if (length(lines)==1) {        # first n lines
     if (length(x) > lines) {
       # truncate the output, but add ....
       x <- c(head(x, lines), more)
     }
   } else {
     x <- c(if (abs(lines[1])>1) more else NULL,
            x[lines],
            if (length(x)>lines[abs(length(lines))]) more else NULL
           )
   }
   # paste these lines together
   x <- paste(c(x, ""), collapse = "\n")
   hook_output(x, options)
 })

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  warning = FALSE,
  message = FALSE
)

## ----eval=FALSE----------------------------------------------------------
#  install.packages("rgdal", type = "source", configure.args = "--with-gdal-config=/Library/Frameworks/GDAL.framework/Versions/1.11/unix/bin/gdal-config --with-proj-include=/Library/Frameworks/PROJ.framework/unix/include --with-proj-lib=/Library/Frameworks/PROJ.framework/unix/lib")
#  install.packages("rgeos", type = "source")

## ----eval=FALSE----------------------------------------------------------
#  install.packages("rgdal", type = "source")
#  install.packages("rgeos", type = "source")

## ----eval=FALSE----------------------------------------------------------
#  install.packages("geojsonio")

## ----eval=FALSE----------------------------------------------------------
#  devtools::install_github("ropensci/geojsonio")

## ------------------------------------------------------------------------
library("geojsonio")

## ------------------------------------------------------------------------
geojson_json(c(32.45, -99.74))

## ----output.lines=1:10---------------------------------------------------
geojson_list(c(32.45, -99.74))

## ------------------------------------------------------------------------
geojson_json(us_cities[1:2, ], lat = 'lat', lon = 'long')

## ----output.lines=1:10---------------------------------------------------
geojson_list(us_cities[1:2, ], lat = 'lat', lon = 'long')

## ------------------------------------------------------------------------
library('sp')
poly1 <- Polygons(list(Polygon(cbind(c(-100, -90, -85, -100),
  c(40, 50, 45, 40)))), "1")
poly2 <- Polygons(list(Polygon(cbind(c(-90, -80, -75, -90),
  c(30, 40, 35, 30)))), "2")
sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)

## ------------------------------------------------------------------------
geojson_json(sp_poly)

## ----output.lines=1:10---------------------------------------------------
geojson_list(sp_poly)

## ------------------------------------------------------------------------
x <- c(1, 2, 3, 4, 5)
y <- c(3, 2, 5, 1, 4)
s <- SpatialPoints(cbind(x, y))

## ------------------------------------------------------------------------
geojson_json(s)

## ----output.lines=1:10---------------------------------------------------
geojson_list(s)

## ----output.lines=1:10---------------------------------------------------
vec <- c(-99.74, 32.45)
a <- geojson_list(vec)
vecs <- list(c(100.0, 0.0), c(101.0, 0.0), c(100.0, 0.0))
b <- geojson_list(vecs, geometry = "polygon")
a + b

## ------------------------------------------------------------------------
c <- geojson_json(c(-99.74, 32.45))
vecs <- list(c(100.0, 0.0), c(101.0, 0.0), c(101.0, 1.0), c(100.0, 1.0), c(100.0, 0.0))
d <- geojson_json(vecs, geometry = "polygon")
c + d

## ------------------------------------------------------------------------
geojson_write(us_cities[1:2, ], lat = 'lat', lon = 'long')

## ----eval=FALSE----------------------------------------------------------
#  file <- system.file("examples", "us_states.topojson", package = "geojsonio")
#  out <- geojson_read(file)

## ----eval=FALSE----------------------------------------------------------
#  url <- "https://raw.githubusercontent.com/shawnbot/d3-cartogram/master/data/us-states.topojson"
#  out <- topojson_read(url)

## ----eval=FALSE----------------------------------------------------------
#  (loc <- as.location(file))
#  out <- topojson_read(loc)

