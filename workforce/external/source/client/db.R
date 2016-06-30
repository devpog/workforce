# db_get_hub_id <- function(host, port = 9160, keyspace, name){
#   drv <- JDBC(db_drv, jars)
#   conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
#   query <- paste0("select id from hub where hub = \'", name, "\' limit 1")
#   df <- dbGetQuery(conn, query)
#   dbDisconnect(conn)
# return(df)
# }

db_get_hub_name <- function(host, port = 9160, keyspace, name){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  query <- paste0("select hub from client where client = \'", name, "\'")
  df <- dbGetQuery(conn, query)
  dbDisconnect(conn)
  return(df)
}

db_get_hub_all <- function(host, port = 9160, keyspace){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  query <- paste0("select hub from hub")
  df <- dbGetQuery(conn, query)
  dbDisconnect(conn)
  return(df)
}

db_read_table_client <- function(host, port = 9160, keyspace, hub, all = F){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  if(!all){
    query <- paste0("select * from hub_client where hub = \'", hub, "\'")
  } else {
    query <- paste0("select * from hub_client")
  }
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  return(df)
}


db_insert_row_client <- function(host, port = 9160, keyspace, client, hub){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("insert into client (client, hub) values (", 
                  "\'", client, "\', ",
                  "\'", hub, "\'", ")")
  dbSendUpdate(conn, query)

  query <- paste0("insert into hub_client (hub, client) values (", 
                  "\'", hub, "\', ",
                  "\'", client, "\'", ")")
  dbSendUpdate(conn, query)
  
  dbDisconnect(conn)
}

db_delete_row_client <- function(host, port = 9160, keyspace, client, hub){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  query <- paste0("delete from client where client = \'", client, "\'", 
                  "and hub = \'", hub, "\'")
  
  dbSendUpdate(conn, query)
  
  query <- paste0("delete from hub_client where client = \'", client, "\'", 
                  "and hub = \'", hub, "\'")
  
  dbSendUpdate(conn, query)
  
  dbDisconnect(conn)
}