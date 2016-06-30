observeEvent(input$role_new_go, {
  db_insert_row_role(db_host, db_port, db_keyspace, role_new_name())
  updateTextInput(session, "role_new_name", label = NULL, value = NULL) 
})

observeEvent(input$role_change_go, {
  updateTextInput(session, "role_change_name", label = NULL, value = NULL)
})

observeEvent(input$role_del_go, {
  db_delete_row_role(db_host, db_port, db_keyspace, role_del_name())
  
  data <- db_read_table(db_host, db_port, db_keyspace, 'role')
  updateCheckboxGroupInput(session, "role_del_name", label = NULL,
                           choices = sort(data[, "role"]))
})

role_data_del <- eventReactive(input$role_del_go, {
  db_read_table(db_host, db_port, db_keyspace, 'role')
})