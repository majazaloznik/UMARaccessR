% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_stuff.R
\name{sql_get_source_code_from_source_name}
\alias{sql_get_source_code_from_source_name}
\title{Get source ID from source name}
\usage{
sql_get_source_code_from_source_name(con, source_name, schema = "platform")
}
\arguments{
\item{con}{Database connection object}

\item{source_name}{Character string with source name}

\item{schema}{Character string specifying the database schema}
}
\value{
Integer source ID or NULL if not found
}
\description{
Get source ID from source name
}
