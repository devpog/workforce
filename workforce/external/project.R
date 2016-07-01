fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  fluidRow(
    box(title = "Action: ", collapsible = T, collapsed = F, width = 3, status = "primary",
        selectInput("project_action", label = NULL, choices = c("Show", "Edit", "Delete"))
    )
  ),
  
  fluidRow(
    conditionalPanel(condition = "input.project_action == 'Show' || input.project_action == 'Edit' || input.project_action == 'Delete'",
                     box(title = "Hub: ", collapsible = T, collapsed = F, width = 3, status = "primary",
                         conditionalPanel(condition = "input.project_show_all_hubs == false",
                                          uiOutput("project_hub")
                         ),
                        conditionalPanel(condition = "input.project_action != 'Edit' || input.project_action != 'Delete'",
                         checkboxInput("project_show_all_hubs", label = "Show all?", value = F)
                        )
                     )
    ),
    
    conditionalPanel(condition = "input.project_action != 'Edit'",
                     box(title = "Phase: ", collapsible = T, collapsed = F, width = 3, status = "primary",
                         conditionalPanel(condition = "input.project_show_all_phases == false",
                                          selectInput("project_phase", label = NULL, choices = project_phases)
                         ),
                         conditionalPanel(condition = "input.project_action == 'Show'",
                                          checkboxInput("project_show_all_phases", label = "Show all?", value = T)
                         )
                     )
    ),
    
    conditionalPanel(condition = "input.project_action == 'Show'",
      box(title = "Status: ", collapsible = T, collapsed = F, width = 3, status = "primary",
          checkboxInput("project_show_all_active", label = "Active only?", value = T),
          checkboxInput("project_show_all_completed", label = "Completed only?", value = F)
      )
    )
  ),
  
  fluidRow(
    conditionalPanel(condition = "input.project_action == 'Show'",
                     box(title = "Client: ", collapsible = T, collapsed = F, width = 3, status = "primary",
                         conditionalPanel(condition = "input.project_show_all_clients == false",
                                          uiOutput("project_client")
                         ),
                         conditionalPanel(condition = "input.project_action == 'Show'",
                                          checkboxInput("project_show_all_clients", label = "Show all?", value = T)
                         )
                     ),
                     
                     box(title = "Resource: ", collapsible = T, collapsed = F, width = 3, status = "primary",
                         conditionalPanel(condition = "input.project_show_all_resources == false",
                                          uiOutput("project_resource")
                         ),
                         conditionalPanel(condition = "input.project_action == 'Show'",
                                          checkboxInput("project_show_all_resources", label = "Show all?", value = T)
                         )
                     )
    )
  ),
  
  conditionalPanel(condition = "input.project_action == 'Show'",
                   fluidRow(  
                     box(title = "Summary: ", collapsible = T, collapsed = F, width = 9, status = "primary", 
                         DT::dataTableOutput("project_table")
                     )
                   ),
                   fluidRow(
                     box(title = "Projects: ", collapsible = T, collapsed = F, width = 9, status = "primary",
                         DT::dataTableOutput("project_details")
                     )
                   )
  ),
  
  conditionalPanel(condition = "input.project_action == 'Edit'",
                   fluidRow(
                     box(title = "Select project: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
                         checkboxInput("project_edit_new", "Add new?", value = T),
                         conditionalPanel(condition = "input.project_edit_new == false",
                                          uiOutput("project_edit_name")
                                          
                         )
                     )
                   ),
                   
                   fluidRow(
                     uiOutput("project_edit_box")
                   ),
                   
                   fluidRow(
                     uiOutput("project_edit_roles"),
                     uiOutput("project_edit_dedication"),
                     uiOutput("project_edit_resources")
                   ),
                   
                   fluidRow(
                     uiOutput("project_go")
                   )
  ),
  
  conditionalPanel(condition = "input.project_action == 'Delete'",
                   fluidRow(
                     box(title = "Select project: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
                         uiOutput("project_del_name"),
                         conditionalPanel(condition = "output.project_del_name",
                                          actionButton("project_del_go", label = "Go",
                                                       singleton(
                                                         tags$head(tags$script(src = "message-handler.js"))
                                                       ))
                         )
                     )
                   )
  )
)