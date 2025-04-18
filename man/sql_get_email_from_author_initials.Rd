% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_stuff.R
\name{sql_get_email_from_author_initials}
\alias{sql_get_email_from_author_initials}
\title{Get author email from author initials}
\usage{
sql_get_email_from_author_initials(initials, con, schema = "platform")
}
\arguments{
\item{initials}{Character string author initials}

\item{con}{Database connection object}

\item{schema}{Character string specifying the database schema}
}
\value{
Character string containing author email or NA if not found
}
\description{
Get author email from author initials
}
