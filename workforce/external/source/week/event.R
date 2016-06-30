observeEvent(input$week_new_go, {
  db_insert_row_week(db_host, db_port, db_keyspace, week_new_name(), week_new_hub())
  
  data <- db_read_table_week(db_host, db_port, db_keyspace, week_hub())
  updateSelectInput(session, "week_new_hub", label = NULL, choices = data[, "hub"])
  updateTextInput(session, "week_new_name", label = NULL, value = "") 
})

observeEvent(input$week_change_go, {
  data <- db_read_table_table(db_host, db_port, db_keyspace, week_hub())
  choices <- sort(data[, "hub"])
  
  updateSelectInput(session, "week_change_hub", label = NULL, choices = choices)
  updateTextInput(session, "week_change_name", label = NULL, value = NULL)
})

observeEvent(input$week_del_go, {
  db_delete_row_week(db_host, db_port, db_keyspace, week_del_name(), week_hub())
  
  data <- db_read_table_week(db_host, db_port, db_keyspace, week_hub())
  updateCheckboxGroupInput(session, "week_del_name", label = NULL, choices = data[, "week"])
})

week_data_del <- eventReactive(input$week_del_go, {
  db_read_table(db_host, db_port, db_keyspace, 'week')
})

week_show_hubs <- eventReactive(eventExpr = input$week_action == 'Edit', {
  print("TRUE===")
})