library(shinythemes)

shinyUI(
  fluidPage(theme = "sandstone.css",
            tags$style(type="text/css",
                       ".shiny-output-error { visibility: hidden; }",
                       ".shiny-output-error:before { visibility: hidden; }"
            ),
            tags$head(
              tags$style(HTML("
                .multicol {
                  -webkit-column-count: 3; /* Chrome, Safari, Opera */
                  -moz-column-count: 3; /* Firefox */
                  column-count: 3;
                }
              ")
              )
            ),
            title = "WorkForce",
            fluidRow(source("external/dashboard.R", local = T)$value)
  )
)