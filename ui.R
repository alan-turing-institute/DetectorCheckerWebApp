# This is the UI of a Shiny web application. 
library(shiny)
library(shinyjs)
library(shinyBS)
library(shinythemes)
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
        sidebarPanel(
          verbatimTextOutput("loaded_layout_text1", placeholder = TRUE), 
          
          bsTooltip("loaded_layout_text1", tt_selected_layout, 
            placement = "right", options = list(container = "body")),

          # Input: Select layout
          selectInput("layoutSelect", label = h4("1. Select Layout"), choices = layout_names),
          bsTooltip("layoutSelect", tt_select_input, 
            placement = "right", options = list(container = "body")),
          
          # Only show this panel if user-defined layout has been chosen
          conditionalPanel(
            condition = "input.layoutSelect == '<<user-defined>>'",
            fileInput("layout_file", multiple = FALSE, 
              label = h5("Upload layout file", 
                         tags$style(type = "text/css", "#q1 {vertical-align: top;}"),
                         bsButton("q1", label = "", icon = icon("question"), style = "info", size = "extra-small")
              )),

            bsPopover(id = "q1", title = "Custom layout file",
              content = paste(tt_custom_layout, tt_custom_example),
              placement = "right", 
              trigger = "focus", 
              options = list(container = "body")
            )
          ),
          
          fluidRow(
            column(gui_sidebar_radio_col_size,
              radioButtons("pixelRadio", 
                label = h4("2. Visualisation", 
                  tags$style(type = "text/css", "#q2 {vertical-align: top;}"),
                  bsButton("q2", label = "", icon = icon("question"), 
                    style = "info", size = "extra-small")), 
                inline = FALSE,
                choices = list(
                  "layout" = const_layout_plot,
                  "distcentreeucl" = const_pix_distcentreeucl,
                  "distcentrelinf" = const_pix_distcentrelinf,
                  "distcorner" = const_pix_distcorner,
                  "distedgescol" = const_pix_distedgescol,
                  "distedgesrow" = const_pix_distedgesrow,
                  "distedgesmin" = const_pix_distedgesmin), 
                selected = const_layout_plot)),
            bsPopover(id = "q2", title = "Layout analysis",
                      content = paste(tt_layout_analysis),
                      placement = "right", 
                      trigger = "focus", 
                      options = list(container = "body")
            )),
          
          actionButton("layoutPixels", "3. Plot"), 
          
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
                    plotOutput("layoutPlot"),
                    bsPopover(id = "layoutPlot", title = "Layout",
                             content = tt_layout,
                             trigger = 'hover', 
                             options = list(container = "body")
                    ))))),
            
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
        sidebarPanel(
          
          verbatimTextOutput("loaded_layout_text2", placeholder = TRUE),           
          
          bsTooltip("loaded_layout_text2", tt_selected_layout, 
            placement = "right", options = list(container = "body")),
          
          fileInput("dead_file", 
            label = h4("4. Import File", 
              tags$style(type = "text/css", "#q3 {vertical-align: top;}"),
              bsButton("q3", label = "", icon = icon("question"), 
                style = "info", size = "extra-small")), 
            multiple = TRUE),
          
          bsPopover(id = "q3", title = "4. Import File", content = tt_dead_file,
            placement = "right", trigger = "focus", options = list(container = "body")),

          radioButtons("level_radio", 
            label = h4("5. Choose Level", 
              tags$style(type = "text/css", "#q4 {vertical-align: top;}"),
              bsButton("q5", label = "", icon = icon("question"), style = "info", size = "extra-small")),
            choices = list("Pixels" = const_level_pixels, "Events" = const_level_events),
            selected = const_level_pixels),
 
          bsPopover(id = "q5", title = "Analysis level",
            placement = "right", trigger = "focus", options = list(container = "body"),
            content = tt_dead_level),
          
          radioButtons("dead_radio", inline = FALSE,
            label = h4("6. Choose Analysis", 
              tags$style(type = "text/css", "#q4 {vertical-align: top;}"),
              bsButton("q6", label = "", icon = icon("question"), style = "info", size = "extra-small")), 
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
          
          bsPopover(id = "q6", title = "Damage analysis",
            content = tt_dead_analysis,
            placement = "right",
            trigger = "focus",
            options = list(container = "body")),
              
          actionButton("layoutDeadPixels", "7. Plot"),

          hr(),
          
          textInput("user_email", 
            label = h4("8. Send Data", 
              tags$style(type = "text/css", "#q5 {vertical-align: top;}"),
              bsButton("q8", label = "", icon = icon("question"), style = "info", size = "extra-small")), 
            value = "Email address.."),
          
          bsPopover(id = "q8", title = "Data upload",
            placement = "right", trigger = "focus", options = list(container = "body"),
            content = paste(tt_email, tt_upload_button)),
        
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
                             dblclick = "dead_pix_plot_dbclick"),
                                  
                                  
                           bsPopover(id = "dead_pixel_plot", title = "Damaged layout",
                             content = tt_damaged_layout_clicks,
                             placement = "right",
                             trigger = "hover",
                             options = list(container = "body")
                            ))),
                  
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
        sidebarPanel(
          verbatimTextOutput("loaded_layout_text3", placeholder = TRUE),           
          bsTooltip("loaded_layout_text3", tt_selected_layout, "right", options = list(container = "body")),
          
          fluidRow(
            column(gui_sidebar_radio_col_size,
              radioButtons("fit_radio", 
                label = h4("9. Modelling",
                           tags$style(type = "text/css", "#q6 {vertical-align: top;}"),
                  bsButton("q9", label = "", icon = icon("question"), style = "info", size = "extra-small")), 
                inline = FALSE,
                choices = list(
                  "Pix cntr eucl" = const_model_fit_centreeucl,
                  "Pix cntr inf" = const_model_fit_centrlinf,
                  "Pix dist edge col" = const_model_fit_distedgecol,
                  "Pix dist edge row" = const_model_fit_distedgerow
                ), 
                selected = const_model_fit_centreeucl)),
            
            bsPopover(id = "q9", title = "Model fitting",
              content = tt_model,
              placement = "right",
              trigger = "focus",
              options = list(container = "body"))),
          
          actionButton("model_fit", "10. Fit model")
        ),
        
        mainPanel(
          tabsetPanel(type = "tabs", 
            tabPanel("Output", 
              verbatimTextOutput("model_fit_summary"),
              bsPopover(id = "model_fit_summary", title = "Model fitting",
                content = tt_model_fit,
                trigger = 'hover', 
                options = list(container = "body")
              ))
          )
        )
      )
    ),
    navbarMenu("More",
      # tabPanel("Summary"),
      "----",
      # "Section header",
      tabPanel("About")
    )
  )
))
