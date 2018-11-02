# DetectorCheckerWebApp
 Project to develop software to assess developing detector screen damage (Web App based on the original DetectorChecker package)


# Docker image preparation

## Building a docker image
docker build -t tomaslaz/detectorchecker_dashboard:latest -f detectorchecker.dockerfile .

## Pushing the build to docker hub
docker push tomaslaz/detectorchecker_dashboard:latest
