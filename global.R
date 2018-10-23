# global.R define objects available to both ui.R and server.R

webapp_version <- "0.1.0"

# global parameters
const_layout_default <- "None"
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
const_pix_distcentreeucl = 2
const_pix_distcentrelinf = 3
const_pix_distcorner = 4
const_pix_distedgescol = 5
const_pix_distedgesrow = 6
const_pix_distedgesmin = 7

# damaged pixel analysis
const_dead_plot = 1
const_dead_density_plot = 2
const_dead_counts = 3
const_dead_arrows = 4
const_dead_angles = 5
const_dead_K = 6
const_dead_F = 7
const_dead_G = 8
const_dead_inhom_K = 9
const_dead_inhom_F = 10
const_dead_inhom_G = 11

# model fit
const_model_fit_centreeucl = 1
const_model_fit_centrlinf = 2
const_model_fit_distedgecol = 3
const_model_fit_distedgerow = 4

const_model_fit_custom = 99