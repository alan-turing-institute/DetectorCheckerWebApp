# DetectorCheckerWebApp
 Project to develop software to assess developing detector screen damage (Web App based on the original DetectorChecker package)


# Docker image preparation

## Building a docker image
docker build -t tomaslaz/detectorchecker_dashboard:0.1.8 -f detectorchecker.dockerfile .

## Pushing the build to docker hub
docker push tomaslaz/detectorchecker_dashboard:0.1.8

## Running locally
docker run -p 1111:1111 tomaslaz/detectorchecker_dashboard:0.1.8

# Data management (Azure)

## Naming convention

```
email@address/yyyy-mm-dd-hh-mm-ssssss/layout_name.ext
email@address/yyyy-mm-dd-hh-mm-ssssss/layout_name.dc
```

## Uploading/Downloading data to/from Azure using Azure CLI
Requires: azure cl

https://docs.microsoft.com/en-gb/cli/azure/install-azure-cli?view=azure-cli-latest

-------------
## Parameters


### Should not be changed
```
--container-name detectorcheckercontainer - The detectorchecker container name.
```
-------------

## Commands

### List the blobs in a container
https://docs.microsoft.com/en-gb/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-list
```
az storage blob list \
  --container-name detectorcheckercontainer \
  --output table
```
### Uploads a blob
https://docs.microsoft.com/en-gb/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-upload
```
--name - The blob name.
--file - Path of the file to upload as the blob content.

az storage blob upload \
    --container-name detectorcheckercontainer \
    --name temp.txt \
    --file ~/temp.txt
```

### Downloads a blob
https://docs.microsoft.com/en-gb/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-download
```
--name - The blob name.
--file - Path of file to write out to.

az storage blob download \
    --container-name detectorcheckercontainer \
    --name temp.txt \
    --file ~/temp.txt
```

### Deletes a blob
https://docs.microsoft.com/en-gb/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-delete
```
az storage blob delete \
  --container-name detectorcheckercontainer \
  --name temp.txt
```
