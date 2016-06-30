observeEvent(input$resource_new_go, {
  values <- c(resource_new_fname(), resource_new_lname(), resource_new_hub(), resource_new_role())
  db_insert_row_resource(db_host, db_port, db_keyspace, values)
  
  updateTextInput(session, "resource_new_fname", value = NULL)
  updateTextInput(session, "resource_new_lname", value = NULL)
})

observeEvent(input$resource_change_go, {
  values <- c(resource_change_fname(), resource_change_lname(), resource_change_hub(), resource_change_role())
  #db_insert_row_resource(db_host, db_port, db_keyspace, values)
  
  updateTextInput(session, "resource_change_fname", value = NULL)
  updateTextInput(session, "resource_change_lname", value = NULL)
})

observeEvent(input$resource_del_go, {
  resources <- resource_del_name()
  system_names <- data.frame()
  for(resource in resources){
    full_name <- str_trim(unlist(str_split(resource, ",")), side = "both")
    system_name <- as.data.frame(db_read_table_name_resource(db_host, db_port, db_keyspace, full_name))
    
    system_names <- rbind(
      system_names,
      system_name      
    )}
  
  apply(system_names, 1, function(x){
    last_name = x[1]
    first_name = x[2]
    system_name = x[3]
    db_delete_row_resource(db_host, db_port, db_keyspace, system_name, last_name, first_name)
  })

  data <- resource_data() %>% filter(hub == resource_hub()) %>% filter(role == resource_role())
  choices <- sort(unique(with(data, paste(last_name, first_name, sep = ", "))))
  updateCheckboxGroupInput(session, "resource_del_name", label = NULL, choices = choices)
})

resource_data_del <- eventReactive(input$resource_del_go, {
  db_read_table(db_host, db_port, db_keyspace, 'resource')
})