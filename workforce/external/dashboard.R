library(shinydashboard)

dashboard <- dashboardPage(
  header = dashboardHeader(title = "WorkForce"),
  sidebar = source(file.path(dashboard_dir, 'sidebar.R'), local = T)$value,
  body = source(file.path(dashboard_dir, 'body.R'), local = T)$value
)