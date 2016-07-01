project_change_phase <- reactive({input$project_change_phase})

project_flexible_resource <- reactive({input$project_flexible_resource})
project_change_flexible_resource <- reactive({input$project_change_flexible_resource})

project_partnerships_lead <- reactive({input$project_partnerships_lead})
project_business_architect <- reactive({input$project_business_architect})
project_technical_architect <- reactive({input$project_technical_architect})
project_project_lead <- reactive({input$project_project_lead})
project_implementation_engineer <- reactive({input$project_implementation_engineer})
project_support_engineer <- reactive({input$project_support_engineer})

project_partnerships_lead_dedication <- reactive({input$project_partnerships_lead_dedication})
project_business_architect_dedication <- reactive({input$project_business_architect_dedication})
project_technical_architect_dedication <- reactive({input$project_technical_architect_dedication})
project_project_lead_dedication <- reactive({input$project_project_lead_dedication})
project_implementation_engineer_dedication <- reactive({input$project_implementation_engineer_dedication})
project_support_engineer_dedication <- reactive({input$project_support_engineer_dedication})

project_partnerships_lead_resource <- reactive({input$project_partnerships_lead_resource})
project_business_architect_resource <- reactive({input$project_business_architect_resource})
project_technical_architect_resource <- reactive({input$project_technical_architect_resource})
project_project_lead_resource <- reactive({input$project_project_lead_resource})
project_implementation_engineer_resource <- reactive({input$project_implementation_engineer_resource})
project_support_engineer_resource <- reactive({input$project_support_engineer_resource})

project_new_name <- reactive({input$project_new_name})
project_new_phase <- reactive({input$project_new_phase})
project_new_start_date <- reactive({input$project_new_start_date})
project_new_end_date <- reactive({input$project_new_end_date})
project_new_active <- reactive({input$project_new_active})

project_hub <- reactive({input$project_hub})
project_client <- reactive({input$project_client})
project_phase <- reactive({input$project_phase})
project_resource <- reactive({input$project_resource})

project_show_all_hubs <- reactive({input$project_show_all_hubs})
project_show_all_phases <- reactive({input$project_show_all_phases})
project_show_all_active <- reactive({input$project_show_all_active})
project_show_all_completed <- reactive({input$project_show_all_completed})
project_show_all_clients <- reactive({input$project_show_all_clients})
project_show_all_resources <- reactive({input$project_show_all_resources})

project_change_hub <- reactive({input$project_change_hub})

project_action <- reactive({input$project_action})

project_edit_name <- reactive({input$project_edit_name})

project_edit_new <- reactive({input$project_edit_new})

project_new_name <- reactive({input$project_new_name})

project_new_hub <- reactive({input$project_new_hub})

project_change_name <- reactive({input$project_change_name})

project_del_name <- reactive({input$project_del_name})

project_clients_by_hub <- reactive({
  
})

project_edit_go_label <- reactive({
  if(project_edit_new())
    return("Add")
  else
    return("Edit")
})

project_data <- reactive({
  switch(input$project_action,
         "Show" = db_read_table_project(db_host, db_port, db_keyspace),
         "Edit" = db_read_table_project(db_host, db_port, db_keyspace),
         "Delete" = db_read_table_project(db_host, db_port, db_keyspace),
         db_read_table_project(db_host, db_port, db_keyspace)
  )
})

project_data_by_hub <- reactive({
  switch(input$project_action,
         "Show" = db_read_table_project_by_hub(db_host, db_port, db_keyspace, project_hub()),
         "Edit" = db_read_table_project_by_hub(db_host, db_port, db_keyspace, project_hub()),
         "Delete" = db_read_table_project_by_hub(db_host, db_port, db_keyspace, project_hub()),
         db_read_table_project_by_hub(db_host, db_port, db_keyspace, project_hub())
  )
})

project_hub_choices <- reactive({
  db_get_hubs_project(db_host, db_port, db_keyspace)
})

project_show_projects <- reactive({
  db_read_table(db_host, db_port, db_keyspace, 'project')[, "client"]
})