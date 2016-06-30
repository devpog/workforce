fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  fluidRow(
    box(title = "Action: ", collapsible = T, collapsed = F, width = 3, status = "primary",
        selectInput("resource_action", label = NULL, choices = action_choices)
    )
  ),
  
  conditionalPanel(condition = "input.resource_edit_new == false || (input.resource_action == 'Show' || input.resource_action == 'Delete')",
  fluidRow(
    box(title = "Hub: ", collapsible = T, collapsed = F, width = 3, status = "primary",
        #conditionalPanel(condition = "input.resource_edit_new == false",
                         uiOutput("resource_hub"),
        #),
        
        conditionalPanel(condition = "input.resource_action == 'Show'",
                         checkboxInput("resource_show_all_hubs", label = "Show all?", value = T)
        )
    ),
    
    box(title = "Role: ", collapsible = T, collapsed = F, width = 4, status = "primary",
        #conditionalPanel(condition = "input.resource_edit_new == false",
                         uiOutput("resource_role"),
        #),
        
        conditionalPanel(condition = "input.resource_action == 'Show'",
                         checkboxInput("resource_show_all_roles", label = "Show all?", value = T)
        )
    )
  )  
  ),
  
  conditionalPanel(condition = "input.resource_action == 'Show'",
    fluidRow(  
      box(title = " ", collapsible = T, collapsed = F, width = 7, status = "primary", 
          DT::dataTableOutput("resource_table")
      )
    )
  ),
  
  conditionalPanel(condition = "input.resource_action == 'Edit'",
    fluidRow(
      box(title = "Select resource: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
          checkboxInput("resource_edit_new", "Add new?", value = add_new),
          conditionalPanel(condition = "input.resource_edit_new == false",
                           uiOutput("resource_edit_name")
                           
          )
      )
    ),
    
    fluidRow(
      uiOutput("resource_edit_box")
    )
  ),
  
  conditionalPanel(condition = "input.resource_action == 'Delete'",
    fluidRow(
      box(title = "Select resource: ", collapsible = T, collapsed = F, width = 4, status = "primary", 
          uiOutput("resource_del_name"),
          conditionalPanel(condition = "output.resource_del_name",
           actionButton("resource_del_go", label = "Go",
            singleton(
              tags$head(tags$script(src = "message-handler.js"))
            ))
          )
      )
    )
  )
)