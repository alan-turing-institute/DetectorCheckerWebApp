### How to prepare a new version of WebApp and publish it on Azure

## 0. Create a new WebApp on Azure (if it is done for the first time)

## 1. Build the DetectorChecker Web Application's docker container (local)

- In order to use the WebApp's `6. Send Data` functionality Azure storage and gmail accounts' login credentials/tokens need to be configured - a directory named `.secrets` needs to be created in the main WebApp's directory and two files in `.secrets` needs to be placed `azure_auth.sh` and `gmail.sh`.

The content of the files needs to be as follows:

`azure_auth.sh`:
```{bash}
export AZURE_STORAGE_ACCOUNT=""
export AZURE_CONNECTION_STRING=""
export AZURE_CONTAINER=""
```

`gmail.sh`:
```{bash}
export DC_EMAIL_ACC=""
export DC_EMAIL_PWD=""
```

## 2. Build the container image (and upload it to Docker Hub) (local)

Follow the guide for [How to (re)build a new WebApp container](https://github.com/alan-turing-institute/DetectorChecker/wiki/_new)

## 3. Restart the WebApp (Azure)

- Modify the image and tag number with respect to step 4 (if necessary)

`App Services -> detectorchecker -> Container settings -> Docker Hub -> Image and optional tag`

The name and tag number should match the ones specified in step 2.

Click **Save**

- Restart the WebApp

`App Services -> detectorchecker - restart`

It should take a couple of minutes for the new WebApp to become live.
