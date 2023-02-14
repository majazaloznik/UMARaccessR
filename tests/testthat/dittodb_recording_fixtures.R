library(DBI)
library(RPostgres)
library(dittodb)
#
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# get_unit_from_vintage(1625, con)
# stop_db_capturing()
#
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# get_unit_from_series(1625, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_series_name_from_vintage(1625, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_series_name_from_series(1625, con)
# stop_db_capturing()
#
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_table_name_from_vintage(1625, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_table_name_from_series(1625, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_data_points_from_vintage(1625, con)
# stop_db_capturing()
#
#
# # field set to NULL
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_unit(2532, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_interval_from_vintage(1625, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_interval_from_series(1625, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_vintage_from_series(2389, con)
# stop_db_capturing()
#
#
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- prep_single_line(1625, con)
# stop_db_capturing()
#
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_date_published_from_vintage(1625, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_last_period_from_vintage (351, con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_last_period_from_vintage (1625, con)
# stop_db_capturing()
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_vintage_from_series_code("SURS--1700104S--2--2--Q", con)
# stop_db_capturing()
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_source_code_from_source_name ("MF", con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_table_id_from_table_code("DP", con)
# stop_db_capturing()
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_dim_id_from_table_id(24, "Konto", con)
# stop_db_capturing()

# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_unit_id_from_unit_name("eur", con)
# stop_db_capturing()

# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_unit_id_from_unit_name("eur", con)
# stop_db_capturing()

