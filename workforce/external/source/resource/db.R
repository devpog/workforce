db_read_table_name_resource <- function(host, port = 9160, keyspace, full_name = NULL){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(!is.null(full_name)){
    query <- paste0("select * from name_resource where last_name = \'", 
                    full_name[1], 
                    "\' and first_name = \'", 
                    full_name[2], "\'")
  } else {
    query <- paste0("select * from name_resource")
  }
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  return(df)
}

db_read_table_resource <- function(host, port = 9160, keyspace, hub = NULL){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(!is.null(hub)){
    query <- paste0("select * from resource where hub = \'", hub, "\'")
  } else {
    query <- paste0("select * from resource")
  }
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  return(df)
}

db_insert_row_resource <- function(host, port = 9160, keyspace, values){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  first_name <- values[1]
  last_name <- values[2]
  system_name <- create_system_name(first_name, last_name)
  hub <- values[3]
  role <- values[4]

  query <- paste0("insert into resource (system_name, hub, first_name, last_name, role) values (", 
                  "\'", system_name, "\', ",
                  "\'", hub, "\', ",
                  "\'", first_name, "\', ",
                  "\'", last_name, "\', ",
                  "\'", role, "\')")
  print(query)
  dbSendUpdate(conn, query)
  query <- paste0(
    "insert into hub_resource (hub, system_name) values (",
    "\'", hub, "\', ",
    "\'", system_name, "\')"
  )
  dbSendUpdate(conn, query)
  
  query <- paste0(
    "insert into role_resource (role, system_name) values (",
    "\'", role, "\', ",
    "\'", system_name, "\')"
  )
  dbSendUpdate(conn, query)

  query <- paste0(
    "insert into name_resource (last_name, first_name, system_name) values (",
    "\'", last_name, "\', ",
    "\'", first_name, "\', ",
    "\'", system_name, "\')"
  )
  dbSendUpdate(conn, query)
  
dbDisconnect(conn)
}

db_delete_row_resource <- function(host, port = 9160, keyspace, system_name, first_name, last_name){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  hub <- resource_hub()
  role <- resource_role()
  
  query <- paste0("delete from resource ",
                  "where system_name = \'", 
                  system_name, "\' and hub = \'",
                  hub, "\'")
  print(query)
  dbSendUpdate(conn, query)
  
  query <- paste0("delete from hub_resource where system_name = \'", system_name, "\' and ",
                  "hub = \'", hub, "\'")
  print(query)
  dbSendUpdate(conn, query)
  
  query <- paste0("delete from role_resource where system_name = \'", system_name, "\' and ",
                  "role = \'", role, "\'")
  print(query)
  dbSendUpdate(conn, query)
  
  query <- paste0("delete from name_resource where system_name = \'", system_name, "\' and ",
                  "first_name = \'", first_name, "\' and ",
                  "last_name = \'", last_name, "\'")
  print(query)
  dbSendUpdate(conn, query)
  
  
dbDisconnect(conn)
}

db_select_column_resource <- function(host, port = 9160, keyspace, columns = NULL, column, value){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(is.null(columns)){
    df <- as.data.frame(dbGetQuery(conn, paste0("select * from resource",
                                                " where ", column, 
                                                " = \'", value, "\'"
                        )))
  } else {
    if(length(columns) == 1)
      columns <- paste0(columns)
    else
      columns <- paste0(columns, collapse = ",")
    
    df <- as.data.frame(dbGetQuery(conn, paste0("select ", columns, " from resource ",
                                                " where ", column, 
                                                " = \'", value, "\'"
                        )))
  }
  
dbDisconnect(conn)
return(df)
}

db_select_resource <- function(host, port = 9160, keyspace, query){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
    df <- as.data.frame(dbGetQuery(conn, query))
dbDisconnect(conn)
return(df)
}