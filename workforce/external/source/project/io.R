output$project_resource <- renderUI({
  data <- db_project_get_resources(db_host, db_port, db_keyspace)
  choices <- append(sort(unique(with(data, paste(last_name, first_name, sep = ", ")))), "None")
  selectInput("project_resource", label = NULL, choices = choices)
})

output$project_client <- renderUI({
  choices <- db_project_get_clients(db_host, db_port, db_keyspace, hub = project_hub())[, "client"]
  selectInput("project_client", label = NULL, choices = choices)
})

output$project_hub <- renderUI({
  choices <- db_read_table(db_host, db_port, db_keyspace, 'hub')[, "hub"]
  selectInput("project_hub", label = NULL, choices = sort(choices))
})

output$project_details <- DT::renderDataTable({
  clients <- db_get_active_projects(db_host, db_port, db_keyspace) %>% select(client, phase) %>% arrange(client)

  df <- apply(clients[, c("client", "phase")], 1, function(x){
    client <- str_trim(x[1], "both")
    phase <- str_trim(x[2], "both")
    return(db_get_project_details(db_host, db_port, db_keyspace, client, phase))
  })
  df <- do.call(rbind, df)
  
  if(!project_show_all_hubs()){
    df <- filter(df, hub_client == project_hub())
  }
  
  if(!project_show_all_clients()){
    df <- filter(df, client == project_client())
  }
  
  if(!project_show_all_phases()){
    df <- filter(df, phase == project_phase())
  }
  
  df[, "full_name"] <- gsub("^(None)\\s+(None)$", "\\1", df[, "full_name"])

  if(!project_show_all_resources()){
    if(project_resource() != "None"){
      full_name <- unlist(str_split(project_resource(), ", "))
      full_name2 <- paste(rev(full_name), collapse = " ")
      print(full_name2)

      df <- filter(df, full_name == full_name2)
    } else {
      df <- filter(df, full_name == "None")
    }
  }
  
  if(project_show_all_active()){
    df <- filter(df, active == 'true')
  }
  
  if(project_show_all_completed()){
    df <- filter(df, completed == 'true')
  }
  
  df <- df[!(names(df) %in% c("system_name"))]
  
  
  DT::datatable(
    df,
    colnames = gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", gsub("_", " ", names(df)), perl=TRUE),
    rownames = F,
    extensions = 'Buttons', option = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
  ))
})

output$project_table <- renderDataTable({
  if(project_show_all_hubs()){
    DT::datatable(as.data.frame(project_data())[, c("client", "start_date", "end_date", "phase", "active", "completed")], 
                  colnames = c("Client", "Start Date", "End Date", "Phase", "Active", "Completed"),
                  rownames = F)
  } else {
    DT::datatable(as.data.frame(project_data_by_hub())[, c("client", "start_date", "end_date", "phase", "active", "completed")], 
                  colnames = c("Client", "Start Date", "End Date", "Phase", "Active", "Completed"),
                  rownames = F)
    
  }
})

output$project_del_name <- renderUI({
  choices <- project_data_by_hub()[, "client"]
  checkboxGroupInput("project_del_name", label = NULL,
                     choices = sort(choices)
  )
})

output$project_edit_name <- renderUI({
  choices <- project_data_by_hub()[, "client"]
  selectInput("project_edit_name", label = NULL,
              choices = sort(choices)
  )
})

output$project_edit_box <- renderUI({
  label <- project_edit_go_label()
  
  if(project_action() == 'Edit'){
    if(project_edit_go_label() == 'Add'){
      hub <- project_hub()
      clients <- sort(db_read_table_client(db_host, db_port, db_keyspace, hub)[, "client"])
      
      box(title = paste0(label, " new project: "), collapsible = T, collapsed = F, width = 9, status = "primary",
          column(6, selectInput("project_new_name", label = "Select client: ", choices = clients, selected = NULL)),
          column(6, selectInput("project_new_phase", label = "Select phase: ", choices = project_phases, selected = NULL)),
          column(6, dateInput("project_new_start_date", label = "Start date: ", value = Sys.Date())),
          column(6, dateInput("project_new_end_date", label = "End date: ", value = NULL)),
          column(6, checkboxInput("project_new_active", label = "Currently active?", value = F))
      )
    } else if(project_edit_go_label() == 'Edit'){
      phase <- db_project_get_phase(db_host, db_port, db_keyspace, project_edit_name())
      start_date <- db_project_get_start_date(db_host, db_port, db_keyspace, project_edit_name(), phase)
      end_date <- db_project_get_end_date(db_host, db_port, db_keyspace, project_edit_name(), phase)
      active <- db_project_get_active(db_host, db_port, db_keyspace, project_edit_name())
      
      box(title = paste0(label, " existing project: "), collapsible = T, collapsed = F, width = 9, status = "primary",
          column(6, selectInput("project_change_name", label = "Select client: ", choices = project_edit_name())),
          column(6, selectInput("project_change_phase", label = "Select phase: ", choices = project_phases, selected = phase)),
          column(6, dateInput("project_change_start_date", label = "Start date: ", value = start_date)),
          column(6, dateInput("project_change_end_date", label = "End date: ", value = end_date)),
          column(6, checkboxInput("project_change_active", label = "Currently active?", value = active))
      )
    }
  } else {
    
  }
})

