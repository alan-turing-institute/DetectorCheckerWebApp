# renders selected layout
.render_layout <- function(layout, output) {
  output$layoutPlot <- renderPlot({detectorchecker::plot_layout(layout, caption = FALSE)},
                                  width = "auto", height = "auto")
  
  output$layout_summary <- renderPrint({
    cat(detectorchecker::layout_summary(layout))
  })
  
  .update_layout_textbox(layout = layout, output = output)
}

# updates uploaded layout text boxes
.update_layout_textbox <- function(layout, output) {
  
  if (is.na(layout) || is.null(layout)) {
    
    output$loaded_layout_text1 <- renderText({
      HTML(paste("Layout: ", const_layout_default))})
    
    output$loaded_layout_text2 <- renderText({
      HTML(paste("Layout: ", const_layout_default))})
    
    output$loaded_layout_text3 <- renderText({
      HTML(paste("Layout: ", const_layout_default))})
    
  } else {
    output$loaded_layout_text1 <- renderText({
      HTML(paste("Layout: ", layout$name))})
    
    output$loaded_layout_text2 <- renderText({
      HTML(paste("Layout: ", layout$name))})
    
    output$loaded_layout_text3 <- renderText({
      HTML(paste("Layout: ", layout$name))})
  }
}

# clears all the plots
.clear_output <- function(output) {
  
  reset("dead_file")
  reset("layout_file")
  
  ########### LAYOUT
  # Layout analysis plot
  output$layoutPlot <- NULL
  
  # summary
  output$layout_summary <- NULL
  
  ########### DEAD PIXELS
  # captions
  output$layout_analysis_caption <- NULL
  output$layout_analysis_left_caption <- NULL
  output$layout_analysis_right_caption <- NULL
  
  # Dead pixels analysis plots
  output$dead_pixel_module_plot <- NULL
  output$dead_pixel_module_analysis_plot <- NULL
  
  # module captions
  output$module_analysis_caption <- NULL
  output$module_analysis_left <- NULL
  output$module_analysis_right <- NULL
  
  # module plots
  output$dead_pixel_plot <- NULL
  output$dead_pixel_analysis_plot <- NULL
  
  # summary
  output$dead_pixel_summary <- NULL
  
  ############ FIT
  output$model_fit_summary <- NULL
}

.layout_not_selected_error <- function(){
  showModal(modalDialog(
    title = "Error",
    "Layout model has not been selected."))
}