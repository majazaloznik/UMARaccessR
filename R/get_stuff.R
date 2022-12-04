
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
  where vintage.id = %f)", vintage)) -> unit
  if (identical(unit, character(0))) unit <- NULL
  return(unit[1,1])
}

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

#' Get table interval from vintage ID
#'
#' Joins the vintage table with the series table to get the
#' interval id, which is alphanumeric e.g. M for monthly etc.
#'
#'
#' @inheritParams common_parameters
#' @param vintage numeric id of vintage
#'
#' @return character vector of interval id
#' @export
#'
#'
get_interval <- function(vintage, con) {
  DBI::dbGetQuery(con, sprintf(
    "select interval_id from series where id =
    (select series.id from vintage
     left join series
     on vintage.series_id=series.id
     where vintage.id = %f)", vintage)) -> interval
  return(interval[1,1])
}

#' Get and prep the datapoint table for a single vintage
#'
#' Gets the data periods and values for a single vintage.
#'
#' @inheritParams common_parameters
#' @param vintage numeric id of vintage
#'
#' @return a two column dataframe with the period_id, and value for all
#' the datapoints in that vintage.
#' @export
#'
get_data_points <- function(vintage, con){
  dbGetQuery(con, sprintf(
    "select period_id, value from data_points where vintage_id = %f", vintage)) %>%
<<<<<<< HEAD
    dplyr::arrange(period_id)
=======
    dplyr::arrange(period)
>>>>>>> b0da2e94a4fae7ec1c87a06d08a46396d78152f3
}
