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

#' Get series name from series code
#'
#' Get the series name_long.
#'
#' @inheritParams common_parameters
#'
#' @return character vector of series name.
#' @export

get_series_name_from_series_code <- function(series, con) {
  DBI::dbGetQuery(con, sprintf(
    "select name_long from series
    where code = '%s'", series))
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
#' bothered with testing. Actually testing is not gonna work, cuz there are a bunch of multibyte chars.
#'
#' @inheritParams common_parameters
#'
#' @return dataframe with a row for each series
#' @export
#'
get_all_series_wtable_names <- function(con){
  DBI::dbGetQuery(con,
                  'SELECT
  "code.y" AS "table_code",
  "name.x" AS "table_name",
  "code.x" AS "series_code",
  "name_long" AS "series_name",
  "name.y" AS "unit",
  "interval_id"
FROM (
  SELECT
    "LHS"."id" AS "id",
    "table_id",
    "name_long",
    "unit_id",
    "code.x",
    "interval_id",
    "code.y",
    "LHS"."name" AS "name.x",
    "RHS"."name" AS "name.y"
  FROM (
    SELECT
      "id",
      "table_id",
      "name_long",
      "unit_id",
      "code.x",
      "interval_id",
      "code.y",
      "name"
    FROM (
      SELECT
        "LHS"."id" AS "id",
        "table_id",
        "name_long",
        "unit_id",
        "LHS"."code" AS "code.x",
        "interval_id",
        "RHS"."code" AS "code.y",
        "name",
        "source_id",
        "url",
        "description",
        "notes"
      FROM "series" AS "LHS"
      LEFT JOIN "table" AS "RHS"
        ON ("LHS"."table_id" = "RHS"."id")
    ) "q01"
  ) "LHS"
  LEFT JOIN "unit" AS "RHS"
    ON ("LHS"."unit_id" = "RHS"."id")
) "q02"
ORDER BY "table_code", "series_code"')
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
  x <- DBI::dbGetQuery(con, sprintf(
    "select id from \"table\" where code = '%s'", code))
  if(nrow(x) == 0) {NA} else {
  as.numeric(x[1,1])}
}

#' Get dimension id from table id and dimension name
#'
#' Deprecated in favour of \link[UMARaccessR]{get_tab_dim_id_from_table_id_and_dimension}.
#'
#' @inheritParams common_parameters
#' @param id numeric table id
#' @param dimension character string with dimension name
#'
#' @return numeric code
#' @export
get_dim_id_from_table_id <- function(id, dimension, con){
  .Deprecated("get_tab_dim_id_from_table_id_and_dimension")
  x <- DBI::dbGetQuery(con, sprintf(
    "select id from table_dimensions where table_id = %f and dimension = '%s'", id, dimension))
  if(nrow(x) == 0) {NA} else {
    as.numeric(x[1,1])}
}

#' Get dimension id from table id and dimension name
#'
#' Renamed version of `get_dim_id_from_table_id`.
#'
#' @inheritParams common_parameters
#' @param id numeric table id
#' @param dimension character string with dimension name
#'
#' @return numeric code
#' @export
get_tab_dim_id_from_table_id_and_dimension <- function(id, dimension, con){
  x <- DBI::dbGetQuery(con, sprintf(
    "select id from table_dimensions where table_id = %f and dimension = '%s'", id, dimension))
  if(nrow(x) == 0) {NA} else {
    as.numeric(x[1,1])}
}

#' Get unit id from name
#'
#'
#' @inheritParams common_parameters
#' @param name character name of unit
#'
#' @return numeric id
#' @export
get_unit_id_from_unit_name <- function(name, con){
  DBI::dbGetQuery(con, sprintf(
    "select id from unit where name = '%s'", name))
}

#' Get series ids from table id
#'
#'
#' @inheritParams common_parameters
#' @param id numeric table id
#'
#' @return numeric ids
#' @export
get_series_ids_from_table_id <- function(id, con){
  DBI::dbGetQuery(con, sprintf(
    "select id from series where table_id = %f", id))
}

#' Get series id from series code
#'
#'
#' @inheritParams common_parameters
#' @param series_code series code value
#'
#' @return numeric id
#' @export
get_series_id_from_series_code <- function(series_code, con){
  x <- DBI::dbGetQuery(con, sprintf(
    "select id from series where code = '%s'", series_code))
    if(nrow(x) == 0) {NA} else {
      as.numeric(x[1,1])}
}

#' Get the largest existing category id for a given source
#'
#'
#' @inheritParams common_parameters
#' @param source_id numeric source id
#'
#' @return numeric id
#' @export
get_max_category_id_for_source <- function(source_id, con){
  DBI::dbGetQuery(con, sprintf(
    "select max(id) from category where source_id = %f", source_id))
}

#' Get initials from author name
#'
#'
#' @inheritParams common_parameters
#' @param name author's name
#'
#' @return character initials
#' @export
get_initials_from_author_name <- function(name, con){
  x <- DBI::dbGetQuery(con, sprintf(
    "select initials from umar_authors where name = '%s'", name))
  if(nrow(x) == 0) {NA} else {
    x[1,1]}
}


#' Get structural metadata for individual UMAR author
#'
#' This function is a leftover from a dead end approach, but might still come
#' in handy. it takes an author name and grabs most of the structural metadata
#' for that authorćs series in the database.
#'
#' @inheritParams common_parameters
#' @param author_name author's name
#'
#' @return character initials
#' @export
get_metadata_from_author_name <- function(author_name, con){
  initials <- get_initials_from_author_name(author_name, con)
# get all table codes
  sql_fun <- "CREATE OR REPLACE FUNCTION get_middle_string(str text, delim text)
  RETURNS text AS $$
    DECLARE
  arr text[];
  res text;
  BEGIN
  arr := string_to_array(str, delim);
  IF array_length(arr, 1) > 2 THEN
  res := array_to_string(arr[3:array_upper(arr, 1)-1], delim);
  ELSE
  res := NULL;
  END IF;
  RETURN res;
  END;
  $$ LANGUAGE plpgsql;"
  dbSendQuery(con, sql_fun)
  x <- DBI::dbGetQuery(con, sprintf("
  SELECT
  t1.code,
  t1.name,
  STRING_AGG(t2.dimension, '--') AS dimz,
  t3.id AS series_id,
  t3.table_id ,
  t3.name_long,
  t3.code,
  t3.interval_id,
  t4.name,
  get_middle_string(t3.code, '--') AS dim_levels
  FROM
  test_platform.table t1
  JOIN
  test_platform.table_dimensions t2 ON t1.id = t2.table_id
  JOIN
  test_platform.series t3 ON t1.id = t3.table_id
  JOIN
  test_platform.unit t4 on t3.unit_id = t4.id
  WHERE
  t1.code LIKE '%s%%'
  GROUP BY
  t1.id, t1.code, t1.name, t3.id, t3.table_id, t3.name_long, t4.name;", initials))
x
}
