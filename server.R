# This is the server logic of a Shiny web application.

# Maximum size of an upload file 30 MB
options(shiny.maxRequestSize=30*1024^2)

library(shiny)
library(shinyjs)
library(shinythemes)
library(ggplot2)
library(detectorchecker)
source("gui_utils.R")

# Define server
shinyServer(function(input, output, session) {
  
  tryCatch({
    hide("javascriptWarning")
  
    # load layouts
    layout_names <- c(const_layout_default, detectorchecker::available_layouts,
                      const_layout_user)
  
    # refresh layout select
    updateSelectInput(session, const_ui_layoutSelectInput, choices = layout_names)
  
    output$app_summary <- renderPrint({
      cat(paste(paste("detectorchecker v: ", packageVersion("detectorchecker"), sep=""),
                paste("webapp v: ", webapp_version, sep=""),
                sep="\n"))
    })
  
    # update loaded layout text boxes to NONE
    .update_layout_textbox(layout = layout, output = output)
    
  }, error = function(err) {
    showModal(modalDialog(title = "Error", err))
    return(NULL)})
  
  # Load layout
  observeEvent(input$layoutSelect, {
    
    tryCatch({
      
      .clear_everything(output)
      
      # check whether a model has been selected
      if (input$layoutSelect == const_layout_default) {
  
        layout <<- NULL
  
        .update_layout_textbox(layout = layout, output = output)
  
        .clear_everything(output)
  
      } else if (input$layoutSelect == const_layout_user) {
  
  
      } else {
        withProgress({
          setProgress(message = "Loading layout...")
          layout <<- detectorchecker::create_module(input$layoutSelect)
  
          setProgress(message = "Rendering layout...")
  
          .render_layout(layout = layout, output = output)
  
          setProgress(message = "Finished!", value = 1.0)
        })
      }
      
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
  })

  # Load custom layout
  observeEvent(input$layout_file, {
    
    tryCatch({
      
      layout_file <- input$layout_file
  
      if (is.null(layout_file))
        return(NULL)
  
      withProgress({
        setProgress(message = "Loading layout...")
  
        tryCatch({
          layout <<- detectorchecker::readin_layout(layout_file$datapath)},
          error = function(err) {
            showModal(modalDialog(title = "Error", err))
            return(NULL)})
  
        if (is.null(layout) || is.na(layout)) {
  
          layout <<- NULL
          .update_layout_textbox(layout = layout, output = output)
          .clear_everything(output)
  
          return(NULL)
        }
  
        .render_layout(layout = layout, output = output)
  
        setProgress(message = "Finished!", value = 1.0)
      })
      
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
  })

  # Plot the selected layout pixel analysis
  observeEvent(input$layoutPixels, {
    tryCatch({
      
      # check whether a model has been selected
      if (input$layoutSelect == const_layout_default) {
        .layout_not_selected_error()
        return(NULL)
  
      } else if ((input$layoutSelect == const_layout_user) && (is.na(layout) || is.null(layout))) {
        .layout_not_selected_error()
        return(NULL)
  
      } else {
  
        # select appropriate action with respect to the radio button
        if (input$pixelRadio == const_layout_plot) {
          withProgress({
            setProgress(message = "Rendering layout...")
  
            output$layoutPlot <- renderPlot({detectorchecker::plot_layout(layout, caption = FALSE)},
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
      
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
  })

  # Load dead pixels
  observeEvent(input$dead_file, {
    tryCatch({
      
      if (is.null(layout) || is.na(layout)) {
        .layout_not_selected_error()
        .clear_everything(output)
        return(NULL)
      }
  
      if (is.null(input$dead_file)) {
        return(NULL)
        .dead_file_error()
      }
  
      withProgress({
        
        setProgress(message = "Reading in data...")
  
        dead_load_ok <- TRUE
        
        tryCatch({
          
          layout <<- detectorchecker::load_pix_matrix(layout = layout, file_path = input$dead_file$datapath)
  
          setProgress(message = "Analysing damage...")
          
          .clear_analysis_plots(output)
          
          layout <<- detectorchecker::get_dead_stats(layout)
        
          },
          error = function(err) {
            reset("dead_file")
            showModal(modalDialog(title = "Error", err))
            dead_load_ok <<- FALSE
            return(NULL)
          }
        )
  
        if (!dead_load_ok) {
          return(NULL)
        }
  
        setProgress(message = "Rendering damage...")
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_layout_damaged(layout, caption = FALSE)},
                                             width = "auto", height = "auto")
  
        setProgress(message = "Preparing summary...")
  
        output$dead_pixel_summary <- renderPrint({
          cat(detectorchecker::dead_stats_summary(layout))
        })
  
        setProgress(message = "Finished!", value = 1.0)
  
        output$layout_analysis_caption <- renderPrint({
          cat("Layout analysis: PIXELS")
        })
  
        output$layout_analysis_left_caption <- renderPrint({
          cat("Damaged Pixels")
        })
      })
      
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
  })

  # Layout level
  observeEvent(input$level_radio, {
    
    tryCatch({
      
      # Chnage the model fit caption accordingly
      if (input$level_radio == const_level_pixels) {
        
        output$loaded_layout_text4 <- renderText({
          HTML(paste("Level: ", "pixels"))})
        
      } else if (input$level_radio == const_level_events) {
        
        output$loaded_layout_text4 <- renderText({
          HTML(paste("Level: ", "selected events"))})
      }
      
      if (is.null(layout) || is.na(layout)) {
        return(NULL)
      }
  
      if (is.na(layout$dead_stats) || is.null(layout$dead_stats)) {
        return(NULL)
      }
      
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
  })
  
  # Level analysis plot
  observeEvent(input$layoutLevelAnalysis, {
    tryCatch({
      
      if (is.null(layout) || is.na(layout)) {
        .layout_not_selected_error()
        return(NULL)
      }
      
      if (is.na(layout$dead_stats) || is.null(layout$dead_stats)) {
        .dead_file_error()
        return(NULL)
      }
      
      .clear_analysis_plots(output)
      
      if (input$level_radio == const_level_pixels) {
        
        output$layout_analysis_caption <- renderPrint({
          cat("Layout analysis: PIXELS")
        })
        
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_layout_damaged(layout, caption = FALSE)},
                                             width = "auto", height = "auto")
        
        output$layout_analysis_left_caption <- renderPrint({
          cat("Damaged Pixels")
        })
        
      } else if (input$level_radio == const_level_events) {
        
        event_values <- as.integer(input$events_chk_group)
        
        output$layout_analysis_caption <- renderPrint({
          cat("Layout analysis: EVENTS:", event_values)
        })
        
        incl_event_list <- as.list(as.integer(input$events_chk_group))
        
        layout <<- detectorchecker::find_clumps(layout)
        
        output$dead_pixel_plot <- renderPlot({detectorchecker::plot_events(layout,
                                                                           caption = FALSE, incl_event_list = incl_event_list)},
                                             width = "auto", height = "auto")
        
        output$layout_analysis_left_caption <- renderPrint({
          cat("Events")
        })
        
      } else {
        showModal(modalDialog(title = "Error", "Analysis level is not specified. Level slection."))
        return(NULL)
      }
      
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
  })
  
  # Plot the selected layout pixel and event analysis
  observeEvent(input$layoutDeadPixels, {
    
    tryCatch({
    
      if (is.null(layout) || is.na(layout)) {
        .layout_not_selected_error()
        return(NULL)
      }
      
      if (is.na(layout$dead_stats) || is.null(layout$dead_stats)) {
        .dead_file_error()
        return(NULL)
      }
  
      withProgress({
        analysis_caption <- NULL
  
        # Pixel analysis
        if (input$level_radio == const_level_pixels) {
  
          if (input$dead_radio == const_density_plot) {
  
            analysis_caption <- const_density_plot_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_density(layout, adjust = 0.5, caption = FALSE)},
                                                          width = "auto", height = "auto")
  
          } else if (input$dead_radio == const_counts) {
  
            analysis_caption <- const_counts_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_cnt_mod(layout = layout, caption = FALSE)},
                                                          width = "auto", height = "auto")
  
          } else if (input$dead_radio == const_arrows) {
  
            analysis_caption <- const_arrows_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_arrows(layout = layout, caption = FALSE)},
                                                          width = "auto", height = "auto")
  
          } else if (input$dead_radio == const_angles) {
  
            analysis_caption <- const_angles_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_angles(layout = layout, caption = FALSE)},
                                                          width = "auto", height = "auto")
  
          } else if (input$dead_radio == const_K) {
  
            analysis_caption <- const_K_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "K", caption = FALSE)},
                                                          width = "auto", height = "auto")
  
          } else if (input$dead_radio == const_F) {
  
            analysis_caption <- const_F_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "F", caption = FALSE)},
                                                          width = "auto", height = "auto")
  
          } else if (input$dead_radio == const_G) {
  
            analysis_caption <- const_G_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "G", caption = FALSE)},
                                                          width = "auto", height = "auto")
  
          } else if (input$dead_radio == const_inhom_K) {
  
            analysis_caption <- const_inhom_K_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "Kinhom", caption = FALSE)},
                                                          width = "auto", height = "auto")
  
          } else if (input$dead_radio == const_inhom_F) {
  
            analysis_caption <- const_inhom_F_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "Finhom", caption = FALSE)},
                                                          width = "auto", height = "auto")
  
          } else if (input$dead_radio == const_inhom_G) {
  
            analysis_caption <- const_inhom_G_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "Ginhom", caption = FALSE)},
                                                          width = "auto", height = "auto")
          } else {
            showModal(modalDialog(title = "Error", "Functionality is not implemented."))
            return(NULL)
          }
  
          output$layout_analysis_right_caption <- renderPrint({
            cat(analysis_caption)
          })
  
        } else if (input$level_radio == const_level_events) {
          
          if (is.null(layout$clumps) || is.na(layout$clumps)) {
            .events_not_found_error()
            return(NULL)
          }
          
          incl_event_list <- as.list(as.integer(input$events_chk_group))
  
          setProgress(message = "Looking for clumps..", value = 0.3)
          # layout <<- detectorchecker::find_clumps(layout)
  
          output$dead_pixel_plot <- renderPlot({detectorchecker::plot_events(layout,
            caption = FALSE, incl_event_list = incl_event_list)},
            width = "auto", height = "auto")
  
          output$layout_analysis_left_caption <- renderPrint({
            cat("Layout Events")
          })
  
          # density
          if (input$dead_radio == const_density_plot) {
  
            analysis_caption <- const_density_plot_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "), value = 0.6)
  
            output$dead_pixel_analysis_plot <- renderPlot({
              detectorchecker::plot_events_density(layout, caption = FALSE, incl_event_list = incl_event_list)},
                                                          width = "auto", height = "auto")
  
          # counts
          } else if(input$dead_radio == const_counts) {
  
            analysis_caption <- const_counts_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({
              detectorchecker::plot_events_count(layout = layout, caption = FALSE, incl_event_list = incl_event_list)},
                                                          width = "auto", height = "auto")
  
          # arrows
          } else if(input$dead_radio == const_arrows) {
  
            analysis_caption <- const_arrows_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "), value = 0.6)
  
            output$dead_pixel_analysis_plot <- renderPlot({
              detectorchecker::plot_events_arrows(layout, caption = FALSE, incl_event_list = incl_event_list)},
                                                          width = "auto", height = "auto")
  
          # angles
          } else if(input$dead_radio == const_angles) {
            analysis_caption <- const_angles_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "), value = 0.6)
  
            output$dead_pixel_analysis_plot <- renderPlot({
              detectorchecker::plot_events_angles(layout, caption = FALSE, incl_event_list = incl_event_list)},
              width = "auto", height = "auto")
  
          # K-func
          } else if(input$dead_radio == const_K) {
  
            analysis_caption <- const_K_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({
              detectorchecker::plot_events_kfg(layout, func = "K", caption = FALSE,
                                               incl_event_list = incl_event_list)},
              width = "auto", height = "auto")
  
          # F-func
          } else if(input$dead_radio == const_F) {
  
            analysis_caption <- const_F_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({
              detectorchecker::plot_events_kfg(layout, func = "F", caption = FALSE,
                                               incl_event_list = incl_event_list)},
              width = "auto", height = "auto")
  
          # G-func
          } else if(input$dead_radio == const_G) {
  
            analysis_caption <- const_G_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({
              detectorchecker::plot_events_kfg(layout, func = "G", caption = FALSE,
                                               incl_event_list = incl_event_list)},
              width = "auto", height = "auto")
  
          # Inhomogeneous K-func
          } else if(input$dead_radio == const_inhom_K) {
  
            analysis_caption <- const_inhom_K_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({
              detectorchecker::plot_events_kfg(layout, func = "Kinhom", caption = FALSE,
                                               incl_event_list = incl_event_list)},
              width = "auto", height = "auto")
  
          # Inhomogeneous F-func
          } else if(input$dead_radio == const_inhom_F) {
  
            analysis_caption <- const_inhom_F_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({
              detectorchecker::plot_events_kfg(layout, func = "Finhom", caption = FALSE,
                                               incl_event_list = incl_event_list)},
              width = "auto", height = "auto")
  
          # Inhomogeneous G-func
          } else if(input$dead_radio == const_inhom_G) {
  
            analysis_caption <- const_inhom_G_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
            output$dead_pixel_analysis_plot <- renderPlot({
              detectorchecker::plot_events_kfg(layout, func = "Ginhom", caption = FALSE,
                                               incl_event_list = incl_event_list)},
              width = "auto", height = "auto")
  
          } else {
            showModal(modalDialog(title = "Error", "Functionality is not implemented."))
            return(NULL)
          }
  
          output$layout_analysis_right_caption <- renderPrint({
            cat(analysis_caption)
          })
  
        } else {
          showModal(modalDialog(title = "Error", "Analysis level is not specified"))
          return(NULL)
        }
  
        setProgress(message = "Finished!", value = 1.0)
      })
    
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
  })

  observeEvent(input$dead_pix_plot_click, {
    
    tryCatch({
      
      if (is.null(layout) || is.na(layout) || is.na(layout$dead_stats))
        return(NULL)
  
      if (!is.null(input$dead_pix_plot_click$x) &&
          !is.null(input$dead_pix_plot_click$y)) {
  
        x <- input$dead_pix_plot_click$x
        y <- input$dead_pix_plot_click$y
  
        mod_col <- detectorchecker::which_module(x, layout$module_edges_col)
        mod_row <- detectorchecker::which_module(y, layout$module_edges_row)
  
        output$module_analysis_caption <- renderPrint({
          cat("Module analysis:")
        })
  
        output$module_analysis_left <- renderPrint({
          cat(paste("Damaged module [", mod_row, ", ", mod_col, "]", sep = ""))
        })
        
        output$dead_pixel_module_plot <- renderPlot({
          withProgress({
  
            setProgress(message = "Rendering module...")
            
            # plot module damaged pixels
            if (input$level_radio == const_level_pixels) {
            
              output$dead_pixel_module_plot <- renderPlot({detectorchecker::plot_layout_module_damaged(layout, col = mod_col, row = mod_row, caption = FALSE)},
                                                        width = "auto", height = "auto")
  
              # plot module events
            } else if (input$level_radio == const_level_events) {
              
              incl_event_list <- as.list(as.integer(input$events_chk_group))
              
              layout_module_events <- detectorchecker::find_clumps(layout, row = mod_row, col = mod_col)
              
              plot_module_events(layout_module_events, row = mod_row, col = mod_col, caption = FALSE, 
                                 incl_event_list = incl_event_list)
            }
            
            setProgress(message = "Finished!", value = 1.0)
          })
        })
          
      } else {
        showModal(modalDialog(title = "Error", "Analysis level is not specified. Single click."))
        return(NULL)
      }
    
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
    
  })

  observeEvent(input$dead_pix_plot_dbclick, {
    tryCatch({
      
      if (is.null(layout) || is.na(layout) || is.na(layout$dead_stats))
        return(NULL)
  
      if (!is.null(input$dead_pix_plot_click$x) &&
          !is.null(input$dead_pix_plot_click$y)) {
  
        x <- input$dead_pix_plot_click$x
        y <- input$dead_pix_plot_click$y
  
        mod_col <- detectorchecker::which_module(x, layout$module_edges_col)
        mod_row <- detectorchecker::which_module(y, layout$module_edges_row)
  
        output$module_analysis_caption <- renderPrint({
          cat("Module analysis")
        })
  
        output$module_analysis_left <- renderPrint({
          cat(paste("Damaged module [", mod_row, ", ", mod_col, "]", sep = ""))
        })
        
        # Analysing selected module's pixels
        if (input$level_radio == const_level_pixels) {
        
          output$dead_pixel_module_plot <- renderPlot({
            withProgress({
              
              setProgress(message = "Rendering module...")
              output$dead_pixel_module_plot <- renderPlot({detectorchecker::plot_layout_module_damaged(layout, col = mod_col, row = mod_row, caption = FALSE)},
                                                          width = "auto", height = "auto")
              
              setProgress(message = "Finished!", value = 1.0)
            })
          })
          
          output$dead_pixel_module_analysis_plot <- renderPlot({
            withProgress({
              
              analysis_caption <- NULL
              
              if (input$dead_radio == const_density_plot) {
                
                analysis_caption <- const_density_plot_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_density(layout, adjust = 0.5,
                                                                                                           col = mod_col, row = mod_row, caption = FALSE)},
                                                                     width = "auto", height = "auto")
                
              } else if (input$dead_radio == const_counts) {
                
                analysis_caption <- const_counts_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_cnt_mod(layout = layout,
                                                                                                           col = mod_col, row = mod_row, caption = FALSE)},
                                                                     width = "auto", height = "auto")
                
              } else if (input$dead_radio == const_arrows) {
                
                analysis_caption <- const_arrows_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_arrows(layout = layout,
                                                                                                          col = mod_col, row = mod_row, caption = FALSE)},
                                                                     width = "auto", height = "auto")
                
              } else if (input$dead_radio == const_angles) {
                
                analysis_caption <- const_angles_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_angles(layout = layout,
                                                                                                          col = mod_col, row = mod_row, caption = FALSE)},
                                                                     width = "auto", height = "auto")
                
              } else if (input$dead_radio == const_K) {
                
                analysis_caption <- const_K_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "K",
                                                                                                       col = mod_col, row = mod_row, caption = FALSE)},
                                                                     width = "auto", height = "auto")
                
              } else if (input$dead_radio == const_F) {
                
                analysis_caption <- const_F_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "F",
                                                                                                       col = mod_col, row = mod_row, caption = FALSE)},
                                                                     width = "auto", height = "auto")
                
              } else if (input$dead_radio == const_G) {
                
                analysis_caption <- const_G_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "G",
                                                                                                       col = mod_col, row = mod_row, caption = FALSE)},
                                                                     width = "auto", height = "auto")
                
              } else if (input$dead_radio == const_inhom_K) {
                
                analysis_caption <- const_inhom_K_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "Kinhom",
                                                                                                       col = mod_col, row = mod_row, caption = FALSE)},
                                                                     width = "auto", height = "auto")
                
              } else if (input$dead_radio == const_inhom_F) {
                
                analysis_caption <- const_inhom_F_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "Finhom",
                                                                                                       col = mod_col, row = mod_row, caption = FALSE)},
                                                                     width = "auto", height = "auto")
                
              } else if (input$dead_radio == const_inhom_G) {
                
                analysis_caption <- const_inhom_G_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_kfg(layout = layout, func = "Ginhom",
                                                                                                       col = mod_col, row = mod_row, caption = FALSE)},
                                                                     width = "auto", height = "auto")
              }
              
              setProgress(message = "Finished!", value = 1.0)
              
              output$module_analysis_right <- renderPrint({
                cat(paste(analysis_caption, "[", mod_row, ", ", mod_col, "]", sep = ""))
              })
            })
          })
        } 
        
        # Analysing selected module's events
        else if (input$level_radio == const_level_events) {
          
          incl_event_list <- as.list(as.integer(input$events_chk_group))
          layout_module_events <- detectorchecker::find_clumps(layout, row = mod_row, col = mod_col)
          
          # First render module's events
          output$dead_pixel_module_plot <- renderPlot({
            withProgress({
              setProgress(message = "Rendering module's events...")
              
              plot_module_events(layout_module_events, row = mod_row, col = mod_col, 
                                 caption = FALSE, incl_event_list = incl_event_list)
              
              setProgress(message = "Finished!", value = 1.0)
            })
          })
          
          # Then analyse module's events
          output$dead_pixel_module_analysis_plot <- renderPlot({
            withProgress({
              
              analysis_caption <- NULL
              
              # density
              if (input$dead_radio == const_density_plot) {
                
                analysis_caption <- const_density_plot_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "), value = 0.6)
                
                output$dead_pixel_module_analysis_plot <- renderPlot({
                  detectorchecker::plot_events_density(layout_module_events, 
                    row = mod_row, col = mod_col, caption = FALSE, 
                    incl_event_list = incl_event_list)},
                    width = "auto", height = "auto")
                
              # counts
              } else if(input$dead_radio == const_counts) {
                
                analysis_caption <- const_counts_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({
                  detectorchecker::plot_events_count(layout_module_events, 
                    row = mod_row, col = mod_col, caption = FALSE, 
                    incl_event_list = incl_event_list)},
                  width = "auto", height = "auto")
                
              # arrows
              } else if(input$dead_radio == const_arrows) {
                
                analysis_caption <- const_arrows_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "), value = 0.6)
                
                output$dead_pixel_module_analysis_plot <- renderPlot({
                  detectorchecker::plot_events_arrows(layout_module_events, 
                     row = mod_row, col = mod_col, caption = FALSE, 
                     incl_event_list = incl_event_list)},
                  width = "auto", height = "auto")
                
              # angles
              } else if(input$dead_radio == const_angles) {
                analysis_caption <- const_angles_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "), value = 0.6)
                
                output$dead_pixel_module_analysis_plot <- renderPlot({
                  detectorchecker::plot_events_angles(layout_module_events, 
                    row = mod_row, col = mod_col, caption = FALSE, 
                    incl_event_list = incl_event_list)},
                  width = "auto", height = "auto")
                
              # K-func
              } else if(input$dead_radio == const_K) {
                
                analysis_caption <- const_K_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
                output$dead_pixel_module_analysis_plot <- renderPlot({
                  detectorchecker::plot_events_kfg(layout_module_events, func = "K", 
                    row = mod_row, col = mod_col, caption = FALSE, 
                    incl_event_list = incl_event_list)},
                  width = "auto", height = "auto")
                
              # F-func
              } else if(input$dead_radio == const_F) {
                
                analysis_caption <- const_F_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({
                  detectorchecker::plot_events_kfg(layout_module_events, func = "F", 
                    row = mod_row, col = mod_col, caption = FALSE, 
                    incl_event_list = incl_event_list)},
                  width = "auto", height = "auto")
                
              # G-func
              } else if(input$dead_radio == const_G) {
                
                analysis_caption <- const_G_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({
                  detectorchecker::plot_events_kfg(layout_module_events, func = "G", 
                    row = mod_row, col = mod_col, caption = FALSE, 
                    incl_event_list = incl_event_list)},
                  width = "auto", height = "auto")
                
                
              # Inhomogeneous K-func
              } else if(input$dead_radio == const_inhom_K) {
                
                analysis_caption <- const_inhom_K_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({
                  detectorchecker::plot_events_kfg(layout_module_events, func = "Kinhom", 
                    row = mod_row, col = mod_col, caption = FALSE, 
                    incl_event_list = incl_event_list)},
                  width = "auto", height = "auto")
                
              # Inhomogeneous F-func
              } else if(input$dead_radio == const_inhom_F) {
                
                analysis_caption <- const_inhom_F_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
                
                output$dead_pixel_module_analysis_plot <- renderPlot({
                  detectorchecker::plot_events_kfg(layout_module_events, func = "Finhom", 
                    row = mod_row, col = mod_col, caption = FALSE, 
                    incl_event_list = incl_event_list)},
                  width = "auto", height = "auto")
                
              # Inhomogeneous G-func
              } else if(input$dead_radio == const_inhom_G) {
                
                analysis_caption <- const_inhom_G_cap
                setProgress(message = paste("Rendering", analysis_caption, sep=" "))
  
                output$dead_pixel_module_analysis_plot <- renderPlot({
                  detectorchecker::plot_events_kfg(layout_module_events, func = "Ginhom", 
                    row = mod_row, col = mod_col, caption = FALSE, 
                    incl_event_list = incl_event_list)},
                  width = "auto", height = "auto")
                
              } else {
                showModal(modalDialog(title = "Error", "Functionality is not implemented."))
                return(NULL)
              }
              
              setProgress(message = "Finished!", value = 1.0)
              
              output$module_analysis_right <- renderPrint({
                cat(paste(analysis_caption, "[", mod_row, ", ", mod_col, "]", sep = ""))
              })
            })
          })
        } 
        
        # Someting went wrong 
        else {
          showModal(modalDialog(title = "Error", "Analysis level is not specified. Double click."))
          return(NULL)
        }
      }
    
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
  })

  # Upload data to the server
  observeEvent(input$deadPixelsUpload, {
    
    tryCatch({
    
      # check if layout was selected
      if (is.null(layout) || is.na(layout)) {
        .layout_not_selected_error()
        return(NULL)
      }
  
      # check if pixel damage file was uploaded
      if (is.na(layout$dead_stats) || is.null(layout$dead_stats)) {
        .dead_file_error()
        return(NULL)
      }
  
      # check the email address
      if (!.is_valid_email(input$user_email)) {
        .invalid_email_error()
        return(NULL)
      }
  
      withProgress({
        setProgress(message = "Uploading data...")
  
        # upload file
        .upload_pixel_damage_file(layout$name, input$user_email,
          input$dead_file$datapath, input$layout_file$datapath)
      })
      
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
  })

  # Fit model
  observeEvent(input$model_fit, {
    
    tryCatch({
    
      if (is.null(layout) || is.na(layout)) {
        .layout_not_selected_error()
        return(NULL)
      }
  
      if (is.na(layout$dead_stats) || is.null(layout$dead_stats)) {
        .dead_file_error()
        return(NULL)
      }
  
      withProgress({
        setProgress(message = "Fitting model...")
  
        ok <- TRUE
        
        
        if (input$level_radio == const_level_pixels) {
          pix_matrix <- layout$pix_matrix
          
        } else if (input$level_radio == const_level_events) {
          
          if (is.null(layout$clumps) || is.na(layout$clumps)) {
            .events_not_found_error()
            return(NULL)
          }
          
          pix_matrix <- layout$clumps$events_matrix
        }
        
        if (input$fit_radio == const_model_fit_centreeucl) {
  
          dist <- detectorchecker::pixel_dist_ctr_eucl(layout)
          
  
          glm_fit <- glm(as.vector(pix_matrix) ~ as.vector(dist),
                         family = binomial(link = logit))
  
        } else if (input$fit_radio == const_model_fit_centrlinf) {
  
          dist <- detectorchecker::pixel_dist_ctr_linf(layout)
  
          glm_fit <- glm(as.vector(pix_matrix) ~ as.vector(dist),
                         family = binomial(link = logit))
  
        } else if (input$fit_radio == const_model_fit_distedgecol) {
  
          dist <- detectorchecker::dist_edge_col(layout)
  
          glm_fit <- glm(as.vector(pix_matrix) ~ as.vector(dist),
                         family = binomial(link = logit))
  
        } else if (input$fit_radio == const_model_fit_distedgerow) {
  
          dist <- detectorchecker::dist_edge_row(layout)
  
          glm_fit <- glm(as.vector(pix_matrix) ~ as.vector(dist),
                         family = binomial(link = logit))
  
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
    
    }, error = function(err) {
      showModal(modalDialog(title = "Error", err))
      return(NULL)})
    
  })

})
