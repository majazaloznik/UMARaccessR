library(testthat)
library(dittodb)

make_test_connection <- function() {
  con <- DBI::dbConnect(RPostgres::Postgres(),
                 dbname = "platform",
                 host = "localhost",
                 port = 5433,
                 user = "postgres",
                 password = Sys.getenv("PG_local_15_PG_PSW"))
  # DBI::dbExecute(con, "set search_path to test_platform")

}
