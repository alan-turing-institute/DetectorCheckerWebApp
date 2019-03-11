
source("global.R")
source("ui.R")
source("server.R")
source("gui_utils.R")

shiny::runApp(
  appDir = ".",
  port = 1111,
  host = "0.0.0.0",
  launch.browser = FALSE
)
