#' Parses the period_id as a date for plotting
#'
#' Taking the datapoints table or any dataframe with a period_id column,
#' the function parses it as a date e.g. 2022M02 becomes 2022-02-01.
#' Currently works for months and quarters. Gets the interval from the database.
#' NB: Based on lubridate functions `ym` and `yq`, which give you the first day of the period.
#'
#'
#' @param interval "M" or "Q" right now, in practice  `interval <- get_interval_from_vintage(vintage, con)`
#' @param df a dataframe with at least a period_id column
#'
#' @return the same dataframe with an added period column
#' @export
#' @importFrom rlang .data
#'
add_date_from_period_id <- function(df, interval) {
  df %>%
    dplyr::mutate(interval = interval) %>%
    dplyr::mutate(period =
                    dplyr::if_else(interval == "M",
                                   lubridate::ym(period_id, quiet = TRUE),
                                   dplyr::if_else(interval == "Q",
                                                  lubridate::yq(period_id, quiet = TRUE),
                                                  dplyr::if_else(interval == "A",
                                                                 lubridate::ymd(period_id, truncated = 2L, quiet = TRUE),
                                                                 as.Date(NA))))) %>%
    dplyr::select(-interval)
}

#' Parses the period_id as a date for plotting
#'
#' Taking the datapoints table or any dataframe with a period_id column,
#' the function parses it as a the last date of the period e.g. 2022M02 becomes 2022-02-28.
#' Currently works for months and quarters. Gets the interval from the database.
#' NB: Based on lubridate functions `ym` and `yq`, which give you the first day of the period.
#'
#'
#' @param interval "M" or "Q" right now, in practice  `interval <- get_interval_from_vintage(vintage, con)`
#' @param df a dataframe with at least a period_id column
#'
#' @return the same dataframe with an added period column
#' @export
#' @importFrom rlang .data
#'
add_last_date_from_period_id <- function(df, interval) {
  df %>%
    dplyr::mutate(interval = interval) %>%
    dplyr::mutate(period =
                    dplyr::if_else(interval == "M",
                                   lubridate::ceiling_date(
                                     lubridate::ym(period_id, quiet = TRUE),
                                     "month") - lubridate::days(1),
                                   dplyr::if_else(interval == "Q",
                                                  lubridate::ceiling_date(
                                                    lubridate::yq(period_id, quiet = TRUE),
                                                    "quarter") - lubridate::days(1),
                                                  dplyr::if_else(interval == "A",
                                                                 lubridate::ceiling_date(
                                                                   lubridate::ymd(period_id, truncated = 2L, quiet = TRUE),
                                                                   "year") - lubridate::days(1),
                                                                 as.Date(NA))))) %>%
    dplyr::select(-interval)
}
