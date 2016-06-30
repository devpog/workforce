observeEvent(input$project_new_go, {
  client <- project_new_name()
  phase <- project_new_phase()
  start_date <- project_new_start_date()
  end_date <- project_new_end_date()
  active <- tolower(project_new_active())
  
  project_count <- c(
    project_business_architect(),
    project_technical_architect(),
    project_project_lead(),
    project_implementation_engineer(),
    project_support_engineer()
  )
  project_dedication <- c(
    project_business_architect_dedication(),
    project_technical_architect_dedication(),
    project_project_lead_dedication(),
    project_implementation_engineer_dedication(),
    project_support_engineer_dedication()
  )
  project_resource <- list(
    ba =  project_business_architect_resource(),
    ta = project_technical_architect_resource(),
    pl = project_project_lead_resource(),
    ie = project_implementation_engineer_resource(),
    se = project_support_engineer_resource()
  )

  num_rows <- 5
  df <- list(
    client = rep(client, num_rows),
    phase = rep(phase, num_rows),
    role = global_roles,
    start_date = rep(start_date, num_rows),
    end_date = rep(end_date, num_rows),
    active = rep(active, num_rows),
    count = project_count, 
    dedication = project_dedication,
    resource = project_resource
  )
  
  for(i in 1:num_rows){
    client <- df$client[[i]]
    phase <- df$phase[[i]]
    role <- df$role[[i]]
    start_date <- df$start_date[[i]]
    end_date <- df$end_date[[i]]
    active <- df$active[[i]]
    count <- df$count[[i]]
    dedication <- df$dedication[[i]]
    resource <- df$resource[[i]]
    
    db_insert_row_project(db_host, db_port, db_keyspace, client, phase, start_date, end_date, active)
    db_insert_row_pr_role(db_host, db_port, db_keyspace, client, phase, role, count)
    db_insert_row_pr_dedication(db_host, db_port, db_keyspace, client, phase, role, dedication)
    if(length(resource) > 1){
      for(res in resource)
        db_insert_row_pr_resource(db_host, db_port, db_keyspace, client, phase, res, role)
    } else {
      db_insert_row_pr_resource(db_host, db_port, db_keyspace, client, phase, resource, role)
    }
  }
  
#   
#   data <- db_read_table_project(db_host, db_port, db_keyspace, project_hub())
#   updateSelectInput(session, "project_new_hub", label = NULL, choices = data[, "hub"])
#   updateTextInput(session, "project_new_name", label = NULL, value = "") 
})

observeEvent(input$project_change_go, {
  data <- db_read_table_table(db_host, db_port, db_keyspace, project_hub())
  choices <- sort(data[, "hub"])
  
  updateSelectInput(session, "project_change_hub", label = NULL, choices = choices)
  updateTextInput(session, "project_change_name", label = NULL, value = NULL)
})

observeEvent(input$project_del_go, {
#   db_delete_row_project(db_host, db_port, db_keyspace, project_del_name(), project_hub())
#   data <- db_read_table_project(db_host, db_port, db_keyspace, project_hub())
#   updateCheckboxGroupInput(session, "project_del_name", label = NULL, choices = data[, "project"])
  
})

project_data_del <- eventReactive(input$project_del_go, {
  db_read_table(db_host, db_port, db_keyspace, 'project')
})

project_show_hubs <- eventReactive(eventExpr = input$project_action == 'Edit', {
  print("TRUE===")
})