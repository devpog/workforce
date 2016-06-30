output$role_table <- renderDataTable({
  DT::datatable(data.frame(role = role_data()[, "role"]), rownames = F, colnames = c("Role"))
})

output$role_del_name <- renderUI({
  choices <- role_data()[, "role"]
  checkboxGroupInput("role_del_name", label = NULL,
                     choices = sort(choices)
  )
})

output$role_edit_name <- renderUI({
  selectInput("role_edit_name", label = NULL,
              choices = sort(role_data()[, "role"])
  )
})

output$role_edit_box <- renderUI({
  label <- role_edit_go_label()
  if(label == 'Add')
    box(title = paste0(label, " new role: "), collapsible = T, collapsed = F, width = 3, status = "primary",
        textInput("role_new_name", label = "Name: "), 
        actionButton("role_new_go", "Go")
    )
  else {
    box(title = paste0(label, " existing role: "), collapsible = T, collapsed = F, width = 3, status = "primary",
        textInput("role_change_name", label = NULL, value = role_edit_name()),
        actionButton("role_change_go", "Go")
    )
  }
})