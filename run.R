
source("global.R")
source("ui.R")
source("server.R")

shiny::runApp(
  appDir = ".",
  port = 1111,
  host = "0.0.0.0",
  launch.browser = FALSE
)
