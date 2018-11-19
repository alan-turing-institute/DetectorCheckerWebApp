# global.R define objects available to both ui.R and server.R

webapp_version <- "0.1.4"

# global parameters
const_layout_default <- "None"
const_layout_user <- "<<user-defined>>"
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
  
const_dead_density_plot = 2
const_dead_density_plot_cap = "Density"

const_dead_counts = 3
const_dead_counts_cap = "Counts"

const_dead_arrows = 4
const_dead_arrows_cap = "Arrows"

const_dead_angles = 5
const_dead_angles_cap = "Angles"

const_dead_K = 6
const_dead_K_cap = "K-func."

const_dead_F = 7
const_dead_F_cap = "F-func."

const_dead_G = 8
const_dead_G_cap = "G-func."

const_dead_inhom_K = 9
const_dead_inhom_K_cap = "Inhom. K-func."

const_dead_inhom_F = 10
const_dead_inhom_F_cap = "Inhom. F-func."

const_dead_inhom_G = 11
const_dead_inhom_G_cap = "Inhom. G-func."

# model fit
const_model_fit_centreeucl = 1
const_model_fit_centrlinf = 2
const_model_fit_distedgecol = 3
const_model_fit_distedgerow = 4

const_model_fit_custom = 99

### Error messages
msg_err_no_layout = "Layout model has not been selected."
msg_err_no_deadfile = "Dead pixels file has not been uploaded."
