# Shiny specific libs
library(shiny)
library(shinythemes)
library(shinydashboard)

# DB speciif libs
library(RJDBC)

# Other libs
library(reshape2)
library(R.utils)
library(dygraphs)
library(lubridate)
library(xts)
library(plotly)
library(stringr)
library(DT)
library(RJDBC)
library(dplyr)

# Set token for Plot.ly
p <- plot_ly(username = "devpog", key = "dvx0rb722c")

shinyServer(function(input, output, session){
  source("external/app.R", local = T)
})
