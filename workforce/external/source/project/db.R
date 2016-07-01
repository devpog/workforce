db_project_get_role_choices <- function(host = db_host, port = db_port, keyspace = db_keyspace, role = NULL){
  if(!is.null(role)){
  return(
    append("None", sort(with(db_get_resources(host, port, keyspace, role)[, c("first_name", "last_name")], 
                           paste(last_name, first_name, sep = ", "))))
    )
  } else {
    roles <- c()
    for(r in global_roles){
      roles <- append(
        roles,
        append("None", sort(with(db_get_resources(host, port, keyspace, role)[, c("first_name", "last_name")], 
                                 paste(last_name, first_name, sep = ", "))))
      )  
    }
    return(unique(roles))
  }
}

db_project_get_resources <- function(host, port = 9160, keyspace){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  query <- paste0("select * from name_resource")
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  
  return(df)
}

db_project_get_clients <- function(host, port = 9160, keyspace, hub = NULL){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(!is.null(hub)){
    query <- paste0("select * from hub_client where hub = \'", hub, "\'")
  } else {
    query <- paste0("select * from hub_client")
  }
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  
  return(df)
}

db_get_project_details <- function(host, port = 9160, keyspace, client, phase){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("select * from project where client =\'", client, "\' and phase = \'", phase, "\'")
  project <- as.data.frame(dbGetQuery(conn, query))
  
  query <- paste0("select * from hub_client")
  hub_client <- as.data.frame(dbGetQuery(conn, query))
  
  query <- paste0("select * from role_project where client =\'", client, "\' and phase = \'", phase, "\'")
  role_project <- as.data.frame(dbGetQuery(conn, query))
  
  query <- paste0("select * from dedication_project where client =\'", client, "\' and phase = \'", phase, "\'")
  dedication_project <- as.data.frame(dbGetQuery(conn, query))
  
  query <- paste0("select * from resource_project where client =\'", client, "\' and phase = \'", phase, "\'")
  resource_project <- as.data.frame(dbGetQuery(conn, query))
  
  query <- paste0("select * from name_resource")
  name_resource <- as.data.frame(dbGetQuery(conn, query))
  
  query <- paste0("select * from hub_resource")
  hub_resource <- as.data.frame(dbGetQuery(conn, query))
  
  dbDisconnect(conn)
  
  df <- join(resource_project, hub_client)
  df <- left_join(df, name_resource, "system_name")

  df[is.na(df)] <- "None"
  df <- left_join(df, hub_resource, "system_name") %>% 
    transmute(hub_client = hub.x, hub_resource = ifelse(is.na(hub.y), hub.x, hub.y), client, role, system_name, last_name, first_name)
  
  df <- left_join(df, dedication_project, "role") %>% 
    transmute(hub_client, client = client.x, phase, role, hub_resource, system_name, first_name, last_name, dedication)

  df <- left_join(df, project, "client") %>%
    transmute(hub_client, client, phase = phase.x, 
              start_date = as.Date(strptime(start_date, format = "%a")), 
              end_date = as.Date(strptime(end_date, format = "%a")), 
              active, completed,
              role, hub_resource,
              system_name, full_name = paste(first_name, last_name), 
              dedication)
  return(df)
}

db_get_active_projects <- function(host, port = 9160, keyspace){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  query <- paste0("select * from project where active = true")
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  return(df)
}

db_project_get_full_name <- function(host, port = 9160, keyspace, system_names){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  df <- data.frame()
  for(system_name in system_names){
    query <- paste0("select * from name_resource where system_name = \'", system_name, "\'")
    df <- rbind(df, as.data.frame(dbGetQuery(conn, query)))
  }
  dbDisconnect(conn)
  
  return(df)
}

db_project_get_resource <- function(host, port = 9160, keyspace, client){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  phase <- db_project_get_phase_2(host, port, keyspace, client)[, "phase"]
  query <- paste0("select * from resource_project where client = ", 
                  "\'", client, "\' and phase = \'", phase, "\'")
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  
  return(df)
}

db_project_get_dedication <- function(host, port = 9160, keyspace, client){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  phase <- db_project_get_phase_2(host, port, keyspace, client)[, "phase"]
  query <- paste0("select * from dedication_project where client = ", 
                  "\'", client, "\' and phase = \'", phase, "\'")
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  
  return(df)
}

db_project_get_phase_2 <- function(host, port = 9160, keyspace, client){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("select * from project where client = \'", client, "\'")
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  
  return(df)
}

db_project_get_role <- function(host, port = 9160, keyspace, client){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  phase <- db_project_get_phase_2(host, port, keyspace, client)[, "phase"]
  query <- paste0("select * from role_project where client = ", 
                  "\'", client, "\' and phase = \'", phase, "\'")
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  
  return(df)
}

db_project_get_active <- function(host, port = 9160, keyspace, client){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("select * from project where client = ", 
                  "\'", client, "\' and completed = false")
  
  df <- as.data.frame(dbGetQuery(conn, query))[, "active"]
  dbDisconnect(conn)
  if(df == 'true')
    return(TRUE)
  else if(df == 'false')
    return(FALSE)
}