output$project_edit_roles <- renderUI({
  label <- project_edit_go_label()
  roles <- role_show_roles()
  if(project_action() == 'Edit'){
    if(project_edit_go_label() == 'Add'){
      box(title = paste0(label, " roles: "), collapsible = T, collapsed = F, width = 3, status = "primary",
          numericInput("project_partnerships_lead", label = "Partnerships Lead", min = 0, value = 0),
          numericInput("project_business_architect", label = "Business Architect", min = 0, value = 0),
          numericInput("project_technical_architect", label = "Technical Architect", min = 0, value = 0),
          numericInput("project_project_lead", label = "Project Lead", min = 0, value = 0),
          numericInput("project_implementation_engineer", label = "Implementation Engineer", min = 0, value = 0),
          numericInput("project_support_engineer", label = "Support Engineer", min = 0, value = 0)
      )
    } else if(project_edit_go_label() == 'Edit'){
      all_roles <- db_project_get_role(db_host, db_port, db_keyspace, project_edit_name())
      box(title = paste0(label, " roles: "), collapsible = T, collapsed = F, width = 3, status = "primary",
          numericInput("project_change_partnerships_lead", label = "Partnerships Lead", min = 0, 
                       value = filter(all_roles, role == global_roles[1])[, "count"]),
          numericInput("project_change_business_architect", label = "Business Architect", min = 0, 
                       value = filter(all_roles, role == global_roles[2])[, "count"]),
          numericInput("project_change_technical_architect", label = "Technical Architect", min = 0, 
                       value = filter(all_roles, role == global_roles[3])[, "count"]),
          numericInput("project_change_project_lead", label = "Project Lead", min = 0, 
                       value = filter(all_roles, role == global_roles[4])[, "count"]),
          numericInput("project_change_implementation_engineer", label = "Implementation Engineer", min = 0, 
                       value = filter(all_roles, role == global_roles[5])[, "count"]),
          numericInput("project_change_support_engineer", label = "Support Engineer", min = 0, 
                       value = filter(all_roles, role == global_roles[6])[, "count"])
      )
    }
  } else {
    
  }
})

output$project_edit_dedication <- renderUI({
  label <- project_edit_go_label()
  roles <- role_show_roles()
  if(project_action() == 'Edit'){
    if(project_edit_go_label() == 'Add'){
      box(title = paste0(label, " dedication: "), collapsible = T, collapsed = F, width = 3, status = "primary",
          numericInput("project_partnerships_lead_dedication", label = "Partnerships Lead, %", min = 0, max = 100, value = 0),
          numericInput("project_business_architect_dedication", label = "Business Architect, %", min = 0, max = 100, value = 0),
          numericInput("project_technical_architect_dedication", label = "Technical Architect, %", min = 0, max = 100, value = 0),
          numericInput("project_project_lead_dedication", label = "Project Lead, %", min = 0, value = 0),
          numericInput("project_implementation_engineer_dedication", label = "Implementation Engineer, %", min = 0, max = 100, value = 0),
          numericInput("project_support_engineer_dedication", label = "Support Engineer, %", min = 0, max = 100, value = 0)
      )
    } else if(project_edit_go_label() == 'Edit'){
      all_dedications <- db_project_get_dedication(db_host, db_port, db_keyspace, project_edit_name())
      box(title = paste0(label, " dedication: "), collapsible = T, collapsed = F, width = 3, status = "primary",
          numericInput("project_change_partnerships_lead_dedication", label = "Partnerships Lead, %", min = 0, max = 100, 
                       value = filter(all_dedications, role == global_roles[1])[, "dedication"]),
          numericInput("project_change_business_architect_dedication", label = "Business Architect, %", min = 0, max = 100, 
                       value = filter(all_dedications, role == global_roles[2])[, "dedication"]),
          numericInput("project_change_technical_architect_dedication", label = "Technical Architect, %", min = 0, max = 100, 
                       value = filter(all_dedications, role == global_roles[3])[, "dedication"]),
          numericInput("project_change_project_lead_dedication", label = "Project Lead, %", min = 0, 
                       value = filter(all_dedications, role == global_roles[4])[, "dedication"]),
          numericInput("project_change_implementation_engineer_dedication", label = "Implementation Engineer, %", min = 0, max = 100, 
                       value = filter(all_dedications, role == global_roles[5])[, "dedication"]),
          numericInput("project_change_support_engineer_dedication", label = "Support Engineer, %", min = 0, max = 100, 
                       value = filter(all_dedications, role == global_roles[6])[, "dedication"])
      )
    }
  } else {
    
  }
})

