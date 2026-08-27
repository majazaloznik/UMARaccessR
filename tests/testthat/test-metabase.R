

# ---------------------------------------------------------------------------
# test
# ---------------------------------------------------------------------------
test_that("sql_get_eurostat_metabase_changes_from_snapshot works correctly", {
  with_mock_db({
    con <- make_test_connection2()
    result <- sql_get_eurostat_metabase_changes_from_snapshot(
      con, 16, schema = "eurostat")

    # shape
    expect_s3_class(result, "data.frame")
    expect_named(result,
                 c("dataset", "event", "dim_changes", "level_added", "level_removed"))

    # every event is one of the three known types
    expect_true(all(result$event %in%
                      c("changed", "dataset_added", "dataset_removed")))

    # no 'time' dimension leaks into dim_changes
    expect_false(any(grepl("time:", result$dim_changes, fixed = TRUE),
                     na.rm = TRUE))
  })
  DBI::dbDisconnect(con)
})



# ---------------------------------------------------------------------------
# test
# ---------------------------------------------------------------------------
test_that("sql_get_eurostat_removed_levels_from_snapshot works correctly", {
  with_mock_db({
    con <- make_test_connection2()
    result <- sql_get_eurostat_removed_levels_from_snapshot(
      con, 14, c("demo_fager", "demo_find"), schema = "eurostat")

    expect_s3_class(result, "data.frame")
    expect_named(result, c("dataset", "dim", "removed"))
    # time is never a reported dimension
    expect_false(any(result$dim == "time"))
    # every reported dataset was one we asked for
    expect_true(all(result$dataset %in% c("demo_fager", "demo_find")))
  })
  DBI::dbDisconnect(con)
})

test_that("sql_get_eurostat_removed_levels_from_snapshot handles empty input", {
  # no DB call needed; short-circuits before the query
  result <- sql_get_eurostat_removed_levels_from_snapshot(
    con = NULL, snapshot_id = 1L, datasets = character(0))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("sql_get_eurostat_removed_levels_from_snapshot rejects commas in codes", {
  # the comma is the array delimiter; a code containing one would mis-split
  # server-side, so it must fail loudly before the query runs
  expect_error(
    sql_get_eurostat_removed_levels_from_snapshot(
      con = NULL, snapshot_id = 1L, datasets = c("demo_fager", "bad,code")),
    "must not contain commas")
})


# ---------------------------------------------------------------------------
# test
# ---------------------------------------------------------------------------
test_that("sql_resolve_eurostat_folder_datasets works correctly", {
  with_mock_db({
    con <- make_test_connection()
    result <- sql_resolve_eurostat_folder_datasets(
      con, "ext_go_lti", schema = "eurostat")

    expect_s3_class(result, "data.frame")
    expect_named(result, c("code", "type"))
    # only leaves, never folders
    expect_true(all(result$type %in% c("dataset", "table")))
    # a folder with descendants should return at least one
    expect_gt(nrow(result), 0)
  })
  DBI::dbDisconnect(con)
})
