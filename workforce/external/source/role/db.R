db_get_role_id <- function(host, port = 9160, keyspace, name){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  query <- paste0("select id from role where role = \'", name, "\' limit 1")
  df <- dbGetQuery(conn, query)
  dbDisconnect(conn)
  return(df)
}

db_insert_row_role <- function(host, port = 9160, keyspace, name){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("insert into role (role, id)", 
                  " values (", 
                  "\'", name, "\', now())"
                  )
  dbSendUpdate(conn, query)
dbDisconnect(conn)
}

db_delete_row_role <- function(host, port = 9160, keyspace, name){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  role_id <- db_get_role_id(host, port, keyspace, name)
  
  query <- paste0("delete from role where role = \'", name, "\' and id = ", role_id)
  print(query)  
  dbSendUpdate(conn, query)
dbDisconnect(conn)
}

db_select_column_role <- function(host, port = 9160, keyspace, columns = NULL, column, value){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(is.null(columns)){
    df <- as.data.frame(dbGetQuery(conn, paste0("select * from role", # select hub from client where name = 'AllState';
                                                " where ", column, 
                                                " = \'", value, "\'"
                        )))
  } else {
    if(length(columns) == 1)
      columns <- paste0(columns)
    else
      columns <- paste0(columns, collapse = ",")
    
    df <- as.data.frame(dbGetQuery(conn, paste0("select ", columns, " from role ", # select hub from client where name = 'AllState';
                                                " where ", column, 
                                                " = \'", value, "\'"
                        )))
  }
  
dbDisconnect(conn)
return(df)
}