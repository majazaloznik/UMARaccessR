% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_stuff.R
\name{get_source_code_from_source_name}
\alias{get_source_code_from_source_name}
\title{Get source code from source name}
\usage{
get_source_code_from_source_name(name, con)
}
\arguments{
\item{name}{character string with source name}

\item{con}{PostgreSQL connection object created by the RPostgres package.}
}
\value{
numeric code
}
\description{
Deprecated: Use `\link[UMARaccessR]{sql_get_source_code_from_source_name}` instead.
}
