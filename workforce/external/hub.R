fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  fluidRow(
    box(title = "Action: ", collapsible = T, collapsed = F, width = 3, status = "primary",
        selectInput("hub_action", label = NULL, choices = c("Show", "Edit", "Delete"))
    )
  ),
  
  conditionalPanel(condition = "input.hub_action == 'Show'",
    fluidRow(  
      box(title = " ", collapsible = T, collapsed = F, width = 3, status = "primary", 
          DT::dataTableOutput("hub_table")
      )
    )
  ),
  
  conditionalPanel(condition = "input.hub_action == 'Edit'",
    fluidRow(
      box(title = "Select hub: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
          checkboxInput("hub_edit_new", "Add new?", value = add_new),
          conditionalPanel(condition = "input.hub_edit_new == false",
                           uiOutput("hub_edit_name")
                           
          )
      )
    ),
    
    fluidRow(
      uiOutput("hub_edit_box")
    )
  ),
  
  conditionalPanel(condition = "input.hub_action == 'Delete'",
    fluidRow(
      box(title = "Select hub: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
          uiOutput("hub_del_name"),
          conditionalPanel(condition = "output.hub_del_name",
           actionButton("hub_del_go", label = "Go",
            singleton(
              tags$head(tags$script(src = "message-handler.js"))
            ))
          )
      )
    )
  )
)