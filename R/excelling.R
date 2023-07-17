#' Prepare excel file for series selection
#'
#' Takes the dataframe with all the series produced by \link[UMARaccessR]{get_all_series_wtable_names}
#' and creates an excel file with these series and a prepared sheet for creating a selection of
#' series.
#'
#' @param df dataframe, probably  from \link[UMARaccessR]{get_all_series_wtable_names}
#' @param outfile name of excel file to save to
#' @param overwrite - whether or not to overwrite previous file
#'
#' @return nothing - side effect is saving to an excel file.
#' @export
#'
#' @example
#' \dontrun{
#' create_selection_excel(get_all_series_wtable_names(con))
#' }
create_selection_excel <- function(df, outfile = "db_series",
                                   overwrite = TRUE){
  df %>%
    dplyr::rename(unit_name = unit) -> df
  outfile <- paste0(outfile, "-", Sys.Date(), ".xlsx")
  nejmz <- c(names(df), "chart_no", "chart_title", "sub_chart", "sub_chart_title",
             "legend_label", "shape", "rolling_average_periods",
             "rolling_average_alignment", 	"year_on_year", "xmin",	"xmax", "notes")

  selection_df <- setNames(data.frame(matrix(ncol = length(nejmz), nrow = 0)), nejmz)


  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "series")
  openxlsx::addWorksheet(wb, "selection")

  openxlsx::writeData(wb, "series", df, startRow = 1, startCol = 1)
  openxlsx::writeData(wb, "selection", selection_df, startRow = 1, startCol = 1)
  openxlsx::freezePane(wb,"series", firstActiveRow = 2)
  openxlsx::freezePane(wb,"selection", firstActiveRow = 2)
  openxlsx::saveWorkbook(wb, file = outfile, overwrite = overwrite)
}
