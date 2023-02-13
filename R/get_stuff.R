#' Get unit name from vintage id
#'
#' Joins vintage and series tables to get the id of the unit,
#' which is looked up in the unit table to get its name.
#'
#' @inheritParams common_parameters
#'
#' @return character vector of unit name.
#' @export
get_unit_from_vintage <- function(vintage, con) {
DBI::dbGetQuery(con, sprintf(
  "select name from unit where id =
  (select series.unit_id from vintage
  left join series
  on vintage.series_id=series.id
  where vintage.id = %f)", vintage)) -> unit
  if (identical(unit, character(0))) unit <- NULL
  return(unit[1,1])
}

#' Get unit name from series id
#'
#' Joins vintage and series tables to get the id of the unit,
#' which is looked up in the unit table to get its name.
#'
#' @inheritParams common_parameters
#'
#' @return character vector of unit name.
#' @export
get_unit_from_series <- function(series, con) {
  DBI::dbGetQuery(con, sprintf(
    "select name from unit where id =
  (select unit_id from series
  where id = %f)", series)) -> unit
  if (identical(unit, character(0))) unit <- NULL
  return(unit[1,1])
}

#' Get series name from vintage ID
#'
#' Joins vintage table with series to get the series name_long.
#'
#' @inheritParams common_parameters
#'
#' @return character vector of series name.
#' @export

get_series_name_from_vintage <- function(vintage, con) {
  DBI::dbGetQuery(con, sprintf(
    "select name_long from vintage
    left join series
    on vintage.series_id=series.id
    where vintage.id = %f", vintage))
}

#' Get series name from series ID
#'
#' Get the series name_long.
#'
#' @inheritParams common_parameters
#'
#' @return character vector of series name.
#' @export

get_series_name_from_series <- function(series, con) {
  DBI::dbGetQuery(con, sprintf(
    "select name_long from series
    where id = %f", series))
}

#' Get table name from vintage ID
#'
#' Joins the vintage table with the series table to get the
#' table id and then looks up the name in the table table.
#'
#'
#' @inheritParams common_parameters
#'
#' @return character vector of table name.
#' @export
#'
get_table_name_from_vintage <- function(vintage, con) {
  DBI::dbGetQuery(con, sprintf(
    "select name from \"table\" where id =
    (select series.table_id from vintage
     left join series
     on vintage.series_id=series.id
     where vintage.id = %f)", vintage))
}

#' Get table name from series ID
#'
#' Lookup the table name from the series ID#'
#'
#' @inheritParams common_parameters
#'
#' @return character vector of table name.
#' @export
#'
get_table_name_from_series <- function(series, con) {
  DBI::dbGetQuery(con, sprintf(
    "select name from \"table\" where id =
    (select table_id from series
     where id = %f)", series))
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
get_interval_from_vintage <- function(vintage, con) {
  DBI::dbGetQuery(con, sprintf(
    "select interval_id from series where id =
    (select series.id from vintage
     left join series
     on vintage.series_id=series.id
     where vintage.id = %f)", vintage)) -> interval
  return(interval[1,1])
}


#' Get table interval from series ID
#'
#' Get the interval id from the series table, which is alphanumeric e.g. M for monthly etc.
#'
#'
#' @inheritParams common_parameters
#'
#' @return character vector of interval id
#' @export
#'
#'
get_interval_from_series <- function(series, con) {
  DBI::dbGetQuery(con, sprintf(
    "select interval_id from series
    where id  = %f", series)) -> interval
  return(interval[1,1])
}


#' Get vintage id from series id
#'
#' Gets the vintage based on the series ID, by default the most recent one,
#' otherwise the one that was valid on the date passed with `date_valid`.
#'
#' @inheritParams common_parameters
#' @param date_valid date when the vintage was valid if none is given most recent
#' i.e. currently valid vintage is returned.
#'
#' @return numeric vintage id.
#' @export
#'
get_vintage_from_series <- function(series, con, date_valid = NULL){
  if(!is.null(date_valid)){
   validity <- sprintf("and published < '%s'", date_valid )} else {
     validity <- " "}
   DBI::dbGetQuery(con, sprintf(
     "select id from vintage
    where series_id  = %f %s
    order by published desc limit 1", series, validity))
}

#' Get vintage id from series code
#'
#' Gets the vintage based on the series code, by default the most recent one,
#' otherwise the one that was valid on the date passed with `date_valid`.
#'
#' @inheritParams common_parameters
#' @param series_code the characther code for each series (not the id)
#' @param date_valid date when the vintage was valid if none is given most recent
#' i.e. currently valid vintage is returned.
#'
#' @return numeric vintage id.
#' @export
#'
get_vintage_from_series_code <- function(series_code, con, date_valid = NULL){
  if(!is.null(date_valid)){
    validity <- sprintf("and published < '%s'", date_valid )} else {
      validity <- " "}
  DBI::dbGetQuery(con, sprintf(
    "select vintage.id from vintage join series
on vintage.series_id = series.id
where series.code = '%s' %s
order by published desc limit 1", series_code, validity))
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
#' @importFrom rlang .data

get_data_points_from_vintage <- function(vintage, con){
  DBI::dbGetQuery(con, sprintf(
    "select period_id, value from data_points where vintage_id = %f", vintage)) %>%
    dplyr::arrange(.data$period_id)
}


#' Get the publication date from the vintage id
#'
#' Just does that.
#'
#' @inheritParams common_parameters
#'
#' @return positx.ct value with tz
#' @export
#' @importFrom rlang .data
get_date_published_from_vintage <- function(vintage, con){
  DBI::dbGetQuery(con, sprintf(
    "select published from vintage where id = %f", vintage)) %>%
    lubridate::with_tz( "CET")
}

#' Get the most recent period for whic a vintage has data
#'
#' The vintage must have an actual non null value for that period.
#'
#' @inheritParams common_parameters
#'
#' @return character of period id e.g "2022M03"
#' @export
get_last_period_from_vintage <- function(vintage, con){
  DBI::dbGetQuery(con, sprintf(
    "select period_id from data_points where vintage_id = %f and value is not null
    order by period_id desc limit 1", vintage))
}


#' Get all series in the database
#'
#' Extracts a dataframe with all the series in the database joined together
#' with their table names and units. Used in \link[UMARaccessR]{create_selection_excel}. Cannae be
#' bothered with testing.
#'
#' @inheritParams common_parameters
#'
#' @return dataframe with a row for each series
#' @export
#'
get_all_series_wtable_names <- function(con){
  dplyr::tbl( con, "series") %>%
    dplyr::left_join(tbl( con, "table"), by = c("table_id"= "id")) %>%
    dplyr::select(-url, -source_id, -description, -notes) %>%
    dplyr::left_join(tbl(con, "unit"), by = c("unit_id"="id")) %>%
    dplyr::rename(unit = name.y,
           table_code = code.y,
           series_code = code.x,
           table_name = name.x,
           series_name = name_long) %>%
    dplyr::select(table_code, table_name,
           series_code, series_name,
           unit, interval_id) %>%
    dplyr::arrange(table_code, series_code) %>%
    dplyr::collect() -> series_df
}

#' Get source code from source name
#'
#'
#' @inheritParams common_parameters
#' @param name character string with source name
#'
#' @return numeric code
#' @export
get_source_code_from_source_name <- function(name, con){
  DBI::dbGetQuery(con, sprintf(
    "select id from source where name = '%s'", name))
}


#' Get table id from table code
#'
#'
#' @inheritParams common_parameters
#' @param code character string with source name
#'
#' @return numeric code
#' @export
get_table_id_from_table_code <- function(code, con){
  DBI::dbGetQuery(con, sprintf(
    "select id from \"table\" where code = '%s'", code))
}
