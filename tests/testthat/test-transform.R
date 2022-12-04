test_that("transform works fine", {
  df <- data.frame(period_id = c("2022M02", "2022M13"))
  out <- add_date_from_period_id(df, "M")
  expect_warning(add_date_from_period_id(df, "M"))
  expect_equal(out$period[1], as.Date("2022-02-01"))
  df <- data.frame(period_id = c("2022Q02"))
  out <- add_date_from_period_id(df, "Q")
  expect_equal(out$period[1], as.Date("2022-04-01"))
})
