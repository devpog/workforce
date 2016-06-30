output$resource_hub <- renderUI({
  choices <- resource_hubs()[, "hub"]
  selectInput("resource_hub", label = NULL, choices = sort(choices))
})

output$resource_role <- renderUI({
  choices <- resource_roles()[, "role"]
  selectInput("resource_role", label = NULL, choices = sort(choices))
})

output$resource_table <- renderDataTable({
  data <- data.frame(#system_name = resource_data()[, "system_name"],
                     role = resource_data()[, "role"],
                     fname = resource_data()[, "first_name"],
                     lname = resource_data()[, "last_name"],
                     hub = resource_data()[, "hub"])
  
  if(!resource_show_all_hubs())
    data <- filter(data, hub == resource_hub())
  
  if(!resource_show_all_roles())
    data <- filter(data, role == resource_role())

  #DT::datatable(data, rownames = F, colnames = c("System name", "Role", "First name", "Last name", "Location"))
  DT::datatable(data, rownames = F, colnames = c("Role", "First name", "Last name", "Location"))
                #extensions = 'Buttons', options = list(dom = 'Bfrtip', buttons = list(list(extend = 'colvis', columns = c(2, 3, 4)))))
})

output$resource_del_name <- renderUI({
  data <- resource_data() %>% filter(hub == resource_hub()) %>% filter(role == resource_role())
  
  choices <- sort(unique(with(data, paste(last_name, first_name, sep = ", "))))
  checkboxGroupInput("resource_del_name", label = NULL,
                     choices = choices
  )
})

output$resource_edit_name <- renderUI({
  choices <- unique(sort(with(resource_data(), paste(lname, fname, sep = ", "))))
  selectInput("resource_edit_name", label = NULL,
              choices = choices 
  )
})

output$resource_edit_box <- renderUI({
  label <- resource_edit_go_label()
  if(label == 'Add')
    box(title = paste0(label, " new resource: "), collapsible = T, collapsed = F, width = 3, status = "primary",
        textInput("resource_new_fname", label = "First name: "),
        textInput("resource_new_lname", label = "Last name: "),
        selectInput("resource_new_hub", label = "Hub: ", choices = unique(sort(resource_hubs()[, "hub"]))),
        selectInput("resource_new_role", label = "Role: ", choices = unique(sort(resource_roles()[, "role"]))),
        actionButton("resource_new_go", "Go")
    )
  else {
    full_name <- str_trim(unlist(str_split(resource_edit_name(), ",")), side = "both")
    query <- paste0("select * from resource where fname = \'", full_name[2], "\' and lname = \'", full_name[1], "\' limit 1")
    print(query)
    resource <- db_select_resource(db_host, db_port, db_keyspace, query)
    print(resource)
    box(title = paste0(label, " existing resource: "), collapsible = T, collapsed = F, width = 3, status = "primary",
        textInput("resource_change_fname", label = "First name: ", value = resource[, "fname"]),
        textInput("resource_change_lname", label = "Last name: ", value = resource[, "lname"]),
        selectInput("resource_change_hub", label = "Hub: ", choices = sort(resource_hubs()[, "hub"]), selected = resource[, "hub"]),
        selectInput("resource_change_role", label = "Role: ", choices = sort(resource_roles()[, "role"]), selected = resource[, "role"]),
        actionButton("resource_change_go", "Go")
    )
  }
})