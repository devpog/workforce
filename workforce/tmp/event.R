observeEvent(input$role_new_go, {
  db_insert_row(db_host, db_port, db_keyspace, 'role', 'name', role_new_name())
  
  label <- role_edit_go_label()
  data <- db_read_table(db_host, db_port, db_keyspace, 'role')
  
  updateTextInput(session, "role_new_name", label = NULL, value = NULL) 
})

observeEvent(input$role_change_go, {
  #db_insert_row(db_host, db_port, db_keyspace, 'role', 'name', role_new_name())
  
  label <- role_edit_go_label()
  data <- db_read_table(db_host, db_port, db_keyspace, 'role')
  
  selectInput(session, "role_edit_name", label = NULL, choices = data[, "name"])
  updateTextInput(session, "role_change_name", label = NULL, value = NULL)
})

observeEvent(input$role_del_go, {
  db_delete_row(db_host, db_port, db_keyspace, 'role', 'name', role_del_name())
  
  data <- db_read_table(db_host, db_port, db_keyspace, 'role')
  updateCheckboxGroupInput(session, "role_del_name", label = NULL,
                           choices = data[, "name"])
})

role_data_del <- eventReactive(input$role_del_go, {
  db_read_table(db_host, db_port, db_keyspace, 'role')
})