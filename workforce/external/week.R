fluidPage(
  tags$head(tags$script(src = "message-handler.js")),
  fluidRow(
    box(title = "Action: ", collapsible = T, collapsed = F, width = 3, status = "primary",
        selectInput("week_action", label = NULL, choices = c("Show", "Edit", "Delete"))
    )
  ),
  
  fluidRow(
    box(title = "Hub: ", collapsible = T, collapsed = F, width = 3, status = "primary",
      conditionalPanel(condition = "input.week_edit_new == false",
        uiOutput("week_hub")
      ),
      
      conditionalPanel(condition = "input.week_action == 'Show'",
        checkboxInput("week_show_all_hubs", label = "Show all?", value = F)
      )
    )
  ),

  conditionalPanel(condition = "input.week_action == 'Show'",
                   fluidRow(  
                     box(title = " ", collapsible = T, collapsed = F, width = 3, status = "primary", 
                         DT::dataTableOutput("week_table")
                     )
                   )
  ),
  
  conditionalPanel(condition = "input.week_action == 'Edit'",
                   fluidRow(
                     box(title = "Select week: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
                         checkboxInput("week_edit_new", "Add new?", value = F),
                         conditionalPanel(condition = "input.week_edit_new == false",
                                          uiOutput("week_edit_name")
                                          
                         )
                     )
                   ),
                   
                   fluidRow(
                     uiOutput("week_edit_box")
                   )
  ),
  
  conditionalPanel(condition = "input.week_action == 'Delete'",
                   fluidRow(
                     box(title = "Select week: ", collapsible = T, collapsed = F, width = 3, status = "primary", 
                         uiOutput("week_del_name"),
                         conditionalPanel(condition = "output.week_del_name",
                                          actionButton("week_del_go", label = "Go",
                                                       singleton(
                                                         tags$head(tags$script(src = "message-handler.js"))
                                                       ))
                         )
                     )
                   )
  )
)