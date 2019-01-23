# This is the UI of a Shiny web application. 
library(shiny)
library(shinyjs)
library(shinyBS)
library(shinythemes)
library(spatstat)
library(shinydashboard)
source("global.R")

# Define UI for application 
shinyUI(fluidPage(theme = shinytheme("flatly"),
                  useShinyjs(),
  navbarPage("DetectorChecker",
    ############################################################################
    ### Layout Panel
    ############################################################################
    tabPanel("Layout",
      sidebarLayout(
        # Sidebar
        sidebarPanel(width = 4,
          verbatimTextOutput("loaded_layout_text1", placeholder = TRUE), 
          
          bsTooltip("loaded_layout_text1", tt_selected_layout, 
            placement = "right", options = list(container = "body")),

          # Input: Select layout
          selectInput("layoutSelect", 
                      label = h4("1. Select Layout",
                                 tags$style(type = "text/css", "#q1 {vertical-align: top;}"),
                                 bsButton("q1", label = "", icon = icon("question"), style = "info", size = "extra-small")             
                      ), choices = layout_names),
          
          
          bsPopover(id = "q1", title = "1. Select Layout",
                    content = tt_select_input,
                    placement = "right", 
                    trigger = "focus", 
                    options = list(container = "body")
          ),
          

          # Only show this panel if user-defined layout has been chosen
          conditionalPanel(
            condition = "input.layoutSelect == '<<user-defined>>'",
            fileInput("layout_file", multiple = FALSE, 
              label = h5("Upload layout file", 
                         tags$style(type = "text/css", "#q {vertical-align: top;}"),
                         bsButton("q", label = "", icon = icon("question"), style = "info", size = "extra-small")
              )),

            bsPopover(id = "q", title = "Upload layout file",
              content = paste(tt_custom_layout, tt_custom_example),
              placement = "right", 
              trigger = "focus", 
              options = list(container = "body")
            )
          ),
          
          fluidRow(
            column(12,
              radioButtons("pixelRadio", 
                label = h4("2. Visualisation", 
                  tags$style(type = "text/css", "#q3 {vertical-align: top;}"),
                  bsButton("q2", label = "", icon = icon("question"), 
                    style = "info", size = "extra-small")), 
                inline = FALSE,
                choices = list(
                  "layout" = const_layout_plot,
                  "euclidean distance from centre" = const_pix_distcentreeucl,
                  "L-infinity distance from centre" = const_pix_distcentrelinf,
                  "euclidean distance to nearest corner" = const_pix_distcorner,
                  "horizontal distance to nearest sub-panel edge" = const_pix_distedgescol,
                  "vertical distance to nearest sub-panel edge" = const_pix_distedgesrow,
                  "L-infinity distance to nearest sub-panel edge" = const_pix_distedgesmin), 
                selected = const_layout_plot)),
            bsPopover(id = "q2", title = "2. Visualisation",
                      content = paste(tt_layout_analysis),
                      placement = "right", 
                      trigger = "focus", 
                      options = list(container = "body")
            )),
          
          actionButton("layoutPixels", "Display plot"), 
          
          hr(),
          
          verbatimTextOutput("app_summary"),
          bsTooltip("app_summary", tt_version, 
            placement = "right", options = list(container = "body"))
        ),
        
        # Main panel
        mainPanel(
          tabsetPanel(type = "tabs", 
            tabPanel("Layout Analysis", 
              fluidRow(
                column(12, align="center",
                  fluidRow(

                    checkboxInput("javascriptWarning", label = "JavaScript is not enabled! For the best experience, use a modern web browser which supports HTML5 technology (such as, Google Chrome v. 70.0 or later, Mozilla Firefox v. 62.0 or later, or similar) with JavaScript being enabled.", value = TRUE),
                    
                    plotOutput("layoutPlot", width="600px", height="600px")
                    #,
                    # bsPopover(id = "layoutPlot", title = "Layout",
                    #          content = tt_layout,
                    #          trigger = 'hover', 
                    #          options = list(container = "body")
                    # )
                    )))),
            
            tabPanel("Summary", 
                     verbatimTextOutput("layout_summary"),
                     bsPopover(id = "layout_summary", title = "Layout summary",
                               content = tt_layout_summary,
                               trigger = 'hover', 
                               options = list(container = "body")
                     ))
          )
        )
      )
    ),
    
    ############################################################################
    ### Damaged Pixels Panel
    ############################################################################
    tabPanel("Damage", 
      sidebarLayout(
        sidebarPanel(width = 4,
          
          verbatimTextOutput("loaded_layout_text2", placeholder = TRUE),           
          
          bsTooltip("loaded_layout_text2", tt_selected_layout, 
            placement = "right", options = list(container = "body")),
          
          fileInput("dead_file", 
            label = h4("3. Import File", 
              tags$style(type = "text/css", "#q3 {vertical-align: top;}"),
              bsButton("q3", label = "", icon = icon("question"), 
                style = "info", size = "extra-small")), 
            multiple = TRUE),
          
          bsPopover(id = "q3", title = "3. Import File", content = tt_dead_file,
            placement = "right", trigger = "focus", options = list(container = "body")),

          radioButtons("level_radio", 
            label = h4("4. Choose Level", 
              tags$style(type = "text/css", "#q4 {vertical-align: top;}"),
              bsButton("q4", label = "", icon = icon("question"), style = "info", size = "extra-small")),
            choices = list("Pixels" = const_level_pixels, "Events (Currently slow)" = const_level_events),
            selected = const_level_pixels),
 
          bsPopover(id = "q4", title = "4. Choose Level",
            placement = "right", trigger = "focus", options = list(container = "body"),
            content = tt_dead_level),
          
          # Only show this panel if user-defined layout has been chosen
          conditionalPanel(
            condition = "input.level_radio == 'Events'",
            checkboxGroupInput("events_chk_group", label = h5("Incl. event types"), 
              choices = list("1 - Singleton" = 1, "2 - Doublet" = 2, "3 - Triplet" = 3, "4 - Larger clusters" = 4, 
                             "5 - Upper horizontal lines" = 5, "6 - Lower horizontal lines" = 6, 
                             "7 - Left vertical lines" = 7, "8 - Right vertical lines" = 8),
              selected = 1:8, inline = FALSE)
          ),
          
          actionButton("layoutLevelAnalysis", "Plot"),
          
          radioButtons("dead_radio", inline = FALSE,
            label = h4("5. Choose Analysis", 
              tags$style(type = "text/css", "#q5 {vertical-align: top;}"),
              bsButton("q5", label = "", icon = icon("question"), style = "info", size = "extra-small")), 
            choices = list(
              "Density" = const_density_plot,
              "Counts" = const_counts,
              "Arrows" = const_arrows,
              "Angles" = const_angles,
              "K-func." = const_K,
              "F-func." = const_F,
              "G-func." = const_G,
              "Inhom. K-func." = const_inhom_K,
              "Inhom. F-func." = const_inhom_F,
              "Inhom. G-func." = const_inhom_G), 
            selected = const_density_plot),
          
          bsPopover(id = "q5", title = "5. Choose Analysis",
            content = tt_dead_analysis,
            placement = "right",
            trigger = "focus",
            options = list(container = "body")),
          
          actionButton("layoutDeadPixels", "Plot"),

          hr(),
          
          textInput("user_email", 
            label = h4("6. Send Data", 
              tags$style(type = "text/css", "#q6 {vertical-align: top;}"),
              bsButton("q6", label = "", icon = icon("question"), style = "info", size = "extra-small")), 
            placeholder = "Your email address.."),
          
          bsPopover(id = "q6", title = "6. Send Data",
            placement = "right", trigger = "focus", options = list(container = "body"),
            content = paste(tt_upload_button, tt_email)),
        
          actionButton("deadPixelsUpload", "Send")
      
        ),       
        
        # Main panel
        mainPanel(
          tabsetPanel(type = "tabs", 
            tabPanel("Analysis", 
              fluidRow(
                # --------------------------------------------------------------
                # LAYOUT ANALYSIS
                # --------------------------------------------------------------
                fluidRow(
                  column(12, align="center",
                    fluidRow(verbatimTextOutput("layout_analysis_caption")))
                ),
                
                fluidRow(
                  column(6, align="center",
                    fluidRow(verbatimTextOutput("layout_analysis_left_caption"))),
                  
                  column(6, align="center",
                    fluidRow(verbatimTextOutput("layout_analysis_right_caption")))
                ),
                
                fluidRow(
                  column(6, align="center",
                         fluidRow(
                           plotOutput("dead_pixel_plot",
                             click = "dead_pix_plot_click",
                             dblclick = "dead_pix_plot_dbclick")
                           
                           # ,
                           # bsPopover(id = "dead_pixel_plot", title = "Damaged layout",
                           #   content = tt_damaged_layout_clicks,
                           #   placement = "right",
                           #   trigger = "hover",
                           #   options = list(container = "body")
                           #  )
                           )),
                  
                  column(6, align="center",
                         fluidRow(plotOutput("dead_pixel_analysis_plot")))
                ) ,
                
                # --------------------------------------------------------------
                # MODULE ANALYSIS
                # --------------------------------------------------------------
                fluidRow(
                  column(12, align="center",
                    fluidRow(verbatimTextOutput("module_analysis_caption")))
                ), 
                
                fluidRow(
                  column(6, align="center",
                         fluidRow(verbatimTextOutput("module_analysis_left"))),
                  
                  column(6, align="center",
                         fluidRow(verbatimTextOutput("module_analysis_right")))
                ),
                
                fluidRow(
                  column(6, align="center",
                         fluidRow(plotOutput("dead_pixel_module_plot"))),
                  
                  column(6, align="center",
                         fluidRow(plotOutput("dead_pixel_module_analysis_plot")))
                )
              )),
            
            tabPanel("Summary", 
              verbatimTextOutput("dead_pixel_summary"),
              bsPopover(id = "dead_pixel_summary", title = "Damaged pixels",
                content = tt_dead_pixels_summary,
                trigger = 'hover', 
                options = list(container = "body")
              ))
          ),
        width = 8)
      )
    ),
    
    ############################################################################
    ### Model Fitting Panel
    ############################################################################
    tabPanel("Model fitting", 
      sidebarLayout(
        sidebarPanel(width = 4,
          verbatimTextOutput("loaded_layout_text3", placeholder = TRUE),           
          bsTooltip("loaded_layout_text3", tt_selected_layout, "right", options = list(container = "body")),
          
          verbatimTextOutput("loaded_layout_text4", placeholder = TRUE),
          
          fluidRow(
            column(12,
              radioButtons("fit_radio", 
                label = h4("7. Modelling Damage Intensity",
                           tags$style(type = "text/css", "#q7 {vertical-align: top;}"),
                  bsButton("q7", label = "", icon = icon("question"), style = "info", size = "extra-small")), 
                inline = FALSE,
                choices = list(
                  "euclidean distance from centre" = const_model_fit_centreeucl,
                  "L-infinity distance from centre" = const_model_fit_centrlinf,
                  "horizontal distance to nearest sub-panel edge" = const_model_fit_distedgecol,
                  "vertical distance to nearest sub-panel edge" = const_model_fit_distedgerow
                ), 
                selected = const_model_fit_centreeucl)),
            
            bsPopover(id = "q7", title = "7. Modelling Damage Intensity",
              content = tt_model,
              placement = "right",
              trigger = "focus",
              options = list(container = "body"))),
          
          actionButton("model_fit", "Fit model")
        ),
        
        mainPanel(
          tabsetPanel(type = "tabs", 
            tabPanel("Output", 
              verbatimTextOutput("model_fit_summary")
              # bsPopover(id = "model_fit_summary", title = "Model fitting",
              #   content = tt_model_fit,
              #   trigger = 'hover', 
              #   options = list(container = "body")
              # )
              )
          )
        )
      )
    ),
    navbarMenu("Help",
      # tabPanel("Summary"),
      "----",
      HTML('<div align="left"><a href="https://github.com/tomaslaz/DetectorChecker/tree/master/examples" target="_blank" style="text-decoration:none">Examples</a></div>'),
      HTML('<div align="left"><a href="https://github.com/tomaslaz/DetectorChecker/blob/master/Manual.pdf" target="_blank" style="text-decoration:none">Manual</a></div>'),
      tabPanel("About", helpText(HTML(about_text)))
    )
  )
))
