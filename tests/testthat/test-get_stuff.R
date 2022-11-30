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
    expect_equal(out[1,1], "indeks")
    out <- get_series_name(1625, con)
    expect_equal(nchar(out[1,1]), 103)
    expect_true(grepl("storitvene dejavnosti", out[1,1]))
  })
})
`use_coverage(type = c("codecov"))`
`usethis::use_github_action("test-coverage")`
