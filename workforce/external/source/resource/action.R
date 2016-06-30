# resource_show_resources <- reactive({
#   db_read_table(db_host, db_port, db_keyspace, 'resource')[, "name"]
# })

resource_hub <- reactive({input$resource_hub})
resource_role <- reactive({input$resource_role})
resource_action <- reactive({input$resource_action})
resource_edit_name <- reactive({input$resource_edit_name})
resource_edit_new <- reactive({input$resource_edit_new})
resource_change_name <- reactive({input$resource_change_name})
resource_del_name <- reactive({input$resource_del_name})

resource_show_all_hubs <- reactive({input$resource_show_all_hubs})
resource_show_all_roles <- reactive({input$resource_show_all_roles})

resource_new_fname <- reactive({input$resource_new_fname})
resource_new_lname <- reactive({input$resource_new_lname})
resource_new_hub <- reactive({input$resource_new_hub})
resource_new_role <- reactive({input$resource_new_role})

resource_change_fname <- reactive({input$resource_change_fname})
resource_change_lname <- reactive({input$resource_change_lname})
resource_change_hub <- reactive({input$resource_change_hub})
resource_change_role <- reactive({input$resource_change_role})

resource_edit_go_label <- reactive({
  if(resource_edit_new())
    return("Add")
  else
    return("Edit")
})

# resource_data <- reactive({
#   switch(input$resource_action,
#          "Show" = db_read_table_resource(db_host, db_port, db_keyspace, resource_hub()),
#          "Edit" = db_read_table_resource(db_host, db_port, db_keyspace, resource_hub()),
#          "Delete" = db_read_table_resource(db_host, db_port, db_keyspace, resource_hub()),
#          db_read_table_resource(db_host, db_port, db_keyspace, resource_hub())
#   )
# })

resource_data <- reactive({
  switch(input$resource_action,
         "Show" = db_read_table_resource(db_host, db_port, db_keyspace),
         "Edit" = db_read_table_resource(db_host, db_port, db_keyspace),
         "Delete" = db_read_table_resource(db_host, db_port, db_keyspace),
         db_read_table_resource(db_host, db_port, db_keyspace)
  )
})

resource_hubs <- reactive({
  db_read_table(db_host, db_port, db_keyspace, 'hub')
})

resource_roles <- reactive({
  db_read_table(db_host, db_port, db_keyspace, 'role')
})