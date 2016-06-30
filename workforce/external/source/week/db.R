db_get_hubs_week <- function(host, port = 9160, keyspace){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  clients <- db_read_table_week(db_host, db_port, db_keyspace)[, "client"]
  hubs <- vector()
  for(client in clients){
    hubs <- append(hubs, db_get_hubs_from_client(host, port, keyspace, client))
  }
  
  dbDisconnect(conn)
return(hubs)
}

db_get_hubs_from_client <- function(host, port = 9160, keyspace, client){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  query <- paste0("select hub from client where client = \'", client, "\'")
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  return(df[, "hub"])
}

db_read_table_week <- function(host, port = 9160, keyspace, all = T){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(all){
    query <- paste0('select * from week')
  } else {
    query <- paste0('select client from week')
  }
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  
return(df)
}

db_read_table_week_by_hub <- function(host, port = 9160, keyspace, all = T){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(all){
    query <- paste0('select * from week')
  } else {
    clients <- (db_read_table(db_host, db_port, db_keyspace, 'client') %>% filter(hub == week_hub()) %>% select(client))[, "client"]
    query <- paste0("select * from week where client in ('", paste(clients, collapse = "','"), "')")
  }
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  
  return(df)
}

db_insert_row_week <- function(host, port = 9160, keyspace, name, hub){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  hub_id <- db_get_hub_id(host, port, keyspace, hub)
  
  query <- paste0("insert into week (week, hub, id, hub_id) values (", 
                  "\'", name, "\', ",
                  "\'", hub, "\', ",
                  "now(), ", 
                  hub_id, ")"
  )

  dbSendUpdate(conn, query)
  dbDisconnect(conn)
}

db_delete_row_week <- function(host, port = 9160, keyspace, name, hub){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  query <- paste0("delete from week where week = \'", name, "\'", 
                  "and hub = \'", hub, "\'")
  
  dbSendUpdate(conn, query)
  dbDisconnect(conn)
}