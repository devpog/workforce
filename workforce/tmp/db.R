db_insert_row_role <- function(host, port = 9160, keyspace, name){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("insert into role (name)", 
                  " values (", 
                  "\'", name, "\')"
                  )
  dbSendUpdate(conn, query)
dbDisconnect(conn)
}

db_delete_row_role <- function(host, port = 9160, keyspace, names){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  for(value in values){
    query <- paste0("delete from role",
                    " where name ",
                    " in (\'", value, "\')")
    
    dbSendUpdate(conn, query)
  }
  
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