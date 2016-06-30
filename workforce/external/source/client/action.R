# client_show_clients <- reactive({
#   db_read_table(db_host, db_port, db_keyspace, 'client')[, "name"]
# })

client_change_hub <- reactive({input$client_change_hub})

client_action <- reactive({input$client_action})

client_edit_name <- reactive({input$client_edit_name})

client_edit_new <- reactive({input$client_edit_new})

client_new_name <- reactive({input$client_new_name})

client_new_hub <- reactive({input$client_new_hub})

client_change_name <- reactive({input$client_change_name})

client_del_name <- reactive({input$client_del_name})

client_hub <- reactive({input$client_hub})

client_show_all_hubs <- reactive({input$client_show_all_hubs})

client_edit_go_label <- reactive({
  if(client_edit_new())
    return("Add")
  else
    return("Edit")
})

client_data <- reactive({
  switch(input$client_action,
         "Show" = db_read_table_client(db_host, db_port, db_keyspace, client_hub(), client_show_all_hubs()),
         "Edit" = db_read_table_client(db_host, db_port, db_keyspace, client_hub(), client_show_all_hubs()),
         "Delete" = db_read_table_client(db_host, db_port, db_keyspace, client_hub(), client_show_all_hubs()),
         db_read_table_client(db_host, db_port, db_keyspace, client_hub(), client_show_all_hubs())
  )
})


client_hub_choices <- reactive({
  df <- db_get_hub_all(db_host, db_port, db_keyspace)
})