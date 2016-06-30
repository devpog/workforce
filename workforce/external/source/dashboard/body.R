library(shinydashboard)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "tabHub",
            h2("Hub"),
            source(file.path(external_dir, "hub.R"), local = T)$value
    ),
    tabItem(tabName = "tabClient",
            h2("Client"),
            source(file.path(external_dir, "client.R"), local = T)$value
    ),
    tabItem(tabName = "tabRole",
            h2("Role"),
            source(file.path(external_dir, "role.R"), local = T)$value
    ),
    tabItem(tabName = "tabResource",
            h2("Resource"),
            source(file.path(external_dir, "resource.R"), local = T)$value
    ),
    tabItem(tabName = "tabProject",
            h2("Project"),
            source(file.path(external_dir, "project.R"), local = T)$value
    )
  )
)