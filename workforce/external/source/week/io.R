output$week_hub <- renderUI({
  choices <- week_hub_choices()
  selectInput("week_hub", label = NULL, choices = sort(choices))
})

output$week_table <- renderDataTable({
  DT::datatable(as.data.frame(week_data())[, c("client", "start_date", "end_date", "phase", "active", "completed")], 
                colnames = c("Client", "Start Date", "End Date", "Phase", "Active", "Completed"),
                rownames = F)
})

output$week_del_name <- renderUI({
  choices <- week_data()[, "client"]
  checkboxGroupInput("week_del_name", label = NULL,
                     choices = sort(choices)
  )
})

output$week_edit_name <- renderUI({
  choices <- week_data()[, "client"]
  selectInput("week_edit_name", label = NULL,
              choices = sort(choices)
  )
})

output$week_edit_box <- renderUI({
  label <- week_edit_go_label()
  hub <- week_new_hub()
  
  hubs <- sort(unique(db_read_table(db_host, db_port, db_keyspace, 'hub')[, "hub"]))
  clients <- sort(db_read_table_client(db_host, db_port, db_keyspace, hub)[, "client"])
  
  if(label == 'Add'){
    box(title = paste0(label, " new week: "), collapsible = T, collapsed = F, width = 3, status = "primary",
        selectInput("week_new_hub", label = "Select hub: ", choices = hubs),
        selectInput("week_new_name", label = "Select client: ", choices = clients), 
        actionButton("week_new_go", "Go")
    )
   } else {
    #hub <- db_select_column(db_host, db_port, db_keyspace, 'week', 'hub', 'week', week_edit_name())
    box(title = paste0(label, " existing week: "), collapsible = T, collapsed = F, width = 3, status = "primary",
        textInput("week_change_name", label = NULL, value = week_edit_name()),
        selectInput("week_change_hub", label = "Select hub: ", choices = hubs, selected = hub[, "hub"]),
        actionButton("week_change_go", "Go")
    )
  }
})