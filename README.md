# DetectorCheckerWebApp

An interactive WebApp for analysing pixel damage in CT scanners using the DetectorChecker R package (https://github.com/alan-turing-institute/DetectorChecker).


# Running the app 

## Official Release

The official release of the DetectorChecker WebApp is hosted at https://detectorchecker.azurewebsites.net



## Development Release

A development version of the WebApp is hosted at https://detectorcheckerdev.azurewebsites.net

This is strictly for development purposes and should not be used by end users. 



# Running the App from source

There are several ways to launch the WebApp from source, which is strictly for development purposes. First clone the repository.

### Run with R (limited functionality)

1. Navigate to the *webapp* subdirectory and run the *run.R* file.

2. Open a browser and go to `http://0.0.0.0:1111`

### Shiny App (running locally)

The WebApp can be run as a shiny app simply by running the bash script in the main directory:

1. Run the bash script from the terminal:

 ```bash shiny.sh```

2. Open a browser and go to `http://0.0.0.0:1111`

**Limited functionality**: The WebApp will run, but you will not be able to upload data to the cloud. To add this functionality you will need to add credential information to a folder called `.secrets` (see the instructions on [adding storage credential information](/docs/files/Installation/build_webapp_container.md)).


### Docker image

It is possible to run the WebApp as a Docker image (https://www.docker.com). See the instructions on how to [build the Docker image](/docs/files/Installation/build_webapp_container.md).


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

