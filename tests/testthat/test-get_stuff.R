dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "sandbox",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"))
  DBI::dbExecute(con, "set search_path to test_platform")

  test_that("mock tests for get_stuff", {
    out <- get_unit_from_vintage(1625, con)
    expect_equal(out, "indeks")
    out <- get_unit_from_series(1625, con)
    expect_equal(out, "indeks")
    out <- get_unit_from_vintage(2532, con)
    expect_true(is.na(out))
    out <- get_series_name_from_vintage(1625, con)
    expect_true(grepl("storitvene dejavnosti", out[1,1]))
    out <- get_series_name_from_series(1625, con)
    expect_true(grepl("storitvene dejavnosti", out[1,1]))
    out <- get_table_name_from_vintage(1625, con)
    expect_true(grepl("Indeksi nominalnega", out[1,1]))
    out <- get_table_name_from_series(1625, con)
    expect_true(grepl("Indeksi nominalnega", out[1,1]))
    out <- get_data_points_from_vintage(1625, con)
    expect_true(all(dim(out)==c(273, 2)))
    out <- get_interval_from_vintage(1625, con)
    expect_equal(out, "M")
    out <- get_interval_from_series(1625, con)
    expect_equal(out, "M")
    out <- get_vintage_from_series(2389, con)
    expect_equal(out[1,1], 11814)
    out <- get_vintage_from_series_code("SURS--1700104S--2--2--Q", con)
    expect_equal(out[1,1], 59163)
    out <- get_date_published_from_vintage(1625, con)
    expect_equal(out[1,1], as.POSIXct("2022-10-27 10:30:00",  tz = "CET"))
    out <- get_last_period_from_vintage (1625, con)
    expect_equal(out[1,1], "2022M09")
    out <- get_last_period_from_vintage (351, con)
    expect_equal(out[1,1], as.character(NA))
    out <- get_source_code_from_source_name ("MF", con)
    expect_equal(out[1,1], 2)
    out <- get_table_id_from_table_code("DP", con)
    expect_equal(out, 24)
    # deprecated
    out <- get_dim_id_from_table_id(24, "Konto", con)
    expect_equal(out, 73)
    out <- get_tab_dim_id_from_table_id_and_dimension(24, "Konto", con)
    expect_equal(out, 73)
    out <- get_unit_id_from_unit_name("eur", con)
    expect_equal(nrow(out), 0)
    out <- get_series_ids_from_table_id(24, con)
    expect_equal(nrow(out), 3092)
    out <- get_series_name_from_series_code("MF--ZZZS--003--70--A", con)
    expect_equal(out[1,1], "DAV\\u010cNI PRIHODKI -- Letno")
    out <- get_max_category_id_for_source(2, con)
    expect_equal(out[1,1], 5)

  })
})


dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "platform",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"),
                        client_encoding = "utf8")
  dbExecute(con, "set search_path to test_platform")

  test_that("mock tests for get_stuff from diff test db", {
    out <- get_series_id_from_series_code("UMAR--MZ001--234--M", con)
    expect_equal(out, 40828)
    out <- get_initials_from_author_name("Maja Zalo\u017enik", con)
    expect_equal(out, "MZ")
    out <- get_email_from_author_initials("MZ", con)
    expect_equal(out, "maja.zaloznik@gov.si")
  })

})


