% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_stuff.R
\name{sql_get_data_points_from_vintage}
\alias{sql_get_data_points_from_vintage}
\title{Get data points from vintage ID}
\usage{
sql_get_data_points_from_vintage(con, vintage_id, schema = "platform")
}
\arguments{
\item{con}{Database connection object}

\item{vintage_id}{Integer vintage identifier}

\item{schema}{Character string specifying the database schema}
}
\value{
A data frame with period_id and value columns, ordered by period_id
}
\description{
Get data points from vintage ID
}
