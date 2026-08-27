#' Get Eurostat metabase structural changes for a snapshot
#'
#' Returns one row per affected dataset for the given metabase snapshot,
#' classifying each change as a whole-dataset event (`dataset_added` /
#' `dataset_removed`) or a within-dataset change (`changed`) with dimension
#' changes and level (position) counts. The `time` dimension is excluded.
#'
#' Wraps the `eurostat.get_metabase_changes` database function.
#'
#' @param con Database connection object
#' @param snapshot_id Integer (or integer64) snapshot identifier
#' @param schema Character string specifying the database schema
#'
#' @return A data frame with columns `dataset`, `event`, `dim_changes`,
#'   `level_added`, `level_removed`; zero rows if the snapshot introduced no
#'   (non-time) structural changes.
#' @export
sql_get_eurostat_metabase_changes_from_snapshot <- function(con, snapshot_id,
                                                            schema = "eurostat") {
  UMARimportR::sql_function_call(
    con,
    "get_metabase_changes",
    list(p_snapshot_id = snapshot_id),
    schema)
}

#' Get removed levels for datasets in a Eurostat metabase snapshot
#'
#' Returns the specific position codes removed (not just counts) for the given
#' datasets at the given snapshot, so alert emails can list exactly which levels
#' disappeared. A removed level is the actionable case: it breaks queries that
#' filter on it. The `time` dimension is excluded.
#'
#' Wraps the `eurostat.get_removed_levels` database function, which takes the
#' dataset list as a native text array — no client-side quoting required.
#'
#' @param con Database connection object
#' @param snapshot_id Integer (or integer64) snapshot identifier
#' @param datasets Character vector of dataset codes to report on
#' @param schema Character string specifying the database schema
#'
#' @return A data frame with columns `dataset`, `dim`, and `removed`
#'   (comma-separated codes, alphabetical); zero rows if no datasets were
#'   supplied or none of them had removed levels in this snapshot.
#' @export
sql_get_eurostat_removed_levels_from_snapshot <- function(con, snapshot_id,
                                                          datasets,
                                                          schema = "eurostat") {
  if (length(datasets) == 0) {
    return(data.frame(dataset = character(0), dim = character(0), removed = character(0)))
  }
  if (any(grepl(",", datasets, fixed = TRUE)))
    stop("dataset codes must not contain commas (array delimiter)")

  UMARimportR::sql_function_call(
    con, "get_removed_levels",
    list(p_snapshot_id = snapshot_id,
         p_datasets = paste(datasets, collapse = ",")),
    schema)
}



#' Resolve a Eurostat TOC folder code to its descendant dataset/table codes
#'
#' Walks the current TOC tree from the given folder code and returns every
#' descendant leaf (dataset or table) beneath it, transitively. Folders are not
#' returned. Used to expand a folder subscription into the set of dataset codes
#' it should match against. A folder that does not exist, or contains no leaves,
#' returns zero rows.
#'
#' Wraps the `eurostat.resolve_folder_datasets` database function.
#'
#' @param con Database connection object
#' @param folder_code Character folder code (from the TOC navigation tree)
#' @param schema Character string specifying the database schema
#'
#' @return A data frame with columns `code` and `type` ('dataset' or 'table');
#'   zero rows if the folder is unknown or empty.
#' @export
sql_resolve_eurostat_folder_datasets <- function(con, folder_code,
                                                 schema = "eurostat") {
  UMARimportR::sql_function_call(
    con,
    "resolve_folder_datasets",
    list(p_folder_code = folder_code),
    schema)
}
