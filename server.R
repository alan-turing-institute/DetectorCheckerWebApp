# This is the server logic of a Shiny web application. 

# Maximum size of an upload file 30 MB
options(shiny.maxRequestSize=30*1024^2) 

library(shiny)
library(shinythemes)
library(ggplot2)
# library(Cairo)
library(detectorchecker)
library(spatstat)

# We'll use a subset of the mtcars data set, with fewer columns
# so that it prints nicely
mtcars2 <- mtcars[, c("mpg", "cyl", "disp", "hp", "wt", "am", "gear")]

# Define server
shinyServer(function(input, output, session) {

  # load layouts
  layout_names <- detectorchecker::available_layouts
  
  # refresh layout select
  updateSelectInput(session, const_ui_layoutSelectInput, choices = layout_names)
  
  output$app_summary <- renderPrint({
    cat(paste(paste("detectorchecker v: ", packageVersion("detectorchecker"), sep=""), 
              paste("webapp v: ", webapp_version, sep=""), 
              sep="\n"))
        
  })
  
  # Load layout
  observeEvent(input$layoutLoad, {
    # check whether a model has been selected
    if (input$layoutSelect == const_layout_default) {
      showModal(modalDialog(
        title = "Error",
        "Layout model has not been selected."
      ))

    } else {
      withProgress({
        setProgress(message = "Loading layout...")
        layout <<- detectorchecker::create_module(input$layoutSelect)
        
        setProgress(message = "Rendering layout...")
        
        output$layoutPlot <- renderPlot({detectorchecker::plot_layout(layout)}, 
                                        width = "auto", height = "auto")
        
        output$layout_summary <- renderPrint({
          cat(detectorchecker::layout_summary(layout))
        })
        
        setProgress(message = "Finished!", value = 1.0)
      })
    }
  })
  
  # Plot the selected layout pixel analysis
  observeEvent(input$layoutPixels, {

    # check whether a model has been selected
    if (input$layoutSelect == const_layout_default) {
      showModal(modalDialog(
        title = "Error",
        "Layout model has not been selected."))

    } else {
      # select appropriate action with respect to the radio button
      if (input$pixelRadio == const_layout_plot) {
        withProgress({
          setProgress(message = "Rendering layout...")

          output$layoutPlot <- renderPlot({detectorchecker::plot_layout(layout)}, 
                     width = "auto", height = "auto")

          setProgress(message = "Finished!", value = 1.0)
        })
      
      } else {
        
        withProgress({
          setProgress(message = "Rendering analysis...")
          
          if (input$pixelRadio == const_pix_distcentreeucl) {  
            
            output$layoutPlot <- renderPlot({detectorchecker::plot_pixel_ctr_eucl(layout)}, 
                       width = "auto", height = "auto")
            
          } else if (input$pixelRadio == const_pix_distcentrelinf) { 
            
            output$layoutPlot <- renderPlot({detectorchecker::plot_pixel_ctr_linf(layout)}, 
                       width = "auto", height = "auto")
            
          } else if (input$pixelRadio == const_pix_distcorner) {  
            
            output$layoutPlot <- renderPlot({detectorchecker::plot_pixel_dist_corner(layout)}, 
                       width = "auto", height = "auto")
            
          } else if (input$pixelRadio == const_pix_distedgescol) {  
            
            output$layoutPlot <- renderPlot({detectorchecker::plot_pixel_dist_edge_col(layout)}, 
                       width = "auto", height = "auto")
            
          } else if (input$pixelRadio == const_pix_distedgesrow) {  
            
            output$layoutPlot <- renderPlot({detectorchecker::plot_pixel_dist_edge_row(layout)}, 
                       width = "auto", height = "auto")
            
          } else if (input$pixelRadio == const_pix_distedgesmin) {  
            
            output$layoutPlot <- renderPlot({detectorchecker::plot_pixel_dist_edge(layout)}, 
                       width = "auto", height = "auto")
            
          } else {
            showModal(modalDialog(
              title = "Error",
              "Layout pixel analysis function is not implemented."))
          }
          
          setProgress(message = "Finished!", value = 1.0)
        })
      }
    }
  })
  
  # Load dead pixels
  observeEvent(input$dead_pix_load, {
    
    if (is.null(layout) || is.na(layout))
      return(NULL)
    
    dead_file <- input$dead_file
    
    if (is.null(input$dead_file))
      return(NULL)
    
    withProgress({
      setProgress(message = "Reading in data...")
      
      layout <<- detectorchecker::load_pix_matrix(layout = layout, 
                                                  file_path = dead_file$datapath)
      
      setProgress(message = "Analysing damage...")
      layout <<- detectorchecker::get_dead_stats(layout)
      
      setProgress(message = "Rendering damage...")
      output$dead_pixel_plot <- renderPlot({detectorchecker::plot_layout_damaged(layout)}, 
                                           width = "auto", height = "auto")
      
      setProgress(message = "Preparing summary...")
      
      output$dead_pixel_summary <- renderPrint({
        cat(detectorchecker::dead_stats_summary(layout))
      })
      
      setProgress(message = "Finished!", value = 1.0)
    })
  })
  
  # Plot the selected layout pixel analysis
  observeEvent(input$layoutDeadPixels, {
    
    if (is.null(layout) || is.na(layout) || is.na(layout$dead_stats))
      return(NULL)
    
    withProgress({
      
      if (input$dead_radio == const_dead_plot) {
        
        setProgress(message = "Rendering layout...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_layout_damaged(layout)}, 
                                          width = "auto", height = "auto")
      
      } else if (input$dead_radio == const_dead_density_plot) {
        
        setProgress(message = "Rendering dead pixel density...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_layout_density(layout, adjust = 0.5)}, 
                                             width = "auto", height = "auto")
        
      } else if (input$dead_radio == const_dead_counts) {
        
        setProgress(message = "Rendering counts...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_layout_cnt_mod(layout = layout)}, 
                                             width = "auto", height = "auto")
        
      } else if (input$dead_radio == const_dead_arrows) {
        
        setProgress(message = "Rendering arrows...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_layout_arrows(layout = layout)}, 
                                             width = "auto", height = "auto")
      
      } else if (input$dead_radio == const_dead_angles) {
        
        setProgress(message = "Rendering arrows...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_layout_angles(layout = layout)}, 
                                             width = "auto", height = "auto")
      
      } else if (input$dead_radio == const_dead_K) {
        
        setProgress(message = "K-Function...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "K")}, 
                                             width = "auto", height = "auto")
      
      } else if (input$dead_radio == const_dead_F) {
        
        setProgress(message = "F-Function...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "F")}, 
                                             width = "auto", height = "auto")
      
      } else if (input$dead_radio == const_dead_G) {
        
        setProgress(message = "G-Function...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "G")}, 
                                             width = "auto", height = "auto")
      
      } else if (input$dead_radio == const_dead_inhom_K) {
        
        setProgress(message = "Inhomogeneous K-Function...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "Kinhom")}, 
                                             width = "auto", height = "auto")
        
      } else if (input$dead_radio == const_dead_inhom_F) {
        
        setProgress(message = "Inhomogeneous F-Function...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "Finhom")}, 
                                             width = "auto", height = "auto")
        
      } else if (input$dead_radio == const_dead_inhom_G) {
        
        setProgress(message = "Inhomogeneous G-Function...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "Ginhom")}, 
                                             width = "auto", height = "auto")
        
      } 
      
      setProgress(message = "Finished!", value = 1.0)
    })
  })
  
  output$info <- renderPrint({
    
    x <- input$dead_pix_plot_click$x
    y <- input$dead_pix_plot_click$y
    
    mod_col <- detectorchecker::which_module(x, layout$module_edges_col)
    mod_row <- detectorchecker::which_module(y, layout$module_edges_row)

    
    paste("x=", x, "\n y=", y, 
          "which row ", mod_row, " which col ", mod_col)
    
  })
  
  
  # Fit model
  observeEvent(input$model_fit, {
    
    if (is.null(layout) || is.na(layout) || is.na(layout$dead_stats))
      return(NULL)
    
    withProgress({
      setProgress(message = "Fitting model...")
      
      ok <- TRUE
      
      if (input$fit_radio == const_model_fit_centreeucl) {
        
        dist <- detectorchecker::pixel_dist_ctr_eucl(layout)
        pix_matrix <- layout$pix_matrix
        
        glm_fit <- glm(as.vector(pix_matrix) ~ as.vector(dist), 
                       family = binomial(link = logit))
      
      } else if (input$fit_radio == const_model_fit_centrlinf) {  
        
        dist <- detectorchecker::pixel_dist_ctr_linf(layout)
        pix_matrix <- layout$pix_matrix
        
        glm_fit <- glm(as.vector(pix_matrix) ~ as.vector(dist), 
                       family = binomial(link = logit))
      
      } else if (input$fit_radio == const_model_fit_distedgecol) {  
        
        dist <- detectorchecker::dist_edge_col(layout)
        pix_matrix <- layout$pix_matrix
        
        glm_fit <- glm(as.vector(pix_matrix) ~ as.vector(dist), 
                       family = binomial(link = logit))
        
      } else if (input$fit_radio == const_model_fit_distedgerow) {  
        
        dist <- detectorchecker::dist_edge_row(layout)
        pix_matrix <- layout$pix_matrix
        
        glm_fit <- glm(as.vector(pix_matrix) ~ as.vector(dist), 
                       family = binomial(link = logit))
      
      # } else if (input$fit_radio == const_model_fit_custom) {
      #   
      #   model_fit_expr <- input$custom_model
      #     
      #   glm_fit <- glm(model_fit_expr, 
      #                  family = binomial(link = logit))
        
      } else {
        
        showModal(modalDialog(
          title = "Error",
          "Fitting model is undefined."
        ))
        
        ok <- FALSE
      }
      
      if (ok) {
        output$model_fit_summary <- renderPrint({
          summary(glm_fit)
        })
      }
      
      setProgress(message = "Finished!", value=1.0)
    })
  })
 
  # # Analyse layout pixels
  # observeEvent(input$pixelAnalysis, {
  #   withProgress({
  #     setProgress(message = "Analysing pixels...")
  #     
  #     layout.pixel <<- analysePixels(layout=layout.selected)
  #     
  #     setProgress(message = "Rendering...", value=0.5)
  #     
  #     plotPixels(layout=layout.selected, layout.pixel=layout.pixel, pixel.analysis=input$pixelRadio)
  #     
  #     output$pixelPlot <- renderImage({
  #       # TODO: fix path
  #       filename <- file.path(".", paste("temp", ".png", sep=""))
  #       
  #       # Return a list containing the filename
  #       list(src = filename)
  #     }, deleteFile = TRUE)
  #     
  #     setProgress(message = "Finished!", value=1.0)
  #   })
  # })
  
})
