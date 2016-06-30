db_read_table_hub <- function(host, port = 9160, keyspace, columns = NULL){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(is.null(columns)){
    df <- as.data.frame(dbGetQuery(conn, paste0("select * from hub")))
  } else {
    df <- as.data.frame(
      dbGetQuery(conn, 
                 paste0(
                   "select ", 
                   paste(columns, collapse = ","),
                   " from hub"
                 )
      ))
  }
  dbDisconnect(conn)
  return(df)
}

db_insert_row_hub <- function(host, port = 9160, keyspace, name){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("insert into hub (hub)", 
                  " values (",
                  "\'", name, "\')"
  )
  dbSendUpdate(conn, query)
  dbDisconnect(conn)
}

db_delete_row_hub <- function(host, port = 9160, keyspace, values){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  for(value in values){
    query <- paste0("delete from hub",
                    " where hub ",
                    " in (\'", value, "\')")
    
    print(query)
    dbSendUpdate(conn, query)
  }
  
  dbDisconnect(conn)
}

db_select_column_hub <- function(host, port = 9160, keyspace, columns = NULL, column, value){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(is.null(columns)){
    df <- as.data.frame(dbGetQuery(conn, paste0("select * from hub",
                                                " where ", column, 
                                                " = \'", value, "\'"
    )))
  } else {
    if(length(columns) == 1)
      columns <- paste0(columns)
    else
      columns <- paste0(columns, collapse = ",")
    
    df <- as.data.frame(dbGetQuery(conn, paste0("select ", columns, " from hub ",
                                                " where ", column, 
                                                " = \'", value, "\'"
    )))
  }
  
  dbDisconnect(conn)
  return(df)
}