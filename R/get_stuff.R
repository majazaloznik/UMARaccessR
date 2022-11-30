
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
#' Joins vintage table with series to get the series name_long.
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

#' Get table name from vintage ID
#'
#' Joins the vintage table with the series table to get the
#' table id and then looks up the name in the table table.
#'
#'
#' @inheritParams common_parameters
#' @param vintage numeric id of vintage
#'
#' @return character vector of table name.
#' @export
#'
get_table_name <- function(vintage, con) {
  DBI::dbGetQuery(con, sprintf(
    "select name from \"table\" where id =
    (select series.table_id from vintage
     left join series
     on vintage.series_id=series.id
     where vintage.id = %f)", vintage))
}


#' Get and prep the datapoint table for a single vintage
#'
#' Gets the data periods and values for a single vintage, converting the periods
#' to real dates for easier plotting.
#'
#' @inheritParams common_parameters
#' @param vintage numeric id of vintage
#'
#' @return a three column dataframe with the period_id, period as date and value for all
#' the datapoints in that vintage.
#' @export
#'
get_data_points <- function(vintage, con){
  dbGetQuery(con, sprintf(
    "select period_id, value from data_points where vintage_id = %f", vintage)) %>%
    dplyr::mutate(period = lubridate::ym(period_id)) %>%
    dplyr::arrange(period)
}
