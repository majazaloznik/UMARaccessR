
#' Get unit name from vintage id
#'
#' Joins vintage and series tables to get the id of the unit,
#' which is looked up in the unit table to get its name.
#'
#' @inheritParams common_parameters
#' @param vintage numeric id of vintage
#'
#' @return character vector of vintage name.
#' @export

get_unit <- function(vintage, con) {
DBI::dbGetQuery(con, sprintf(
  "select name from unit where id =
  (select series.unit_id from vintage
  left join series
  on vintage.series_id=series.id
  where vintage.id = %f)", vintage))
}
source("tests/testthat/sandbox/SELECT-526b8c.R")$valu


#' Get series name from vintage ID
#'
#' @inheritParams common_parameters
#' @param vintage numeric id of vintage
#'
#' @return character vector of series name.
#' @export

get_series_name <- function(vintage, con) {
  DBI::dbGetQuery(con, sprintf(
    "select name_long from vintage
    left join series
    on vintage.series_id=series.id
    where vintage.id = %f", vintage))
}
