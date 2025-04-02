source("tests/testthat/helper-connection.R")
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
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5433,
#                       user = "postgres",
#                       password = Sys.getenv("PG_local_15_PG_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_series_name_from_series(1625, con)
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
# start_db_capturing()
# con <- dbConnect(RPostgres::Postgres(),
#                  dbname = "sandbox",
#                  host = "localhost",
#                  port = 5432,
#                  user = "mzaloznik",
#                  password = Sys.getenv("PG_local_MAJA_PSW"))
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_series_ids_from_table_id(24, con)
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
# out <- get_series_name_from_series_code("MF--ZZZS--003--70--A", con)
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
# out <- get_max_category_id_for_source(2, con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_series_id_from_series_code("UMAR--MZ001--234--M", con)
# stop_db_capturing()
# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_initials_from_author_name("Maja Zalo\u017enik", con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_metadata_from_author_name("Matev\u017e Hribernik", con)
# stop_db_capturing()

# start_db_capturing()
# con <- DBI::dbConnect(RPostgres::Postgres(),
#                       dbname = "platform",
#                       host = "localhost",
#                       port = 5432,
#                       user = "mzaloznik",
#                       password = Sys.getenv("PG_local_MAJA_PSW"),
#                       client_encoding = "utf8")
# dbExecute(con, "set search_path to test_platform")
# on.exit(dbDisconnect)
# out <- get_email_from_author_initials("MZ", con)
# stop_db_capturing()
#
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_unit_from_vintage(con, 361L, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_unit_from_series(con, 32421L, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_series_name_from_vintage(con, 361L, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_series_name_from_series(con, 361L, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_series_name_from_series_code(con, "SURS--1701102S--orig--C[skd]--M", schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_table_name_from_vintage(con, 361L, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_table_name_from_series(con, 32421L, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_interval_from_vintage(con, 361L, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_interval_from_series(con, 32421L, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_vintage_from_series(
#   con, 361L,
#   date_valid = as.POSIXct("2024-01-01"),
#   schema = "test_platform")
# sql_get_vintage_from_series(
#   con, c(361, 362, 363),
#   date_valid = as.POSIXct("2024-01-01"),
#   schema = "test_platform")
# ids <- data.frame(id = c(361, 362, 363))
# sql_get_vintage_from_series(
#   con, ids$id ,
#   date_valid = as.POSIXct("2024-01-01"),
#   schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
#
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_vintage_from_series_code(con, "SURS--0300220S--BTE--V--N--Q",
#                                  date_valid = as.POSIXct("2024-01-01"),
#                                  schema = "test_platform")
#
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_data_points_from_vintage(con, 361L, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_data_points_from_series_id(con, 361L,
#                                 date_valid = as.Date("2023-03-01"),
#                                 schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_last_period_from_vintage(con, 361L, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_source_code_from_source_name(con, "SURS", schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_table_id_from_table_code(con, "0400600S", schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_tab_dim_id_from_table_id_and_dimension(
#   20L, "MERITVE", con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_unit_id_from_unit_name("mio eur", con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
# start_db_capturing()
# con <- make_test_connection()
# sql_get_unit_id_from_unit_name("", con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()

# start_db_capturing()
# con <- make_test_connection()
# sql_get_series_ids_from_table_id(21L, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_dimension_levels_from_table_id(21L, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_series_id_from_series_code("SURS--1700102S--1--6--M", con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()

# start_db_capturing()
# con <- make_test_connection()
# sql_get_series_id_from_series_code(c("SURS--1700102S--1--6--M",
#                                      "SURS--1700102S--1--6--M"),
#                                    con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_max_category_id_for_source(1L, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()

# start_db_capturing()
# con <- make_test_connection()
# sql_get_initials_from_author_name("Maja Založnik", con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_email_from_author_initials("MZ", con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# result <- sql_get_all_series_wtable_names(con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_level_value_from_text(7L, "Originalni podatki", con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_time_dimension_from_table_code("0400600S", con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_last_publication_date_from_table_id(21L, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()

# start_db_capturing()
# con <- make_test_connection()
# dbExecute(con, "set search_path to test_platform")
# get_vintage_from_series_code("SURS--1700104S--2--2--Q", con)
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_date_published_from_vintage(363L, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_non_time_dimensions_from_table_id(21L, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_dimension_id_from_table_id_and_dimension(
#   20L, "MERITVE", con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_levels_from_dimension_id(47L, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# series_ids <-  c(1895, 361)
# dates_valid <- as.Date("2023-03-25")
# for(sid in series_ids) {
#   result <- mock_get_data_points_from_series_id(con, sid, NULL, dates_valid,
#                                                 schema = "test_platform")
#   print(sprintf("Recorded series %d current data with %d rows",
#                 sid, nrow(result)))}
# for(sid in series_ids) {
#   result <- mock_get_data_points_from_series_id(con, sid, "test", schema = "test_platform")
#   print(sprintf("Recorded series %d current data with %d rows",
#                 sid, nrow(result)))}
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# result <- sql_get_dimensions_from_table_id(20L, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_series_from_table_id(20L, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_dimension_position_from_table(15L, "EKONOMSKI KAZALNIKI", con, schema = "test_platform")
# sql_get_dimension_position_from_table(15L, "NONEXISTENT", con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_tables_with_keep_vintage(TRUE, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_tables_with_keep_vintage(FALSE, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# sql_get_category_id_from_name("Podjetja", con, source_id = 1, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
# start_db_capturing()
# con <- make_test_connection()
# x <- sql_get_vintages_with_hashes_from_series_id(1917, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()
#
#
# start_db_capturing()
# con <- make_test_connection()
# x <- sql_get_table_info(20, con, schema = "test_platform")
# DBI::dbDisconnect(con)
# stop_db_capturing()


