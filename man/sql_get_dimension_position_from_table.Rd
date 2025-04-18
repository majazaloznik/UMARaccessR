% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_stuff.R
\name{sql_get_dimension_position_from_table}
\alias{sql_get_dimension_position_from_table}
\title{Get dimension position in table}
\usage{
sql_get_dimension_position_from_table(
  table_id,
  dimension_name,
  con,
  schema = "platform"
)
}
\arguments{
\item{table_id}{Integer table identifier}

\item{dimension_name}{Character string dimension name}

\item{con}{Database connection object}

\item{schema}{Character string specifying the database schema}
}
\value{
Integer position or NA if dimension not found
}
\description{
Returns the position of a non-time dimension in the ordered list of dimensions
for a given table.
}