db_project_get_phase <- function(host, port = 9160, keyspace, client){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("select * from project where client = ", 
                  "\'", client, "\' and completed = false")
  
  df <- as.data.frame(dbGetQuery(conn, query))[, "phase"]
  dbDisconnect(conn)
  return(df)
}

db_project_get_start_date <- function(host, port = 9160, keyspace, client, phase){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("select * from project where client = ", 
                  "\'", client, "\'", 
                  " and phase = \'", phase, "\'")
  
  df <- as.data.frame(dbGetQuery(conn, query))[, "start_date"]
  dbDisconnect(conn)
return(df)
}

db_project_get_end_date <- function(host, port = 9160, keyspace, client, phase){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("select * from project where client = ", 
                  "\'", client, "\'", 
                  " and phase = \'", phase, "\'")
  
  df <- as.data.frame(dbGetQuery(conn, query))[, "end_date"]
  dbDisconnect(conn)
return(df)
}

db_get_resources <- function(host, port = 9160, keyspace, role){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("select * from resource where role = \'", role, "\'")
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  return(df)
}

db_get_hubs_from_client <- function(host, port = 9160, keyspace, client){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  query <- paste0("select hub from client where client = \'", client, "\'")
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  return(df[, "hub"])
}

db_read_table_project <- function(host, port = 9160, keyspace, all = T){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(all){
    query <- paste0('select * from project')
  } else {
    query <- paste0('select client from project')
  }
  
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  
  if(!project_show_all_phases()){
    df <- filter(df, phase == project_phase())
  }
  
  if(project_show_all_active()){
    df <- filter(df, active == "true")
  }
  
  if(project_show_all_completed()){
    df <- filter(df, completed == "true")
  }
  
return(df)
}

db_read_table_project_by_hub <- function(host, port = 9160, keyspace, hub){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0("select * from hub_client where hub = \'", hub, "\'")
  clients <- as.data.frame(dbGetQuery(conn, query))[, "client"]
  
  query <- paste0("select * from project where client in (\'", paste(clients, collapse = "\',\'", sep = "\'"), "\')")
  df <- as.data.frame(dbGetQuery(conn, query))
  dbDisconnect(conn)
  
  if(!project_show_all_phases()){
    df <- filter(df, phase == project_phase())
  }
  
  if(project_show_all_active()){
    df <- filter(df, active == "true")
  }
  
  if(project_show_all_completed()){
    df <- filter(df, completed == "true")
  }
  
return(df)
}

db_insert_row_project <- function(host, port = 9160, keyspace, client, phase, start_date, end_date, active){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))

  if(!is.null(end_date)){
    d_start <- as.Date(start_date)
    d_end <- as.Date(end_date)
    d_today <- Sys.Date()
    if(d_today > end_date)
      completed <- "true"
    else
      completed <- "false"
  }
  
  query <- paste0(
    "insert into project (client, phase, start_date, end_date, active, completed) values (", 
    "\'", client, "\', ",
    "\'", phase, "\', ",
    "\'", start_date, "\', ",
    "\'", end_date, "\', ",
    active, ", ",
    completed, ")")

  dbSendUpdate(conn, query)
  dbDisconnect(conn)
}

db_insert_row_pr_dedication <- function(host, port = 9160, keyspace, client, phase, role, dedication){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0(
    "insert into dedication_project (client, phase, role, dedication) values (",
    "\'", client, "\', ",
    "\'", phase, "\', ",
    "\'", role, "\', ",
    dedication, ")")
  
  dbSendUpdate(conn, query)
  dbDisconnect(conn)
}

db_insert_row_pr_role <- function(host, port = 9160, keyspace, client, phase, role, count){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  query <- paste0(
    "insert into role_project (client, phase, role, count) values (",
    "\'", client, "\', ",
    "\'", phase, "\', ",
    "\'", role, "\', ",
    count, ")")
  
  dbSendUpdate(conn, query)
  dbDisconnect(conn)
}

db_insert_row_pr_resource <- function(host, port = 9160, keyspace, client, phase, full_name, role){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  
  if(full_name != "None"){
    full_name <- str_trim(unlist(str_split(full_name, ",")), "both")
    query <- paste0(
      "select * from name_resource where first_name = \'",
      full_name[2], "\' and last_name = \'", full_name[1], "\'")
    system_name <- dbGetQuery(conn, query)[, "system_name"]
  } else {
    system_name <- full_name
  }
  
  query <- paste0(
    "insert into resource_project (client, phase, system_name, role) values (",
    "\'", client, "\', ",
    "\'", phase, "\', ",
    "\'", system_name, "\', ",
    "\'", role, "\')")
  
  dbSendUpdate(conn, query)
  dbDisconnect(conn)
}

db_delete_row_project <- function(host, port = 9160, keyspace, name, hub){
  drv <- JDBC(db_drv, jars)
  conn <- dbConnect(drv, paste0("jdbc:cassandra://localhost:9160/", keyspace))
  query <- paste0("delete from project where project = \'", name, "\'", 
                  "and hub = \'", hub, "\'")
  
  dbSendUpdate(conn, query)
  dbDisconnect(conn)
}