output$project_edit_resources <- renderUI({
  label <- project_edit_go_label()
  
  if(project_action() == 'Edit'){
    if(project_edit_go_label() == 'Add'){
      ps_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Partnerships Lead')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      ba_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Business Architect')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      ta_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Technical Architect')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      pl_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Project Lead')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      ie_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Implementation Engineer')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      se_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Support Engineer')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      
      box(title = paste0(label, " resources: "), collapsible = T, collapsed = F, width = 5, status = "primary",
          selectInput("project_partnerships_lead_resource", label = "Partnerships Lead: ", choices = ps_choices, multiple = T),
          selectInput("project_business_architect_resource", label = "Business Architect: ", choices = ba_choices, multiple = T),
          selectInput("project_technical_architect_resource", label = "Technical Architect: ", choices = ta_choices, multiple = T),
          selectInput("project_project_lead_resource", label = "Project Lead: ", choices = pl_choices, multiple = T),
          selectInput("project_implementation_engineer_resource", label = "Implementation Engineer: ", choices = ie_choices, multiple = T),
          selectInput("project_support_engineer_resource", label = "Support Engineer: ", choices = se_choices, multiple = T)
      )
    } else if(project_edit_go_label() == 'Edit'){
      ps_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = global_roles[1])[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      ba_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Business Architect')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      ta_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Technical Architect')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      pl_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Project Lead')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      ie_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Implementation Engineer')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      se_choices <- append("None", sort(with(db_get_resources(db_host, db_port, db_keyspace, role = 'Support Engineer')[, c("first_name", "last_name")], 
                                             paste(last_name, first_name, sep = ", "))))
      
      all_resources <- db_project_get_resource(db_host, db_port, db_keyspace, project_edit_name()) %>% filter(system_name != "None")
      full_names <- db_project_get_full_name(db_host, db_port, db_keyspace, all_resources[, "system_name"])
      df <- left_join(all_resources, full_names)
      df[is.na(df) ] <- "None"
      
      ps_selected <- with(filter(df, role == global_roles[1]), paste(last_name, first_name, sep = ", "))
      ba_selected <- with(filter(df, role == global_roles[2]), paste(last_name, first_name, sep = ", "))
      ta_selected <- with(filter(df, role == global_roles[3]), paste(last_name, first_name, sep = ", "))
      pl_selected <- with(filter(df, role == global_roles[4]), paste(last_name, first_name, sep = ", "))
      ie_selected <- with(filter(df, role == global_roles[5]), paste(last_name, first_name, sep = ", "))
      se_selected <- with(filter(df, role == global_roles[6]), paste(last_name, first_name, sep = ", "))
      
      box(title = paste0(label, " resources: "), collapsible = T, collapsed = F, width = 5, status = "primary",
          selectInput("project_change_partnerships_lead_resource", label = "Partnerships Lead: ", multiple = T, 
                      choices = ps_choices,
                      selected = ifelse(length(ps_selected) > 0, ps_selected, 'None')),
          selectInput("project_change_business_architect_resource", label = "Business Architect: ", multiple = T, 
                      choices = ba_choices,
                      selected = ifelse(length(ba_selected) > 0, ba_selected, 'None')),
          selectInput("project_change_technical_architect_resource", label = "Technical Architect: ", multiple = T, 
                      choices = ta_choices,
                      selected = ifelse(length(ta_selected) > 0, ta_selected, 'None')),
          selectInput("project_change_project_lead_resource", label = "Project Lead: ", multiple = T, 
                      choices = pl_choices,
                      selected = ifelse(length(pl_selected) > 0, pl_selected, 'None')),
          selectInput("project_change_implementation_engineer_resource", label = "Implementation Engineer: ", multiple = T, 
                      choices = ie_choices,
                      selected = ifelse(length(ie_selected) > 0, ie_selected, 'None')),
          selectInput("project_change_support_engineer_resource", label = "Support Engineer: ", multiple = T, 
                      choices = se_choices,
                      selected = ifelse(length(se_selected) > 0, se_selected, 'None'))
      )
    }
  } else {
    
  }
})

output$project_go <- renderUI({
  if(project_action() == 'Edit'){
    if(project_edit_go_label() == 'Add'){
      box(title = NULL, collapsible = F, collapsed = F, width = 3, status = "primary",
          actionButton("project_new_go", "Submit", width = '100%')
      )
    } else if(project_edit_go_label() == 'Edit'){
      box(title = NULL, collapsible = F, collapsed = F, width = 3, status = "primary",
          actionButton("project_change_go", "Update", width = '100%')
      )
    } else {
      
    }
  } else {
    
  }
})