test_that("new get functions work correctly", {
  with_mock_db({
    con <- make_test_connection()
    result <- sql_get_unit_from_vintage(con, 361L, schema = "test_platform")
    expect_equal(result, "mio eur")
    result <- sql_get_unit_from_series(con, 32421L, schema = "test_platform")
    expect_equal(result, "eur")
    result <- sql_get_series_name_from_vintage(con, 361L, schema = "test_platform")
    expect_equal(result, "F Gradbeništvo -- Stalne cene, referenčno leto 2010 (mio EUR) -- Originalni podatki")
    result <- sql_get_series_name_from_series(con, 361L, schema = "test_platform")
    expect_equal(result$name_long[1], "A Kmetijstvo, lov, gozdarstvo, ribištvo -- Tekoče cene (mio EUR) -- Originalni podatki")
    result <- sql_get_series_name_from_series_code(con, "SURS--1701102S--orig--C[skd]--M", schema = "test_platform")
    expect_equal(result$name_long[1], "Originalni podatki -- C PREDELOVALNE DEJAVNOSTI")
    result <- sql_get_table_name_from_vintage(con, 361L, schema = "test_platform")
    expect_equal(result, "Dodana vrednost po dejavnostih in BDP (SKD 2008), Slovenija, četrtletno")
    result <- sql_get_table_name_from_series(con, 32421L, schema = "test_platform")
    expect_equal(result, "Zavod za pokojninsko in invalidsko zavarovanje Slovenije")
    result <- sql_get_interval_from_vintage(con, 361L, schema = "test_platform")
    expect_equal(result, "Q")
    result <- sql_get_interval_from_series(con, 32421L, schema = "test_platform")
    expect_equal(result, "M")
    result_date <- sql_get_vintage_from_series(
      con, 361L,
      date_valid = as.POSIXct("2024-01-01"),
      schema = "test_platform")
    expect_equal(result_date, 84435)
    result <- sql_get_vintage_from_series_code(con, "SURS--0300220S--BTE--V--N--Q",
                                               date_valid = as.POSIXct("2024-01-01"),
                                               schema = "test_platform")
    expect_equal(result, 84436)
    result <- sql_get_data_points_from_vintage(con, 361L, schema = "test_platform")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("period_id", "value"))
    expect_equal(dim(result), c(111,2))
    if (nrow(result) > 1) {
      expect_true(all(result$period_id[-1] >= result$period_id[-nrow(result)]))
    }
    result <- sql_get_data_points_from_series_id(con, 361L,
                                                 date_valid = as.POSIXct("2023-03-01"),
                                                 schema = "test_platform")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("period_id", "value"))
    expect_equal(dim(result), c(112,2))
    if (nrow(result) > 1) {
      expect_true(all(result$period_id[-1] >= result$period_id[-nrow(result)]))
    }
    result <- mock_get_data_points_from_series_id(con, 1895, NULL, as.Date("2023-03-25"), schema = "test_platform")
    expect_true(nrow(result) ==109)
    result <- mock_get_data_points_from_series_id(con, 361, NULL,as.Date("2023-03-25"), schema = "test_platform")
    expect_true(nrow(result) ==112)
    result <- mock_get_data_points_from_series_id(con, 1895, schema = "test_platform")
    expect_true(nrow(result) ==116)
    result <- mock_get_data_points_from_series_id(con, 361, "test", schema = "test_platform")
    expect_true(nrow(result) ==113)
    expect_true("test" %in% colnames(result))
    result <- sql_get_last_period_from_vintage(con, 361L, schema = "test_platform")
    expect_equal(result, "2022Q3")
    result <- sql_get_source_code_from_source_name(con, "SURS", schema = "test_platform")
    expect_equal(result, 1)
    result <- sql_get_table_id_from_table_code(con, "0400600S", schema = "test_platform")
    expect_equal(result, 20)
    result <- sql_get_tab_dim_id_from_table_id_and_dimension(
      20L, "MERITVE", con, schema = "test_platform"
    )
    expect_equal(result, 63)
    result <- sql_get_unit_id_from_unit_name("mio eur", con, schema = "test_platform")
    expect_equal(result, 2)
    result <- sql_get_series_ids_from_table_id(21L, con, schema = "test_platform")
    expect_s3_class(result, "data.frame")
    expect_named(result, "id")
    expect_true(all(sapply(result$id, is.numeric)))
    expect_true(nrow(result) == 535)
    result <- sql_get_dimension_levels_from_table_id(21L, con, schema = "test_platform")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("tab_dim_id", "dimension", "level_value", "level_text"))
    expect_true(nrow(result) == 112)
    result <- sql_get_series_id_from_series_code("SURS--1700102S--1--6--M", con, schema = "test_platform")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("id"))
    expect_true(nrow(result) == 1)
    result <- sql_get_max_category_id_for_source(1L, con, schema = "test_platform")
    expect_true(result == 999)
    result <- sql_get_initials_from_author_name("Maja Založnik", con, schema = "test_platform")
    expect_true(result == "MZ")
    result <- sql_get_email_from_author_initials("MZ", con, schema = "test_platform")
    expect_type(result, "character")
    expect_length(result, 1)
    expect_false(is.na(result))
    expect_match(result, "^[[:alnum:].-_]+@[[:alnum:].-]+$")
    result <- sql_get_all_series_wtable_names(con, schema = "test_platform")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("table_code", "table_name", "series_code",
                           "series_name", "unit", "interval_id"))
    expect_true(nrow(result) == 14859)
    result <- sql_get_level_value_from_text(7L, "Originalni podatki", con, schema = "test_platform")
    expect_equal(result, "N")
    result <- sql_get_time_dimension_from_table_code("0400600S", con, schema = "test_platform")
    expect_equal(result, "MESEC")
    result <- sql_get_last_publication_date_from_table_id(21L, con, schema = "test_platform")
    expect_s3_class(result, "POSIXct")
    expect_true(length(result) > 0)
    sql_get_date_published_from_vintage( 363L, con, schema = "test_platform")
    expect_s3_class(result, "POSIXct")
    expect_true(length(result) > 0)
    result <- sql_get_non_time_dimensions_from_table_id(21L, con, schema = "test_platform")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("dimension", "id"))
    expect_type(result$dimension, "character")
    expect_type(result$id, "double")  # bigint comes back as double
    expect_true(nrow(result) == 2)
    result <- sql_get_dimension_id_from_table_id_and_dimension(
      20L, "MERITVE", con, schema = "test_platform")
    expect_type(result, "double")
    expect_equal(result, 63)
    result <- sql_get_levels_from_dimension_id(47L, con, schema = "test_platform")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("tab_dim_id", "level_value", "level_text"))
    expect_true(nrow(result) == 2)
    expect_type(result$tab_dim_id, "integer")
    expect_type(result$level_value, "character")
    expect_type(result$level_text, "character")
    result <- sql_get_dimensions_from_table_id(20L, con, schema = "test_platform")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("id", "table_id", "dimension", "is_time"))
    expect_type(result$id, "double")
    expect_type(result$table_id, "integer")
    expect_type(result$dimension, "character")
    expect_type(result$is_time, "logical")
    expect_true(nrow(result) > 0)
    if (nrow(result) > 1) {
      expect_true(all(diff(result$id) > 0))
    }
    result <- sql_get_series_from_table_id(20L, con, schema = "test_platform")
    expect_s3_class(result, "data.frame")
    expect_named(result, c("id", "table_id", "name_long", "unit_id",
                           "code", "interval_id", "live"))
    expect_type(result$id, "double")
    expect_type(result$table_id, "integer")
    expect_type(result$name_long, "character")
    expect_type(result$unit_id, "integer")
    expect_type(result$code, "character")
    expect_type(result$interval_id, "character")
    expect_type(result$live, "logical")
    expect_true(nrow(result) > 0)
    if (nrow(result) > 1) {
      expect_true(all(diff(result$id) > 0))}
  })
dbDisconnect(con)
})
