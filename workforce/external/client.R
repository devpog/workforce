fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  fluidRow(
    box(title = "Action: ", collapsible = T, collapsed = F, width = 3, status = "primary",
        selectInput("client_action", label = NULL, choices = c("Show", "Edit", "Delete"))
    )
  ),
  
  fluidRow(
    box(title = "Hub: ", collapsible = T, collapsed = F, width = 3, status = "primary",
      conditionalPanel(condition = "input.client_edit_new == false",
        uiOutput("client_hub")
      ),
      
      conditionalPanel(condition = "input.client_action == 'Show'",
        checkboxInput("client_show_all_hubs", label = "Show all?", value = F)
      )
    )
  ),

  conditionalPanel(condition = "input.client_action == 'Show'",
                   fluidRow(  
                     box(title = " ", collapsible = T, collapsed = F, width = 3, status = "primary", 
                         DT::dataTableOutput("client_table")
                     )
                   )
  ),
  
  conditionalPanel(condition = "input.client_action == 'Edit'",
                   fluidRow(
                     box(title = "Select client: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
                         checkboxInput("client_edit_new", "Add new?", value = F),
                         conditionalPanel(condition = "input.client_edit_new == false",
                                          uiOutput("client_edit_name")
                                          
                         )
                     )
                   ),
                   
                   fluidRow(
                     uiOutput("client_edit_box")
                   )
  ),
  
  conditionalPanel(condition = "input.client_action == 'Delete'",
                   fluidRow(
                     box(title = "Select client: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
                         uiOutput("client_del_name"),
                         conditionalPanel(condition = "output.client_del_name",
                                          actionButton("client_del_go", label = "Go",
                                                       singleton(
                                                         tags$head(tags$script(src = "message-handler.js"))
                                                       ))
                         )
                     )
                   )
  )
)