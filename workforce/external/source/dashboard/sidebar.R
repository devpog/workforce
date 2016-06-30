library(shinydashboard)
source("global.R", local = T)

sidebar <- dashboardSidebar(
  sidebarMenu(id = "menu_sidebar",
              menuItem("Hub", tabName = "tabHub", icon = icon("globe")),
              menuItem("Client", tabName = "tabClient", icon = icon("briefcase")),
              menuItem("Role", tabName = "tabRole", icon = icon("tasks")),
              menuItem("Resource", tabName = "tabResource", icon = icon("user")),
              menuItem("Project", tabName = "tabProject", icon = icon("th-list")),
              menuItem("Week", tabName = "tabProject", icon = icon("calendar"))
  )
)