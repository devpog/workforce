output$client_hub <- renderUI({
  choices <- client_hub_choices()[, "hub"]
  selectInput("client_hub", label = NULL, choices = sort(choices))
})

output$client_table <- renderDataTable({
  DT::datatable(client_data()[, c("client", "hub")])
})

output$client_del_name <- renderUI({
  choices <- client_data()[, "client"]
  checkboxGroupInput("client_del_name", label = NULL,
                     choices = sort(choices)
  )
})

output$client_edit_name <- renderUI({
  choices <- client_data()[, "client"]
  selectInput("client_edit_name", label = NULL,
              choices = sort(choices)
  )
})

output$client_edit_box <- renderUI({
  label <- client_edit_go_label()
  hubs <- sort(db_read_table(db_host, db_port, db_keyspace, 'hub')[, "hub"])
  
  if(label == 'Add')
    box(title = paste0(label, " new client: "), collapsible = T, collapsed = F, width = 3, status = "primary",
        selectInput("client_new_hub", label = "Select hub: ", choices = hubs),
        textInput("client_new_name", label = "Name: "),
        actionButton("client_new_go", "Go")
    )
  else {
    hub <- db_select_column(db_host, db_port, db_keyspace, 'client', 'hub', 'client', client_edit_name())
    box(title = paste0(label, " existing client: "), collapsible = T, collapsed = F, width = 3, status = "primary",
        selectInput("client_change_hub", label = "Select hub: ", choices = hubs, selected = hub[, "hub"]),
        textInput("client_change_name", label = NULL, value = client_edit_name()),
        actionButton("client_change_go", "Go")
    )
  }
})