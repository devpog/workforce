library(plotly)
library(RMySQL)
library(stringr)
library(plyr)

source("functions.R")

work_dir <- getwd()
csv_dir <- file.path(work_dir, 'csv')
data_dir <- file.path(work_dir, 'data')
lib_dir <- file.path(work_dir, 'lib')
external_dir <- file.path(work_dir, 'external')
source_dir <- file.path(external_dir, 'source')

client_dir <- file.path(source_dir, 'client')
hub_dir <- file.path(source_dir, 'hub')
role_dir <- file.path(source_dir, 'role')
resource_dir <- file.path(source_dir, 'resource')
project_dir <- file.path(source_dir, 'project')
dashboard_dir <- file.path(source_dir, 'dashboard')

db_host <- '127.0.0.1'
db_port <- 9160
db_keyspace <- 'cognitive'
db_drv <- "org.apache.cassandra.cql.jdbc.CassandraDriver"
jars <- list.files(lib_dir, pattern = "jar$", full.names = T)

action_choices <- c("Show", "Edit", "Delete")
project_phases <- c("Won", "In-Legal", "Scoped")
global_roles <- c("Partnerships Lead", "Business Architect", "Technical Architect", "Project Lead", "Implementation Engineer", "Support Engineer")
add_new <- T