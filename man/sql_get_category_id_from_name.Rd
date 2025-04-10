% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_stuff.R
\name{sql_get_category_id_from_name}
\alias{sql_get_category_id_from_name}
\title{Get category ID from category name}
\usage{
sql_get_category_id_from_name(
  category_name,
  con,
  source_id = 1,
  schema = "platform"
)
}
\arguments{
\item{category_name}{Character string with category name}

\item{con}{Database connection object}

\item{source_id}{Integer source identifier (optional, defaults to 1 for SURS)}

\item{schema}{Character string specifying the database schema}
}
\value{
Integer category ID or NULL if not found
}
\description{
Get category ID from category name
}
