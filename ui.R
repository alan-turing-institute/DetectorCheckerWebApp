# This is the UI of a Shiny web application. 
library(shiny)
library(shinythemes)

# Define UI for application 
shinyUI(fluidPage(theme = shinytheme("flatly"),
                  
  navbarPage("DetectorChecker",
             
    tabPanel("Layout",
      sidebarLayout(
        # Sidebar
        sidebarPanel(
          
          # Input: Select layout
          selectInput("layoutSelect", "Select a layout:", choices = layout_names),
          
          actionButton("layoutLoad", "Load"),

          hr(),
          
          fluidRow(
            column(gui_sidebar_radio_col_size,
              radioButtons("pixelRadio", label = "Analysis", inline = FALSE,
                choices = list(
                  "layout" = const_layout_plot,
                  "distcentreeucl" = const_pix_distcentreeucl,
                  "distcentrelinf" = const_pix_distcentrelinf,
                  "distcorner" = const_pix_distcorner,
                  "distedgescol" = const_pix_distedgescol,
                  "distedgesrow" = const_pix_distedgesrow,
                  "distedgesmin" = const_pix_distedgesmin), 
                selected = const_layout_plot))),
          
          hr(),
          
          actionButton("layoutPixels", "Plot"), 
          
          hr(),
          
          verbatimTextOutput("app_summary")
        ),
      
        # Main panel
        mainPanel(
          tabsetPanel(type = "tabs", 
            tabPanel("Layout Analysis", 
                     plotOutput("layoutPlot"), 
                     style = "width:100%"),
            
            tabPanel("Sumarry", 
                     verbatimTextOutput("layout_summary"))
          )
        )
      )
    ),
    
    tabPanel("Damaged Pixels", 
      sidebarLayout(
        sidebarPanel(width = 4,
          fileInput("dead_file", "Choose Pixel Damage File", multiple = TRUE),
          
          actionButton("dead_pix_load", "Load"),
          
          hr(),
          
          fixedRow(
            column(gui_sidebar_radio_col_size,
                   radioButtons("dead_radio", label = "Analysis", inline = FALSE,
                                choices = list(
                                  # "Damage" = const_dead_plot,
                                  "Density" = const_dead_density_plot,
                                  "Counts" = const_dead_counts,
                                  "Arrows" = const_dead_arrows,
                                  "Angles" = const_dead_angles,
                                  "K-func." = const_dead_K,
                                  "F-func." = const_dead_F,
                                  "G-func." = const_dead_G,
                                  "Inhom. K-func." = const_dead_inhom_K,
                                  "Inhom. F-func." = const_dead_inhom_F,
                                  "Inhom. G-func." = const_dead_inhom_G
                                  ), 
                                selected = const_dead_density_plot))),
          
          actionButton("layoutDeadPixels", "Plot")
        ),
               
        # Main panel
        mainPanel(
          tabsetPanel(type = "tabs", 
            tabPanel("Damaged Pixels Analysis", 
              fluidRow(
                # --------------------------------------------------------------
                # LAYOUT ANALYSIS
                # --------------------------------------------------------------
                fluidRow(
                  column(8, align="center",
                    fluidRow(verbatimTextOutput("layout_analysis_caption")))
                ),
                
                fluidRow(
                  column(4, align="center",
                    fluidRow(verbatimTextOutput("layout_analysis_left_caption"))),
                  
                  column(4, align="center",
                    fluidRow(verbatimTextOutput("layout_analysis_right_caption")))
                ),
                
                fluidRow(
                  column(4, align="center",
                         fluidRow(plotOutput("dead_pixel_plot",
                                  click = "dead_pix_plot_click",
                                  dblclick = "dead_pix_plot_dbclick"))),
                  
                  column(4, align="center",
                         fluidRow(plotOutput("dead_pixel_analysis_plot")))
                ) ,
                
                # --------------------------------------------------------------
                # MODULE ANALYSIS
                # --------------------------------------------------------------
                fluidRow(
                  column(8, align="center",
                    fluidRow(verbatimTextOutput("module_analysis_caption")))
                ), 
                
                fluidRow(
                  column(4, align="center",
                         fluidRow(verbatimTextOutput("module_analysis_left"))),
                  
                  column(4, align="center",
                         fluidRow(verbatimTextOutput("module_analysis_right")))
                ),
                
                fluidRow(
                  column(4, align="center",
                         fluidRow(plotOutput("dead_pixel_module_plot"))),
                  
                  column(4, align="center",
                         fluidRow(plotOutput("dead_pixel_module_analysis_plot")))
                )
              ), style = "width:100%"),
            
            tabPanel("Sumarry", 
              verbatimTextOutput("dead_pixel_summary"))
          ),
        width = 8)
      )
    ),
    
    tabPanel("Model fitting", 
      sidebarLayout(
        sidebarPanel(
          fluidRow(
            column(gui_sidebar_radio_col_size,
              radioButtons("fit_radio", label = "Model", inline = FALSE,
                choices = list(
                  "Pix cntr eucl" = const_model_fit_centreeucl,
                  "Pix cntr inf" = const_model_fit_centrlinf,
                  "Pix dist edge col" = const_model_fit_distedgecol,
                  "Pix dist edge row" = const_model_fit_distedgerow
                  # "Custom" = const_model_fit_custom
                ), 
                selected = const_model_fit_centreeucl))
              # textInput("custom_model", label = "", value = "Enter model expression")
            ),
          
         actionButton("model_fit", "Fit"),
         
         hr()
        ),
        
        mainPanel(
          tabsetPanel(type = "tabs", 
            tabPanel("Output", 
                     verbatimTextOutput("model_fit_summary"))
          )
        )
      )
    )

    # navbarMenu("More",
    #             tabPanel("Summary"),
    #             "----",
    #             "Section header",
    #             tabPanel("About")
    # )
  )
))
