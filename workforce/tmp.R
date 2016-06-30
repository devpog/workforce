library(RJDBC)

db_host <- '127.0.0.1'
db_port <- 9160
db_keyspace <- 'cognitive'

# cassandra_files <- list.files('/usr/lib/cassandra-jdbc/', pattern = "jar$", full.names = T)
cass_files <- list.files('lib', pattern = "jar$", full.names = T)
cass_drv <- JDBC("org.apache.cassandra.cql.jdbc.CassandraDriver", classPath = cass_files, identifier.quote = "'")
conn <- dbConnect(cass_drv, paste0("jdbc:cassandra://localhost:9160/", db_keyspace))

conn <- dbConnect(cass_files, "Database=cognitive;Port=9160;Server=127.0.0.1")
df <- as.data.frame(dbGetQuery(conn, "select * from hub"))
dbDisconnect(conn)
