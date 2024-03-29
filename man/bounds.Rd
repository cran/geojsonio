% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bounds.R
\name{bounds}
\alias{bounds}
\title{Get bounds for a list or geo_list}
\usage{
bounds(x, ...)
}
\arguments{
\item{x}{An object of class list or geo_list}

\item{...}{Ignored}
}
\value{
A vector of the form min longitude, min latitude, max longitude,
max latitude
}
\description{
Get bounds for a list or geo_list
}
\examples{
# numeric
vec <- c(-99.74, 32.45)
x <- geojson_list(vec)
bounds(x)

# list
mylist <- list(
  list(latitude = 30, longitude = 120, marker = "red"),
  list(latitude = 30, longitude = 130, marker = "blue")
)
x <- geojson_list(mylist)
bounds(x)

# data.frame
x <- geojson_list(states[1:20, ])
bounds(x)
}
