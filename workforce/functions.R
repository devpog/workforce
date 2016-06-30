create_system_name <- function(first_name, last_name){
  return(
    tolower(paste0(str_sub(first_name, 1, 1), last_name))
  )
}

db_select_column <- function(host, port = 9160, keyspace, table, columns = NULL, column, value){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(is.null(columns)){
    df <- as.data.frame(dbGetQuery(conn, paste0("select * from ", table, # select hub from client where name = 'AllState';
                                                " where ", column, 
                                                " = \'", value, "\'"
                                                )
                                   ))
  } else {
    df <- as.data.frame(dbGetQuery(conn, paste0("select ", columns, " from ", table, # select hub from client where name = 'AllState';
                                                " where ", column, 
                                                " = \'", value, "\'"
    )
    ))
  }
  dbDisconnect(conn)
  return(df)
}


db_read_table <- function(host, port = 9160, keyspace, table, columns = NULL){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))

  if(is.null(columns)){
    df <- as.data.frame(dbGetQuery(conn, paste0("select * from ", table)))
  } else {
    df <- as.data.frame(
      dbGetQuery(conn, 
                 paste0(
                   "select ", 
                   paste(columns, collapse = ","),
                   " from ",
                   table
                 )
      ))
  }
  dbDisconnect(conn)
return(df)
}

db_insert_row <- function(host, port = 9160, keyspace, table, name, value){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("insert into ", 
                  table, 
                  " (", 
                  name, 
                  ") values (", 
                  "\'",
                  value, "\'",
                  ")")
  print(query)
  
  dbSendUpdate(conn, query)
  dbDisconnect(conn)
}

db_delete_row <- function(host, port = 9160, keyspace, table, column, values){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  for(value in values){
    query <- paste0("delete from ", table,
                    " where ", column, 
                    " in (\'", value, "\')")
      
    print(query)
    
    dbSendUpdate(conn, query)
  }
  dbDisconnect(conn)
}