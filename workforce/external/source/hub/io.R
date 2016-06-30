output$hub_table <- renderDataTable({
  DT::datatable(data.frame(hub = hub_data()[, "hub"]), rownames = F, colnames = c("Location"))
})

output$hub_del_name <- renderUI({
  #print(hub_data_del())
  choices <- sort(hub_data()[, "hub"])
  checkboxGroupInput("hub_del_name", label = NULL,
                     choices = choices
                     )
})

output$hub_edit_name <- renderUI({
  selectInput("hub_edit_name", label = NULL,
              choices = hub_data()[, "hub"]
              )
})

output$hub_edit_box <- renderUI({
  label <- hub_edit_go_label()
  if(label == 'Add')
    box(title = paste0(label, " new hub: "), collapsible = T, collapsed = F, width = 3, status = "primary",
        textInput("hub_new_name", label = NULL), 
        actionButton("hub_new_go", "Go")
        )
  else
    box(title = paste0(label, " existing hub: "), collapsible = T, collapsed = F, width = 3, status = "primary",
        textInput("hub_change_name", label = NULL, value = hub_edit_name()),
        actionButton("hub_change_go", "Go")
        )
})