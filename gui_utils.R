source("global.R")

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

# error message: layout has not been selected
.layout_not_selected_error <- function(){
  showModal(modalDialog(title = "Error", msg_err_no_layout))
}

# error message: pixel damage file has not been uplaoded
.dead_file_error <- function(){
  showModal(modalDialog(title = "Error", msg_err_no_deadfile))
}

# error message: invalid email address
.invalid_email_error <- function(){
  showModal(modalDialog(title = "Error", msg_err_invalid_email))
}

# validation of email addresses 
.is_valid_email <- function(x) {
  grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(x), ignore.case=TRUE)
}

# pixel damage file upload
.upload_pixel_damage_file <- function(email_address, file_path) {
  
  # 
  
  stop("STOP")
}
