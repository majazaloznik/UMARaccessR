test_that("transform works fine", {
  df <- data.frame(period_id = c("2022M02", "2022M13"))
  out <- add_date_from_period_id(df, "M")
  expect_warning(add_date_from_period_id(df, "M"))
  expect_equal(out$period[1], as.Date("2022-02-01"))
  df <- data.frame(period_id = c("2022Q02"))
  out <- add_date_from_period_id(df, "Q")
  expect_equal(out$period[1], as.Date("2022-04-01"))

})

dittodb::with_mock_db({
  con <- DBI::dbConnect(RPostgres::Postgres(),
                        dbname = "sandbox",
                        host = "localhost",
                        port = 5432,
                        user = "mzaloznik",
                        password = Sys.getenv("PG_local_MAJA_PSW"))
  DBI::dbExecute(con, "set search_path to test_platform")

  test_that("mock tests for prepping data for plot", {
    out <- prep_single_line(1625, con)
    expect_equal(length(out), 7)
    expect_equal(dim(out[[1]]), c(273, 3))
  })
})


