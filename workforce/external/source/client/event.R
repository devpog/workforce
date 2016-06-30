observeEvent(input$client_new_go, {
  db_insert_row_client(db_host, db_port, db_keyspace, client_new_name(), client_new_hub())
  
  data <- db_read_table_client(db_host, db_port, db_keyspace, client_hub())
  updateSelectInput(session, "client_new_hub", label = NULL, choices = data[, "hub"])
  updateTextInput(session, "client_new_name", label = NULL, value = "") 
})

observeEvent(input$client_change_go, {
  data <- db_read_table_table(db_host, db_port, db_keyspace, client_hub())
  choices <- sort(data[, "hub"])
  
  updateSelectInput(session, "client_change_hub", label = NULL, choices = choices)
  updateTextInput(session, "client_change_name", label = NULL, value = NULL)
})

observeEvent(input$client_del_go, {
  db_delete_row_client(db_host, db_port, db_keyspace, client_del_name(), client_hub())
  
  data <- db_read_table_client(db_host, db_port, db_keyspace, client_hub())
  updateCheckboxGroupInput(session, "client_del_name", label = NULL, choices = data[, "client"])
})

client_data_del <- eventReactive(input$client_del_go, {
  db_read_table(db_host, db_port, db_keyspace, 'client')
})

client_show_hubs <- eventReactive(eventExpr = input$client_action == 'Edit', {
  print("TRUE===")
})