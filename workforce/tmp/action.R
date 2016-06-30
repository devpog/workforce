role_show_roles <- reactive({
  db_read_table(db_host, db_port, db_keyspace, 'role')[, "name"]
})

role_action <- reactive({input$role_action})

role_edit_name <- reactive({input$role_edit_name})

role_edit_new <- reactive({input$role_edit_new})

role_new_name <- reactive({input$role_new_name})

role_del_name <- reactive({input$role_del_name})

role_edit_go_label <- reactive({
  if(role_edit_new())
    return("Add")
  else
    return("Edit")
})

role_data <- reactive({
  switch(input$role_action,
         "Show" = db_read_table(db_host, db_port, db_keyspace, 'role'),
         "Edit" = db_read_table(db_host, db_port, db_keyspace, 'role'),
         "Delete" = db_read_table(db_host, db_port, db_keyspace, 'role'),
         db_read_table(db_host, db_port, db_keyspace, 'role')
  )
})