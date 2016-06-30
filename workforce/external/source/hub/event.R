observeEvent(input$hub_new_go, {
  db_insert_row_hub(db_host, db_port, db_keyspace, hub_new_name())
  
  label <- hub_edit_go_label()
  data <- db_read_table(db_host, db_port, db_keyspace, 'hub')
  
  if(label == 'Add')
    updateTextInput(session, "hub_new_name", label = NULL, value = NULL) 
  else {
    selectInput(session, "hub_edit_name", label = NULL, choices = data[, "hub"])
    updateTextInput(session, "hub_change_name", label = NULL, value = hub_edit_name())
  }
})

observeEvent(input$hub_change_go, {
  #db_insert_row(db_host, db_port, db_keyspace, 'hub', 'name', hub_new_name())
  
  label <- hub_edit_go_label()
  data <- db_read_table(db_host, db_port, db_keyspace, 'hub')
  
  if(label == 'Add')
    updateTextInput(session, "hub_new_name", label = NULL, value = NULL) 
  else {
    selectInput(session, "hub_edit_name", label = NULL, choices = data[, "hub"])
    updateTextInput(session, "hub_change_name", label = NULL, value = NULL)
  }
})

observeEvent(input$hub_del_go, {
  db_delete_row_hub(db_host, db_port, db_keyspace, hub_del_name())
  data <- db_read_table(db_host, db_port, db_keyspace, 'hub')
  updateCheckboxGroupInput(session, "hub_del_name", label = NULL,
                           choices = data[, "hub"])
})

hub_data_del <- eventReactive(input$hub_del_go, {
  db_read_table(db_host, db_port, db_keyspace, 'hub')
})