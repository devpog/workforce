week_change_hub <- reactive({input$week_change_hub})

week_action <- reactive({input$week_action})

week_edit_name <- reactive({input$week_edit_name})

week_edit_new <- reactive({input$week_edit_new})

week_new_name <- reactive({input$week_new_name})

week_new_hub <- reactive({input$week_new_hub})

week_change_name <- reactive({input$week_change_name})

week_del_name <- reactive({input$week_del_name})

week_hub <- reactive({input$week_hub})

week_show_all_hubs <- reactive({input$week_show_all_hubs})

week_clients_by_hub <- reactive({
  
})

week_edit_go_label <- reactive({
  if(week_edit_new())
    return("Add")
  else
    return("Edit")
})

week_data <- reactive({
  switch(input$week_action,
         "Show" = db_read_table_week_by_hub(db_host, db_port, db_keyspace, week_show_all_hubs()),
         # "Edit" = db_read_table_week(db_host, db_port, db_keyspace, T),
         "Edit" = db_read_table_week_by_hub(db_host, db_port, db_keyspace, week_show_all_hubs()),
         # "Delete" = db_read_table_week(db_host, db_port, db_keyspace, T),
         "Delete" = db_read_table_week_by_hub(db_host, db_port, db_keyspace, week_show_all_hubs()),
         # db_read_table_week(db_host, db_port, db_keyspace, T)
         db_read_table_week_by_hub(db_host, db_port, db_keyspace, week_show_all_hubs())
  )
})

week_hub_choices <- reactive({
  db_get_hubs_week(db_host, db_port, db_keyspace)
})

week_show_weeks <- reactive({
  db_read_table(db_host, db_port, db_keyspace, 'week')[, "client"]
})