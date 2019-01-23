library(shiny)
# global.R define objects available to both ui.R and server.R

webapp_version <- "0.1.8"

# global parameters
const_layout_default <- "None"
const_layout_user <- "<<user-defined>>"
const_layout_user_name <- "user-defined"
const_cwd <- getwd()

layout_names <- c(const_layout_default)

# global objects
layout <- NA

# gui paramters
gui_sidebar_radio_col_size = 7

# ui names
const_ui_layoutSelectInput <- "layoutSelect"

# pixel analysis
const_layout_plot = 1
const_layout_plot_cap = "layout"
  
const_pix_distcentreeucl = 2
const_pix_distcentreeucl_cap = "distcentreeucl"
  
const_pix_distcentrelinf = 3
const_pix_distcentrelinf_cap = "distcentrelinf"
  
const_pix_distcorner = 4
const_pix_distcorner_cap = "distcorner"
  
const_pix_distedgescol = 5
const_pix_distedgescol_cap = "distedgescol"
  
const_pix_distedgesrow = 6
const_pix_distedgesrow_cap = "distedgesrow"
  
const_pix_distedgesmin = 7
const_pix_distedgesmin_cap = "distedgesmin"

# damaged pixel analysis
const_dead_plot = 1
const_dead_plot_cap = "Damage"
  
const_density_plot = 2
const_density_plot_cap = "Density"

const_counts = 3
const_counts_cap = "Counts"

const_arrows = 4
const_arrows_cap = "Arrows"

const_angles = 5
const_angles_cap = "Angles"

const_K = 6
const_K_cap = "K-func."

const_F = 7
const_F_cap = "F-func."

const_G = 8
const_G_cap = "G-func."

const_inhom_K = 9
const_inhom_K_cap = "Inhom. K-func."

const_inhom_F = 10
const_inhom_F_cap = "Inhom. F-func."

const_inhom_G = 11
const_inhom_G_cap = "Inhom. G-func."

# model fit
const_model_fit_centreeucl = 1
const_model_fit_centrlinf = 2
const_model_fit_distedgecol = 3
const_model_fit_distedgerow = 4

const_model_fit_custom = 99

# analysis level (pixels, events)
const_level_pixels = "Pixels"
const_level_events = "Events"

const_javascriptWarning = "Javascript Warning!"

############### Messages

### Error messages
msg_err_no_layout = "Layout model has not been selected."
msg_err_no_deadfile = "Pixel damage file has not been uploaded."
msg_err_invalid_email = "Invalid email address."
msg_err_no_events = "No events found. Please revisit step 4."

################ Tooltips

### LAYOUT

# sidebar
tt_selected_layout = "Selected layout."
tt_select_input = "Choose a predifined layout or upload your own."
tt_custom_layout = "Select a file with a custom layout parameters."
tt_custom_example = paste0("Example can be found ", a("here.", 
  href = "https://github.com/tomaslaz/DetectorChecker/blob/master/layout_example.dc",
  target="_blank"))
tt_layout_analysis = "Select a layout analysis type and click [Display plot] to visualise it."
tt_layout_analysis_button = "Perform analysis."
tt_version = "DetectorChecker package and webapp versions."
tt_layout = "This is the selected layout. "
tt_layout_summary = "This is the summary of the selected layout. "

### DAMAGED PIXELS
tt_dead_file = "Select a file containing damaged pixel information."
tt_dead_level = "Choose analysis level: damaged pixels / events."
tt_dead_analysis = "Select a damaged layout analysis type."
tt_dead_analysis_button = "Perform analysis on the damaged layout."
tt_email = "Email address will be used as a unique identifier when uploading the data."
tt_upload_button = "Uploads the damage pixel file and user-defined layout to the server."
tt_damaged_layout_clicks = "Single click on the plot will focus on the specified module, double click - will perform analysis on the specified module."
tt_dead_pixels_summary = "The summary of damaged pixels."

### MODEL FITTING
tt_model_label = "7. Modelling Damage Intensity"
tt_model = "Select a model to fit damaged pixel / events data."
tt_model_fit = "This is the model fit summary."

# About text
about_text = paste('<h2 style="text-align: center;"><strong>DetectorChecker</strong></h2>
<p style="text-align: center;"><strong>Version: v.', webapp_version, '</strong></p>
<p>DetectorChecker is a&nbsp;multi-platform open-source software package aimed to&nbsp;assess developing detector screen damage in high-value detector screens used in computerised tomography.&nbsp;DetectorChecker produces statistical summaries of damage of detector screens including dysfunctional pixel and noise analysis and allows users to&nbsp;forward their summaries, enabling comparative data analysis over a broader range of system.</p>
<p><strong>Requirements:&nbsp;</strong></p>
<p>For the best experience, use a modern web browser which supports HTML5 technology (such as, Google Chrome v. 70.0 or later, Mozilla Firefox v. 62.0 or later, or similar) with javascript being enabled.</p>
<p><strong>Acknowledgments:</strong></p>
<p>Professor <a href="https://warwick.ac.uk/fac/sci/statistics/staff/academic-research/kendall/">Wilfrid Kendall</a>&nbsp;</p>
<p>Dr <a href="https://warwick.ac.uk/fac/sci/statistics/staff/academic-research/brettschneider/">Julia Brettschneider</a></p>
<p>Dr <a href="https://www.turing.ac.uk/people/researchers/tomas-lazauskas">Tomas Lazauskas</a></p>
<p>For more information about the DetectorChecker project please contact Professor <a href="https://warwick.ac.uk/fac/sci/statistics/staff/academic-research/kendall/">Wilfrid Kendall</a>&nbsp;or Dr <a href="https://warwick.ac.uk/fac/sci/statistics/staff/academic-research/brettschneider/">Julia Brettschneider</a>.</p>
<p>DetectorChecker is being developed by the University of Warwick and Alan Turing Institute.</p>
<p style="text-align: left;">&copy; Any copyrights remain with the original authors.</p>
<table>
<tbody>
<tr>
<td><img src="https://warwick.ac.uk/fac/sci/moac/intranet/branding/warwick.png" width="150" height="46" /></td>
<td><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4gMK2F7F_KqnIDqHCEXFgKorSGkVzGIqjc4sO9kXvsMyk1OsC" width="150" height="70" /></td>
</tr>
</tbody>
</table>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: left;">Users can revert to calculations by using tabs at top of the window.</p>', "")
