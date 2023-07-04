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
    expect_equal(out[1,1], 1898)
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
  })
})


