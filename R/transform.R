#' Parses the period_id as a date for plotting
#'
#' Taking the datapoints table or any dataframe with a period_id column,
#' the function parses it as a date e.g. 2022M02 becomes 2022-02-01.
#' Currently works for months and quarters. Gets the interval from the database.
#' NB: Based on lubridate functions `ym` and `yq`, which give you the first day of the period.
#'
#'
#' @param interval "M" or "Q" right now, in practice  `interval <- get_interval(vintage, con)`
#' @param df a dataframe with at least a period_id column
#'
#' @return the same dataframe with an added period column
#' @export
#'
add_date_from_period_id <- function(df, interval) {
  df %>%
    dplyr::mutate(interval = interval) %>%
    dplyr::mutate(period =
                    dplyr::if_else(interval == "M",
                                   lubridate::ym(period_id),
                                   dplyr::if_else(interval == "Q",
                                                  lubridate::yq(period_id), NULL))) %>%
    dplyr::select(-interval)
}




#' Prepare data needed for a univariate line chart
#'
#' Given the vintage id and a connection to the database, this function
#' gets the datapoints, and the unit, prepares the titles.
#'
#' @inheritParams common_parameters
#'
#' @return a list with the dataframe with values, period_ids and periods as the
#' first element, a character unit name as second, and the row wrapped main and
#' subtitles (default 100 chars max 3 lines).
#' @export
#'
prep_single_line <- function(vintage, con){
  single <- add_date_from_period_id(get_data_points(vintage, con),
                                    get_interval(vintage, con))
  unit <- UMARvisualisR::first_up(get_unit(vintage, con))
  main_title <- UMARvisualisR::wrap_string(get_table_name(vintage, con))
  sub_title <- UMARvisualisR::wrap_string(get_series_name(vintage, con))
return(list(single, unit, main_title, sub_title))
}
