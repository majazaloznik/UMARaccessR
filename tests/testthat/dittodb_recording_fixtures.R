library(DBI)
library(RPostgres)
library(dittodb)


start_db_capturing()
con <- dbConnect(RPostgres::Postgres(),
                 dbname = "sandbox",
                 host = "localhost",
                 port = 5432,
                 user = "mzaloznik",
                 password = Sys.getenv("PG_local_MAJA_PSW"))
dbExecute(con, "set search_path to test_platform")
on.exit(dbDisconnect)
get_unit(1625, con)
stop_db_capturing()



start_db_capturing()
con <- dbConnect(RPostgres::Postgres(),
                 dbname = "sandbox",
                 host = "localhost",
                 port = 5432,
                 user = "mzaloznik",
                 password = Sys.getenv("PG_local_MAJA_PSW"))
dbExecute(con, "set search_path to test_platform")
on.exit(dbDisconnect)
out <- get_series_name(1625, con)
stop_db_capturing()

start_db_capturing()
con <- dbConnect(RPostgres::Postgres(),
                 dbname = "sandbox",
                 host = "localhost",
                 port = 5432,
                 user = "mzaloznik",
                 password = Sys.getenv("PG_local_MAJA_PSW"))
dbExecute(con, "set search_path to test_platform")
on.exit(dbDisconnect)
out <- get_table_name(1625, con)
stop_db_capturing()


