# DetectorCheckerWebApp

Created by: [Julia Brettschneider](https://github.com/ejulia17) (original R code), [Wilfrid Kendall](https://github.com/WilfridSKendall) (testing and editing),
[Tomas Lazauskas](https://github.com/tomaslaz) (R package engineering) and [Oscar Giles](https://github.com/OscartGiles) (package development)

## Overview

An interactive WebApp for analysing pixel damage in CT scanners using the DetectorChecker `R` package (https://github.com/alan-turing-institute/DetectorChecker).

This WebApp loads data acquired from detector screens (`tiff` images from daily tests, or `xml` files listing bad pixels), and applies methods from spatial statistics (particularly the R package `spatstat`) to produce analyses and graphical reports concerning location and possible departures from spatial randomness of damaged pixels and regions.

# Running the app 

## Official Release

The official release of the DetectorChecker WebApp is hosted at https://detectorchecker.azurewebsites.net



## Development Release

A development version of the WebApp is hosted at https://detectorcheckerdev.azurewebsites.net

This is strictly for development purposes and should not be used by end users. 


# Documentation
A user guide is available as a [pdf file](docs/files/WebApp_user_docs/detectorCheckerManual-WSK_JAB2.pdf)


# Running the App from source

There are several ways to launch the WebApp from source, which is strictly for development purposes. First clone the repository

Make sure you have the latest version of the DetectorChecker R package installed (see https://github.com/alan-turing-institute/DetectorChecker)

### Dependencies

To run the WebApp from source make sure you have the following R packages installed:

```
install.packages(c("shiny", "shinyjs", "shinyBS", "shinythemes", "spatstat", "shinydashboard"))
```

### Run with R (limited functionality)

1. Navigate to the *webapp* subdirectory and run the *run.R* file.

2. Open a browser and go to `http://0.0.0.0:1111`

### Shiny App (running locally)

The WebApp can be run as a shiny app simply by running the bash script in the main directory:

1. Run the bash script from the terminal:

 ```bash shiny.sh```

2. Open a browser and go to `http://0.0.0.0:1111`

**Limited functionality**: The WebApp will run, but you will not be able to upload data to the cloud. To add this functionality you will need to add credential information to a folder called `.secrets` (see the instructions on [adding storage credential information](/docs/files/Developer_Docs/build_webapp_container.md)).


### Docker image

It is possible to run the WebApp as a Docker image (https://www.docker.com). See the instructions on how to [build the Docker image](/docs/files/Developer_Docs/build_webapp_container.md).


# Repository Structure 

The repository contains two sub folders:

`docs`: Documentation with a description of how to build the WebApp for developers.

`webapp`: R and Python scripts.

# Data management (Azure)

## Naming convention

```
email@address/yyyy-mm-dd-hh-mm-ssssss/layout_name.ext
email@address/yyyy-mm-dd-hh-mm-ssssss/layout_name.dc
```

