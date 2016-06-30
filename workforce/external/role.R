fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  fluidRow(
    box(title = "Action: ", collapsible = T, collapsed = F, width = 3, status = "primary",
        selectInput("role_action", label = NULL, choices = c("Show"))
    )
  ),
  
  conditionalPanel(condition = "input.role_action == 'Show'",
    fluidRow(  
      box(title = " ", collapsible = T, collapsed = F, width = 3, status = "primary", 
          DT::dataTableOutput("role_table")
      )
    )
  ),
  
  conditionalPanel(condition = "input.role_action == 'Edit'",
    fluidRow(
      box(title = "Select role: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
          checkboxInput("role_edit_new", "Add new?", value = add_new),
          conditionalPanel(condition = "input.role_edit_new == false",
                           uiOutput("role_edit_name")
                           
          )
      )
    ),
    
    fluidRow(
      uiOutput("role_edit_box")
    )
  ),
  
  conditionalPanel(condition = "input.role_action == 'Delete'",
    fluidRow(
      box(title = "Select role: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
          uiOutput("role_del_name"),
          conditionalPanel(condition = "output.role_del_name",
           actionButton("role_del_go", label = "Go",
            singleton(
              tags$head(tags$script(src = "message-handler.js"))
            ))
          )
      )
    )
  )
)