# This is the UI of a Shiny web application. 
library(shiny)
library(shinyjs)
library(shinythemes)

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
          
          # Input: Select layout
          selectInput("layoutSelect", "1. Select a layout:", choices = layout_names),
          
          # Only show this panel if user-defined layout has been chosen
          conditionalPanel(
            condition = "input.layoutSelect == '<<user-defined>>'",
            fileInput("layout_file", "Upload layout file", multiple = FALSE)
          ),
          
          fluidRow(
            column(gui_sidebar_radio_col_size,
              radioButtons("pixelRadio", label = "2. Analysis", inline = FALSE,
                choices = list(
                  "layout" = const_layout_plot,
                  "distcentreeucl" = const_pix_distcentreeucl,
                  "distcentrelinf" = const_pix_distcentrelinf,
                  "distcorner" = const_pix_distcorner,
                  "distedgescol" = const_pix_distedgescol,
                  "distedgesrow" = const_pix_distedgesrow,
                  "distedgesmin" = const_pix_distedgesmin), 
                selected = const_layout_plot))),
          
          actionButton("layoutPixels", "3. Plot analysis"), 
          
          hr(),
          
          verbatimTextOutput("app_summary")
        ),
        
        # Main panel
        mainPanel(
          tabsetPanel(type = "tabs", 
            tabPanel("Layout Analysis", 
              fluidRow(
                column(12, align="center",
                  fluidRow(plotOutput("layoutPlot"))))),
            
            tabPanel("Summary", 
                     verbatimTextOutput("layout_summary"))
          )
        )
      )
    ),
    
    ############################################################################
    ### Damaged Pixels Panel
    ############################################################################
    tabPanel("Damaged Pixels", 
      sidebarLayout(
        sidebarPanel(width = 4,
          fluidRow(
            verbatimTextOutput("loaded_layout_text2", placeholder = TRUE),           
            
            fileInput("dead_file", "4. Choose Pixel Damage File", multiple = TRUE),
  
            fixedRow(
              column(gui_sidebar_radio_col_size,
                     radioButtons("dead_radio", label = "5. Analysis", inline = FALSE,
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
            
            actionButton("layoutDeadPixels", "6. Plot analysis")
          ),
          fluidRow(
            hr(),
            p("Data upload to developers"),
            actionButton("deadPixelsUpload", "Upload data")
          )
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
                         fluidRow(plotOutput("dead_pixel_plot",
                                  click = "dead_pix_plot_click",
                                  dblclick = "dead_pix_plot_dbclick"))),
                  
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
            
            tabPanel("Sumarry", 
              verbatimTextOutput("dead_pixel_summary"))
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
          
          fluidRow(
            column(gui_sidebar_radio_col_size,
              radioButtons("fit_radio", label = "6. Model", inline = FALSE,
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
          
         actionButton("model_fit", "7. Fit"),
         
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
    #,
    # navbarMenu("More",
    #             tabPanel("Summary"),
    #             "----",
    #             "Section header",
    #             tabPanel("About")
    # )
  )
))
