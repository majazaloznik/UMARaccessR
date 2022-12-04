#' Parses the period_id as a date for plotting
#'
#' Taking the datapoints table or any dataframe with a period_id column,
#' the function parses it as a date e.g. 2022M02 becomes 2022-02-01.
#' Currently works for months and quarters. Gets the interval from the database.
#'
#' @inheritParams common_parameters
#' @param interval "M" or "Q" right now, in practice  `interval <- get_interval(vintage, con)`
#' @param df a dataframe with at least a period_id column
#'
#' @return teh same dataframe with an added period column
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
