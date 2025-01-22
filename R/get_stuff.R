#' Get unit name from vintage ID
#'
#' @param con Database connection object
#' @param vintage_id Integer vintage identifier
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing unit name or NULL if not found
#' @export
sql_get_unit_from_vintage <- function(con, vintage_id, schema = "test_platform") {

  result <- UMARimportR::sql_function_call(con,
                                           "get_unit_from_vintage",
                                           list(p_vintage_id = vintage_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)

  return(result$name[1])
}

#' Get unit name from vintage id
#'
#' Joins vintage and series tables to get the id of the unit,
#' which is looked up in the unit table to get its name.
#'
#' Deprecated: Use `sql_get_unit_from_vintage()` instead.
#'
#' @inheritParams common_parameters
#'
#' @return character vector of unit name.
#' @export

get_unit_from_vintage <- function(vintage, con) {
  .Deprecated("sql_get_unit_from_vintage")
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
#' @param con Database connection object
#' @param series_id Integer series identifier
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing unit name or NULL if not found
#' @export
sql_get_unit_from_series <- function(con, series_id, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_unit_from_series",
                                           list(p_series_id = series_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$name[1])
}


#' Get unit name from series id
#'
#' Joins vintage and series tables to get the id of the unit,
#' which is looked up in the unit table to get its name.
#'
#' Deprecated:  Use `sql_get_unit_from_series()` instead.
#'
#' @inheritParams common_parameters
#'
#' @return character vector of unit name.
#' @export
get_unit_from_series <- function(series, con) {
  .Deprecated("sql_get_unit_from_series")
  DBI::dbGetQuery(con, sprintf(
    "select name from unit where id =
  (select unit_id from series
  where id = %f)", series)) -> unit
  if (identical(unit, character(0))) unit <- NULL
  return(unit[1,1])
}

#' Get series name from vintage ID
#'
#' @param con Database connection object
#' @param vintage_id Integer vintage identifier
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing series name or NULL if not found
#' @export
sql_get_series_name_from_vintage <- function(con, vintage_id, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_series_name_from_vintage",
                                           list(p_vintage_id = vintage_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$name_long[1])
}

#' Get series name from vintage ID
#'
#' Joins vintage table with series to get the series name_long.
#'
#' Deprecated: Use `sql_get_series_name_from_vintage()` instead.
#' @inheritParams common_parameters
#'
#' @return character vector of series name.
#' @export

get_series_name_from_vintage <- function(vintage, con) {
  .Deprecated("sql_get_series_name_from_vintage")
  DBI::dbGetQuery(con, sprintf(
    "select name_long from vintage
    left join series
    on vintage.series_id=series.id
    where vintage.id = %f", vintage))
}

#' Get series name from series ID
#'
#' @param con Database connection object
#' @param series_id Integer series identifier
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing series name or NULL if not found
#' @export
sql_get_series_name_from_series <- function(con, series_id, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_series_name_from_series",
                                           list(p_series_id = series_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$name_long[1])
}

#' Get series name from series ID
#'
#' Get the series name_long.
#'
#' Deprecated: Use `sql_get_series_name_from_series()` instead.
#'
#' @inheritParams common_parameters
#'
#' @return character vector of series name.
#' @export

get_series_name_from_series <- function(series, con) {
  .Deprecated("sql_get_series_name_from_series")
  DBI::dbGetQuery(con, "select name_long from series where id = $1", list(series))
}

#' Get series name from series code
#'
#' @param con Database connection object
#' @param series_code Character string series code
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing series name or NULL if not found
#' @export
sql_get_series_name_from_series_code <- function(con, series_code, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_series_name_from_series_code",
                                           list(p_series_code = series_code),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$name_long[1])
}

#' Get series name from series code
#'
#' Get the series name_long.
#'
#' Deprecated: Use `sql_get_series_name_from_series_code()` instead.
#'
#' @inheritParams common_parameters
#'
#' @return character vector of series name.
#' @export

get_series_name_from_series_code <- function(series, con) {
  .Deprecated("sql_get_series_name_from_series_code")
  DBI::dbGetQuery(con, sprintf(
    "select name_long from series
    where code = '%s'", series))
}

#' Get table name from vintage ID
#'
#' @param con Database connection object
#' @param vintage_id Integer vintage identifier
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing table name or NULL if not found
#' @export
sql_get_table_name_from_vintage <- function(con, vintage_id, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_table_name_from_vintage",
                                           list(p_vintage_id = vintage_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$name[1])
}

#' Get table name from vintage ID
#'
#' Joins the vintage table with the series table to get the
#' table id and then looks up the name in the table table.
#'
#' Deprecated: Use `sql_get_table_name_from_vintage()` instead.
#'
#' @inheritParams common_parameters
#' @return character vector of table name.
#' @export
get_table_name_from_vintage <- function(vintage, con) {
  .Deprecated("sql_get_table_name_from_vintage")
  DBI::dbGetQuery(con, sprintf(
    "select name from \"table\" where id =
    (select series.table_id from vintage
     left join series
     on vintage.series_id=series.id
     where vintage.id = %f)", vintage))
}

#' Get table name from series ID
#'
#' @param con Database connection object
#' @param series_id Integer series identifier
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing table name or NULL if not found
#' @export
sql_get_table_name_from_series <- function(con, series_id, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_table_name_from_series",
                                           list(p_series_id = series_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$name[1])
}

#' Get table name from series ID
#'
#' Lookup the table name from the series ID
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_table_name_from_series}` instead.
#'
#' @inheritParams common_parameters
#' @return character vector of table name.
#' @export
get_table_name_from_series <- function(series, con) {
  .Deprecated("sql_get_table_name_from_series")
  DBI::dbGetQuery(con, sprintf(
    "select name from \"table\" where id =
    (select table_id from series
     where id = %f)", series))
}

#' Get interval ID from vintage ID
#'
#' @param con Database connection object
#' @param vintage_id Integer vintage identifier
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing interval ID or NULL if not found
#' @export
sql_get_interval_from_vintage <- function(con, vintage_id, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_interval_from_vintage",
                                           list(p_vintage_id = vintage_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$interval_id[1])
}

#' Get table interval from vintage ID
#'
#' Joins the vintage table with the series table to get the
#' interval id, which is alphanumeric e.g. M for monthly etc.
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_interval_from_vintage}` instead.
#'
#' @inheritParams common_parameters
#' @param vintage numeric id of vintage
#' @return character vector of interval id
#' @export
get_interval_from_vintage <- function(vintage, con) {
  .Deprecated("sql_get_interval_from_vintage")
  DBI::dbGetQuery(con, sprintf(
    "select interval_id from series where id =
    (select series.id from vintage
     left join series
     on vintage.series_id=series.id
     where vintage.id = %f)", vintage)) -> interval
  return(interval[1,1])
}


#' Get interval ID from series ID
#'
#' @param con Database connection object
#' @param series_id Integer series identifier
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing interval ID or NULL if not found
#' @export
sql_get_interval_from_series <- function(con, series_id, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_interval_from_series",
                                           list(p_series_id = series_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$interval_id[1])
}

#' Get table interval from series ID
#'
#' Get the interval id from the series table, which is alphanumeric e.g. M for monthly etc.
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_interval_from_series}` instead.
#'
#' @inheritParams common_parameters
#' @return character vector of interval id
#' @export
get_interval_from_series <- function(series, con) {
  .Deprecated("sql_get_interval_from_series")
  DBI::dbGetQuery(con, sprintf(
    "select interval_id from series
    where id  = %f", series)) -> interval
  return(interval[1,1])
}


#' Get vintage ID from series ID
#'
#' @param con Database connection object
#' @param series_id Integer series identifier
#' @param date_valid Timestamp when the vintage was valid (optional)
#' @param schema Character string specifying the database schema
#'
#' @return Integer vintage ID or NULL if not found
#' @export
sql_get_vintage_from_series <- function(con, series_id, date_valid = NULL,
                                        schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_vintage_from_series",
                                           list(p_series_id = series_id,
                                                p_date_valid = date_valid),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$id[1])
}

#' Get vintage id from series id
#'
#' Gets the vintage based on the series ID, by default the most recent one,
#' otherwise the one that was valid on the date passed with `date_valid`.
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_vintage_from_series}` instead.
#'
#' @inheritParams common_parameters
#' @param date_valid date when the vintage was valid if none is given most recent
#' i.e. currently valid vintage is returned.
#' @return numeric vintage id.
#' @export
get_vintage_from_series <- function(series, con, date_valid = NULL){
  .Deprecated("sql_get_vintage_from_series")
  if(!is.null(date_valid)){
    validity <- sprintf("and published < '%s'", date_valid)
  } else {
    validity <- " "
  }
  DBI::dbGetQuery(con, sprintf(
    "select id from vintage
    where series_id  = %f %s
    order by published desc limit 1", series, validity))
}

#' Get vintage ID from series code
#'
#' @param con Database connection object
#' @param series_code Character string series code
#' @param date_valid Timestamp when the vintage was valid (optional)
#' @param schema Character string specifying the database schema
#'
#' @return Integer vintage ID or NULL if not found
#' @export
sql_get_vintage_from_series_code <- function(con, series_code, date_valid = NULL,
                                             schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_vintage_from_series_code",
                                           list(p_series_code = series_code,
                                                p_date_valid = date_valid),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$id[1])
}

#' Get vintage id from series code
#'
#' Gets the vintage based on the series code, by default the most recent one,
#' otherwise the one that was valid on the date passed with `date_valid`.
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_vintage_from_series_code}` instead.
#'
#' @inheritParams common_parameters
#' @param series_code the characther code for each series (not the id)
#' @param date_valid date when the vintage was valid if none is given most recent
#' i.e. currently valid vintage is returned.
#' @return numeric vintage id.
#' @export
get_vintage_from_series_code <- function(series_code, con, date_valid = NULL){
  .Deprecated("sql_get_vintage_from_series_code")
  if(!is.null(date_valid)){
    validity <- sprintf("and published < '%s'", date_valid)
  } else {
    validity <- " "
  }
  DBI::dbGetQuery(con, sprintf(
    "select vintage.id from vintage join series
    on vintage.series_id = series.id
    where series.code = '%s' %s
    order by published desc limit 1", series_code, validity))
}

#' Get data points from vintage ID
#'
#' @param con Database connection object
#' @param vintage_id Integer vintage identifier
#' @param schema Character string specifying the database schema
#'
#' @return A data frame with period_id and value columns, ordered by period_id
#' @export
#' @importFrom rlang .data
sql_get_data_points_from_vintage <- function(con, vintage_id, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_data_points_from_vintage",
                                           list(p_vintage_id = vintage_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result)
}

#' Get and prep the datapoint table for a single vintage
#'
#' Gets the data periods and values for a single vintage.
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_data_points_from_vintage}` instead.
#'
#' @inheritParams common_parameters
#' @param vintage numeric id of vintage
#' @return a two column dataframe with the period_id, and value for all
#' the datapoints in that vintage.
#' @export
#' @importFrom rlang .data
get_data_points_from_vintage <- function(vintage, con){
  .Deprecated("sql_get_data_points_from_vintage")
  DBI::dbGetQuery(con, sprintf(
    "select period_id, value from data_points where vintage_id = %f", vintage)) %>%
    dplyr::arrange(.data$period_id)
}

#' Get data points from series ID
#'
#' Gets the data points for a series, by default from the most recent vintage,
#' otherwise from the vintage that was valid on the date passed with `date_valid`.
#'
#' @param con Database connection object
#' @param series_id Integer series identifier
#' @param date_valid Timestamp when the vintage was valid (optional)
#' @param schema Character string specifying the database schema
#'
#' @return A data frame with period_id and value columns, ordered by period_id
#' @export
sql_get_data_points_from_series_id <- function(con, series_id, date_valid = NULL,
                                            schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_data_points_from_series",
                                           list(p_series_id = series_id,
                                                p_date_valid = date_valid),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result)
}

#' Get data points for series from latest vintage (Mock version for fixture recording)
#'
#' @param con Database connection object
#' @param series_id Integer series identifier
#' @param new_name character string to rename the value column
#' @param date_valid Optional timestamp for vintage selection
#' @param schema Character string specifying the database schema, defaults to "platform"
#'
#' @return Data frame with period_id and value columns
#' @export
mock_get_data_points_from_series_id <- function(con, series_id,  new_name = NULL,
                                                date_valid = NULL,
                                             schema = "platform") {
  date_condition <- if (!is.null(date_valid)) {
    sprintf("AND published < '%s'", format(date_valid, "%Y-%m-%d %H:%M:%S"))
  } else {
    ""
  }

  query <- sprintf(
    "SELECT dp.period_id, dp.value
     FROM %s.vintage v
     JOIN %s.data_points dp ON dp.vintage_id = v.id
     WHERE v.series_id = %d
     %s
     AND v.id = (
         SELECT id
         FROM %s.vintage v2
         WHERE v2.series_id = %d
         %s
         ORDER BY published DESC
         LIMIT 1
     )
     ORDER BY dp.period_id",
    schema, schema, series_id, date_condition,
    schema, series_id, date_condition
  )

  result <- DBI::dbGetQuery(con, query)
  if (nrow(result) == 0) return(NULL)
  if(!is.null(new_name)) result <- result |> dplyr::rename({{new_name}} := value)
  return(result)
}

#' Get publication date from vintage ID
#'
#' @param con Database connection object
#' @param vintage_id Integer vintage identifier
#' @param schema Character string specifying the database schema
#'
#' @return POSIXct timestamp with CET timezone
#' @export
sql_get_date_published_from_vintage <- function(vintage_id, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_date_published_from_vintage",
                                           list(p_vintage_id = vintage_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  lubridate::with_tz(result$published[1], "CET")
}

#' Get the publication date from the vintage id
#'
#' Just does that.
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_date_published_from_vintage}` instead.
#'
#' @inheritParams common_parameters
#' @return POSIXct value with CET timezone
#' @export
get_date_published_from_vintage <- function(vintage, con){
  .Deprecated("sql_get_date_published_from_vintage")
  DBI::dbGetQuery(con, sprintf(
    "select published from vintage where id = %f", vintage)) %>%
    lubridate::with_tz("CET")
}


#' Get last period from vintage ID
#'
#' @param con Database connection object
#' @param vintage_id Integer vintage identifier
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing period ID (e.g., "2022M03") or NULL if not found
#' @export
sql_get_last_period_from_vintage <- function(con, vintage_id, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_last_period_from_vintage",
                                           list(p_vintage_id = vintage_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$period_id[1])
}

#' Get the most recent period for which a vintage has data
#'
#' The vintage must have an actual non null value for that period.
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_last_period_from_vintage}` instead.
#'
#' @inheritParams common_parameters
#' @return character of period id e.g "2022M03"
#' @export
get_last_period_from_vintage <- function(vintage, con){
  .Deprecated("sql_get_last_period_from_vintage")
  DBI::dbGetQuery(con, sprintf(
    "select period_id from data_points where vintage_id = %f and value is not null
    order by period_id desc limit 1", vintage))
}

#' Get all series in the database
#'
#' Get all series in the database
#'
#' Extracts a dataframe with all the series in the database joined together
#' with their table names and units.
#'
#' @param con Database connection object
#' @param schema Character string specifying the database schema
#'
#' @return Data frame with a row for each series containing table and unit information
#' @export
sql_get_all_series_wtable_names <- function(con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_all_series_wtable_names",
                                           args = NULL,  # Pass NULL instead of empty list
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result)
}

#' Get all series in the database
#'
#' Extracts a dataframe with all the series in the database joined together
#' with their table names and units. Used in \link[UMARaccessR]{create_selection_excel}.
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_all_series_wtable_names}` instead.
#'
#' @inheritParams common_parameters
#' @return dataframe with a row for each series
#' @export
get_all_series_wtable_names <- function(con){
  .Deprecated("sql_get_all_series_wtable_names")
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

#' Get source ID from source name
#'
#' @param con Database connection object
#' @param source_name Character string with source name
#' @param schema Character string specifying the database schema
#'
#' @return Integer source ID or NULL if not found
#' @export
sql_get_source_code_from_source_name <- function(con, source_name, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_source_code_from_source_name",
                                           list(p_source_name = source_name),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$id[1])
}

#' Get source code from source name
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_source_code_from_source_name}` instead.
#'
#' @inheritParams common_parameters
#' @param name character string with source name
#' @return numeric code
#' @export
get_source_code_from_source_name <- function(name, con){
  .Deprecated("sql_get_source_code_from_source_name")
  DBI::dbGetQuery(con, sprintf(
    "select id from source where name = '%s'", name))
}

#' Get table ID from table code
#'
#' @param con Database connection object
#' @param table_code Character string with table code
#' @param schema Character string specifying the database schema
#'
#' @return Numeric table ID or NA if not found
#' @export
sql_get_table_id_from_table_code <- function(con, table_code, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_table_id_from_table_code",
                                           list(p_table_code = table_code),
                                           schema)
  if (nrow(result) == 0) return(NA)
  return(as.numeric(result$id[1]))
}

#' Get table id from table code
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_table_id_from_table_code}` instead.
#'
#' @inheritParams common_parameters
#' @param code character string with table code
#' @return numeric code
#' @export
get_table_id_from_table_code <- function(code, con){
  .Deprecated("sql_get_table_id_from_table_code")
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
#' @param con Database connection object
#' @param table_id Numeric table identifier
#' @param dimension Character string with dimension name
#' @param schema Character string specifying the database schema
#'
#' @return Numeric code or NA if not found
#' @export
sql_get_tab_dim_id_from_table_id_and_dimension <- function(table_id, dimension, con,
                                                           schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_tab_dim_id_from_table_id_and_dimension",
                                           list(p_table_id = table_id,
                                                p_dimension = dimension),
                                           schema)
  if (nrow(result) == 0) return(NA)
  return(as.numeric(result$id[1]))
}


#' Get dimension id from table id and dimension name
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_tab_dim_id_from_table_id_and_dimension}` instead.
#'
#' @inheritParams common_parameters
#' @param id numeric table id
#' @param dimension character string with dimension name
#' @return numeric code
#' @export
get_tab_dim_id_from_table_id_and_dimension <- function(id, dimension, con){
  .Deprecated("sql_get_tab_dim_id_from_table_id_and_dimension")
  x <- DBI::dbGetQuery(con, sprintf(
    "select id from table_dimensions where table_id = %f and dimension = '%s'", id, dimension))
  if(nrow(x) == 0) {NA} else {
    as.numeric(x[1,1])}
}

#' Get unit ID from unit name
#'
#' @param con Database connection object
#' @param unit_name Character string with unit name
#' @param schema Character string specifying the database schema
#'
#' @return Integer unit ID or NULL if not found
#' @export
sql_get_unit_id_from_unit_name <- function(unit_name, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_unit_id_from_unit_name",
                                           list(p_unit_name = unit_name),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$id[1])
}

#' Get unit id from name
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_unit_id_from_unit_name}` instead.
#'
#' @inheritParams common_parameters
#' @param name character name of unit
#' @return numeric id
#' @export
get_unit_id_from_unit_name <- function(name, con){
  .Deprecated("sql_get_unit_id_from_unit_name")
  DBI::dbGetQuery(con, sprintf(
    "select id from unit where name = '%s'", name))
}


#' Get series IDs from table ID
#'
#' @param con Database connection object
#' @param table_id Integer table identifier
#' @param schema Character string specifying the database schema
#'
#' @return Data frame of series IDs or NULL if none found
#' @export
sql_get_series_ids_from_table_id <- function(table_id, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_series_ids_from_table_id",
                                           list(p_table_id = table_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result)
}

#' Get series ids from table id
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_series_ids_from_table_id}` instead.
#'
#' @inheritParams common_parameters
#' @param id numeric table id
#' @return numeric ids
#' @export
get_series_ids_from_table_id <- function(id, con){
  .Deprecated("sql_get_series_ids_from_table_id")
  DBI::dbGetQuery(con, sprintf(
    "select id from series where table_id = %f", id))
}

#' Get dimension levels from table ID
#'
#' @param con Database connection object
#' @param table_id Integer table identifier
#' @param schema Character string specifying the database schema
#'
#' @return Data frame containing dimension levels information or NULL if none found
#' @export
sql_get_dimension_levels_from_table_id <- function(table_id, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_dimension_levels_from_table_id",
                                           list(p_table_id = table_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result)
}

#' Get series ID from series code
#'
#' @param con Database connection object
#' @param series_code Character string series code
#' @param schema Character string specifying the database schema
#'
#' @return Numeric series ID or NA if not found
#' @export
sql_get_series_id_from_series_code <- function(series_code, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_series_id_from_series_code",
                                           list(p_series_code = series_code),
                                           schema)
  if (nrow(result) == 0) return(NA)
  return(result)
}

#' Get series id from series code
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_series_id_from_series_code}` instead.
#'
#' @inheritParams common_parameters
#' @param series_code series code value
#' @return numeric id
#' @export
get_series_id_from_series_code <- function(series_code, con){
  .Deprecated("sql_get_series_id_from_series_code")
  x <- DBI::dbGetQuery(con, sprintf(
    "select id from series where code = '%s'", series_code))
  if(nrow(x) == 0) {NA} else {
    as.numeric(x[1,1])}
}

#' Get maximum category ID for source ID
#'
#' @param con Database connection object
#' @param source_id Integer source identifier
#' @param schema Character string specifying the database schema
#'
#' @return Integer maximum category ID or 0 if none found
#' @export
sql_get_max_category_id_for_source <- function(source_id, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_max_category_id_for_source",
                                           list(p_source_id = source_id),
                                           schema)
  return(result$max_id[1])
}

#' Get the largest existing category id for a given source
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_max_category_id_for_source}` instead.
#'
#' @inheritParams common_parameters
#' @param source_id numeric source id
#' @return numeric id
#' @export
get_max_category_id_for_source <- function(source_id, con){
  .Deprecated("sql_get_max_category_id_for_source")
  DBI::dbGetQuery(con, sprintf(
    "select max(id) from category where source_id = %f", source_id))
}

#' Get author initials from author name
#'
#' @param con Database connection object
#' @param author_name Character string author name
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing author initials or NA if not found
#' @export
sql_get_initials_from_author_name <- function(author_name, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_initials_from_author_name",
                                           list(p_author_name = author_name),
                                           schema)
  if (nrow(result) == 0) return(NA)
  return(result$initials[1])
}

#' Get initials from author name
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_initials_from_author_name}` instead.
#'
#' @inheritParams common_parameters
#' @param name author's name
#' @return character initials
#' @export
get_initials_from_author_name <- function(name, con){
  .Deprecated("sql_get_initials_from_author_name")
  x <- DBI::dbGetQuery(con, sprintf(
    "select initials from umar_authors where name = '%s'", name))
  if(nrow(x) == 0) {NA} else {
    x[1,1]}
}

#' Get author email from author initials
#'
#' @param con Database connection object
#' @param initials Character string author initials
#' @param schema Character string specifying the database schema
#'
#' @return Character string containing author email or NA if not found
#' @export
sql_get_email_from_author_initials <- function(initials, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_email_from_author_initials",
                                           list(p_initials = initials),
                                           schema)
  if (nrow(result) == 0) return(NA)
  return(result$email[1])
}

#' Get email from author initials
#'
#' Deprecated: Use `\link[UMARaccessR]{sql_get_email_from_author_initials}` instead.
#'
#' @inheritParams common_parameters
#' @param initials author's initials
#' @return character email
#' @export
get_email_from_author_initials <- function(initials, con){
  .Deprecated("sql_get_email_from_author_initials")
  x <- DBI::dbGetQuery(con, sprintf(
    "select email from umar_authors where initials = '%s'", initials))
  if(nrow(x) == 0) {NA} else {
    x[1,1]}
}

#' Get dimension level value from level text
#'
#' @param con Database connection object
#' @param tab_dim_id Integer table dimension identifier
#' @param level_text Character string level text
#' @param schema Character string specifying the database schema
#'
#' @return Character string level value or NULL if not found
#' @export
sql_get_level_value_from_text <- function(tab_dim_id, level_text, con,
                                          schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_level_value_from_text",
                                           list(p_tab_dim_id = tab_dim_id,
                                                p_level_text = level_text),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$level_value[1])
}


#' Get time dimension name from table code
#'
#' @param con Database connection object
#' @param table_code Character string table code
#' @param schema Character string specifying the database schema
#'
#' @return Character string time dimension name or NULL if not found
#' @export
sql_get_time_dimension_from_table_code <- function(table_code, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_time_dimension_from_table_code",
                                           list(p_table_code = table_code),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$dimension[1])
}



#' Get publication dates for table ID
#'
#' @param con Database connection object
#' @param table_id Integer table identifier
#' @param schema Character string specifying the database schema
#'
#' @return Vector of publication timestamps or NULL if none found
#' @export
sql_get_last_publication_date_from_table_id <- function(table_id, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_last_publication_date_from_table_id",
                                           list(p_table_id = table_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result$published)  # Return vector of timestamps
}

#' Get non-time dimensions from table ID
#'
#' @param con Database connection object
#' @param table_id Integer table identifier
#' @param schema Character string specifying the database schema
#'
#' @return Data frame containing dimension names and IDs, or NULL if none found
#' @export
sql_get_non_time_dimensions_from_table_id <- function(table_id, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                          "get_non_time_dimensions_from_table_id",
                                          list(p_table_id = table_id),
                                          schema)
  if (nrow(result) == 0) return(NULL)
  return(result)
}

#' Get dimension ID for table ID and dimension name
#'
#' @param con Database connection object
#' @param table_id Integer table identifier
#' @param dimension Character string dimension name
#' @param schema Character string specifying the database schema
#'
#' @return Integer dimension ID or NULL if not found
#' @export
sql_get_dimension_id_from_table_id_and_dimension <- function(table_id, dimension, con,
                                                             schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_dimension_id_from_table_id_and_dimension",
                                           list(p_table_id = table_id,
                                                p_dimension = dimension),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(as.numeric(result$id[1]))
}

#' Get dimension levels from dimension ID
#'
#' @param con Database connection object
#' @param tab_dim_id Integer dimension identifier
#' @param schema Character string specifying the database schema
#'
#' @return Data frame containing dimension levels or NULL if none found
#' @export
sql_get_levels_from_dimension_id <- function(tab_dim_id, con, schema = "test_platform") {
  result <- UMARimportR::sql_function_call(con,
                                           "get_levels_from_dimension_id",
                                           list(p_tab_dim_id = tab_dim_id),
                                           schema)
  if (nrow(result) == 0) return(NULL)
  return(result)
}
