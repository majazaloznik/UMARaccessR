% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_stuff.R
\name{sql_get_unit_id_from_unit_name}
\alias{sql_get_unit_id_from_unit_name}
\title{Get unit ID from unit name}
\usage{
sql_get_unit_id_from_unit_name(unit_name, con, schema = "platform")
}
\arguments{
\item{unit_name}{Character string with unit name}

\item{con}{Database connection object}

\item{schema}{Character string specifying the database schema}
}
\value{
Integer unit ID or NA if not found
}
\description{
Get unit ID from unit name
}
