dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "sandbox",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"))
  DBI::dbExecute(con, "set search_path to test_platform")

  test_that("mock tests for get_stuff", {
    out <- get_unit(1625, con)
    expect_equal(out, "indeks")
    out <- get_unit(2532, con)
    expect_true(is.na(out))
    out <- get_series_name(1625, con)
    expect_true(grepl("storitvene dejavnosti", out[1,1]))
    out <- get_table_name(1625, con)
    expect_true(grepl("Indeksi nominalnega", out[1,1]))
    out <- get_data_points(1625, con)
    expect_true(all(dim(out)==c(272, 3)))
    out <- get_interval(1625, con)
    expect_equal(out, "M")
  })
})

