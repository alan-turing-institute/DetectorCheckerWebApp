# This is the server logic of a Shiny web application.

# Maximum size of an upload file 30 MB
options(shiny.maxRequestSize=30*1024^2)

library(shiny)
library(shinythemes)
library(ggplot2)
library(detectorchecker)

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
      output$dead_pixel_plot <- renderPlot({detectorchecker::plot_layout_damaged(layout, caption = FALSE)},
                                           width = "auto", height = "auto")

      setProgress(message = "Preparing summary...")

      output$dead_pixel_summary <- renderPrint({
        cat(detectorchecker::dead_stats_summary(layout))
      })

      setProgress(message = "Finished!", value = 1.0)

      output$layout_analysis_caption <- renderPrint({
        cat("Layout analysis:")
      })

      output$layout_analysis_left_caption <- renderPrint({
        cat("Damaged layout")
      })

    })
  })

  # Plot the selected layout pixel analysis
  observeEvent(input$layoutDeadPixels, {

    if (is.null(layout) || is.na(layout) || is.na(layout$dead_stats))
      return(NULL)

    withProgress({

      # if (input$dead_radio == const_dead_plot) {
      #
      #   setProgress(message = "Rendering layout...")
      #   output$dead_pixel_plot <- renderPlot({detectorchecker::plot_layout_damaged(layout, caption = FALSE)},
      #                                     width = "auto", height = "auto")
      #
      # } else

      analysis_caption <- NULL

      if (input$dead_radio == const_dead_density_plot) {

        analysis_caption <- const_dead_density_plot_cap
        setProgress(message = paste("Rendering", analysis_caption, sep=" "))

        output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_density(layout, adjust = 0.5, caption = FALSE)},
                                             width = "auto", height = "auto")

      } else if (input$dead_radio == const_dead_counts) {

        analysis_caption <- const_dead_counts_cap
        setProgress(message = paste("Rendering", analysis_caption, sep=" "))

        output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_cnt_mod(layout = layout, caption = FALSE)},
                                             width = "auto", height = "auto")

      } else if (input$dead_radio == const_dead_arrows) {

        analysis_caption <- const_dead_arrows_cap
        setProgress(message = paste("Rendering", analysis_caption, sep=" "))

        output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_arrows(layout = layout, caption = FALSE)},
                                             width = "auto", height = "auto")

      } else if (input$dead_radio == const_dead_angles) {

        analysis_caption <- const_dead_angles_cap
        setProgress(message = paste("Rendering", analysis_caption, sep=" "))

        output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_layout_angles(layout = layout, caption = FALSE)},
                                             width = "auto", height = "auto")

      } else if (input$dead_radio == const_dead_K) {

        analysis_caption <- const_dead_K_cap
        setProgress(message = paste("Rendering", analysis_caption, sep=" "))

        output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "K", caption = FALSE)},
                                             width = "auto", height = "auto")

      } else if (input$dead_radio == const_dead_F) {

        analysis_caption <- const_dead_F_cap
        setProgress(message = paste("Rendering", analysis_caption, sep=" "))

        output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "F", caption = FALSE)},
                                             width = "auto", height = "auto")

      } else if (input$dead_radio == const_dead_G) {

        analysis_caption <- const_dead_G_cap
        setProgress(message = paste("Rendering", analysis_caption, sep=" "))

        output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "G", caption = FALSE)},
                                             width = "auto", height = "auto")

      } else if (input$dead_radio == const_dead_inhom_K) {

        analysis_caption <- const_dead_inhom_K_cap
        setProgress(message = paste("Rendering", analysis_caption, sep=" "))

        output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "Kinhom", caption = FALSE)},
                                             width = "auto", height = "auto")

      } else if (input$dead_radio == const_dead_inhom_F) {

        analysis_caption <- const_dead_inhom_F_cap
        setProgress(message = paste("Rendering", analysis_caption, sep=" "))

        output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "Finhom", caption = FALSE)},
                                             width = "auto", height = "auto")

      } else if (input$dead_radio == const_dead_inhom_G) {

        analysis_caption <- const_dead_inhom_G_cap
        setProgress(message = paste("Rendering", analysis_caption, sep=" "))

        output$dead_pixel_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "Ginhom", caption = FALSE)},
                                             width = "auto", height = "auto")
      }

      output$layout_analysis_right_caption <- renderPrint({
        cat(analysis_caption)
      })

      setProgress(message = "Finished!", value = 1.0)
    })
  })

  observeEvent(input$dead_pix_plot_click, {

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

            setProgress(message = "Rendering layout...")
               output$dead_pixel_module_plot <- renderPlot({detectorchecker::plot_layout_module_damaged(layout, col = mod_col, row = mod_row, caption = FALSE)},
                                                    width = "auto", height = "auto")

            setProgress(message = "Finished!", value = 1.0)
          })
      })

    }
  })

  observeEvent(input$dead_pix_plot_dbclick, {

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

      output$dead_pixel_module_plot <- renderPlot({
        withProgress({

          setProgress(message = "Rendering layout...")
          output$dead_pixel_module_plot <- renderPlot({detectorchecker::plot_layout_module_damaged(layout, col = mod_col, row = mod_row, caption = FALSE)},
                                                      width = "auto", height = "auto")

          setProgress(message = "Finished!", value = 1.0)
        })
      })

      output$dead_pixel_module_analysis_plot <- renderPlot({
        withProgress({

          analysis_caption <- NULL

          if (input$dead_radio == const_dead_density_plot) {

            analysis_caption <- const_dead_density_plot_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))

            output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_density(layout, adjust = 0.5,
                                                                                                       col = mod_col, row = mod_row, caption = FALSE)},
                                                                 width = "auto", height = "auto")

          } else if (input$dead_radio == const_dead_counts) {

            analysis_caption <- const_dead_counts_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))

            output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_cnt_mod(layout = layout,
                                                                                                       col = mod_col, row = mod_row, caption = FALSE)},
                                                                 width = "auto", height = "auto")

          } else if (input$dead_radio == const_dead_arrows) {

            analysis_caption <- const_dead_arrows_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))

            output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_arrows(layout = layout,
                                                                                                      col = mod_col, row = mod_row, caption = FALSE)},
                                                                 width = "auto", height = "auto")

          } else if (input$dead_radio == const_dead_angles) {

            analysis_caption <- const_dead_angles_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))

            output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_layout_angles(layout = layout,
                                                                                                      col = mod_col, row = mod_row, caption = FALSE)},
                                                                 width = "auto", height = "auto")

          } else if (input$dead_radio == const_dead_K) {

            analysis_caption <- const_dead_K_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))

            output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "K",
                                                                                            col = mod_col, row = mod_row, caption = FALSE)},
                                                                 width = "auto", height = "auto")

          } else if (input$dead_radio == const_dead_F) {

            analysis_caption <- const_dead_F_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))

            output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "F",
                                                                                            col = mod_col, row = mod_row, caption = FALSE)},
                                                                 width = "auto", height = "auto")

          } else if (input$dead_radio == const_dead_G) {

            analysis_caption <- const_dead_G_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))

            output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "G",
                                                                                            col = mod_col, row = mod_row, caption = FALSE)},
                                                                 width = "auto", height = "auto")

          } else if (input$dead_radio == const_dead_inhom_K) {

            analysis_caption <- const_dead_inhom_K_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))

            output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "Kinhom",
                                                                                            col = mod_col, row = mod_row, caption = FALSE)},
                                                                 width = "auto", height = "auto")

          } else if (input$dead_radio == const_dead_inhom_F) {

            analysis_caption <- const_dead_inhom_F_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))

            output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "Finhom",
                                                                                            col = mod_col, row = mod_row, caption = FALSE)},
                                                                 width = "auto", height = "auto")

          } else if (input$dead_radio == const_dead_inhom_G) {

            analysis_caption <- const_dead_inhom_G_cap
            setProgress(message = paste("Rendering", analysis_caption, sep=" "))

            output$dead_pixel_module_analysis_plot <- renderPlot({detectorchecker::plot_kfg(layout = layout, func = "Ginhom",
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

})
