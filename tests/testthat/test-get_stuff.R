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
    out <- get_date_published_from_vintage(1625, con)
    expect_equal(out[1,1], as.POSIXct("2022-10-27 10:30:00",  tz = "CET"))
    out <- get_last_period_from_vintage (1625, con)
    expect_equal(out[1,1], "2022M09")
    out <- get_last_period_from_vintage (351, con)
    expect_equal(out[1,1], as.character(NA))
  })
})

