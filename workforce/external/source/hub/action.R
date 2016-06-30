hub_show_hubs <- reactive({
  db_read_table(db_host, db_port, db_keyspace, 'hub')[, "name"]
})

hub_action <- reactive({input$hub_action})

hub_edit_name <- reactive({input$hub_edit_name})

hub_edit_new <- reactive({input$hub_edit_new})

hub_new_name <- reactive({input$hub_new_name})

hub_del_name <- reactive({input$hub_del_name})

hub_edit_go_label <- reactive({
  if(hub_edit_new())
    return("Add")
  else
    return("Edit")
})

hub_data <- reactive({
  switch(input$hub_action,
         "Show" = db_read_table(db_host, db_port, db_keyspace, 'hub'),
         "Edit" = db_read_table(db_host, db_port, db_keyspace, 'hub'),
         "Delete" = db_read_table(db_host, db_port, db_keyspace, 'hub'),
         db_read_table(db_host, db_port, db_keyspace, 'hub')
  )
})