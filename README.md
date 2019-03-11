# DetectorCheckerWebApp
 Project to develop software to assess developing detector screen damage (Web App based on the original DetectorChecker package)


# Docker image preparation

## Building a docker image
docker build -t detectorchecker/detectorchecker_dashboard:latest -f detectorchecker.dockerfile .

## Pushing the build to docker hub
docker push detectorchecker/detectorchecker_dashboard:latest

## Running locally
docker run -p 1111:1111 detectorchecker/detectorchecker_dashboard:latest

# Data management (Azure)

## Naming convention

```
email@address/yyyy-mm-dd-hh-mm-ssssss/layout_name.ext
email@address/yyyy-mm-dd-hh-mm-ssssss/layout_name.dc
```
