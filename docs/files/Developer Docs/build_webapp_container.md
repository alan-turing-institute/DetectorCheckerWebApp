
# Build a Docker Container

We need to build a docker container to hold the DetectorCheckerWebApp.

# Requirements
- [Docker Hub](https://hub.docker.com/) account
- [Docker](https://www.docker.com/get-started)

## 1. Create a private DockerHub repository

1. Create a DockerHub account and create a private repository (users can have two free private repositories)

## 2. Clone the DockerHubWebApp repo

1. First we need to clone the DockerHubWebApp repo
```
git clone https://github.com/alan-turing-institute/DetectorCheckerWebApp.git
```
2. Navigate to the repository
```
cd DetectorCheckerWebApp
```

## 3. Add storage credential information

In order for the WebApp to send data from users to the Azure storage account, and to send an email to the account maintainer when data has beem uploaded, we must include login credentials/tokens which are used when building the docker image. 

1. From the command line create a new directory in the DetectorCheckerWebApp repository (assuming using Mac)

```
mkdir .secrets
```

2. Create two new files:

```
cd .secrets
touch azure_auth.sh gmail.sh
```

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

where DC_EMAIL_ACC is the email address and DC_EMAIL_PWD is the password. 


## 4. Creating the Docker image

1. Build the docker image

```
docker build -t (dockerhub_account)/detectorchecker_dashboard:<tag> -f detectorchecker.dockerfile .
```

Here `<tag> ` needs to be replaced by an appropriate docker tag. When building for the production version of the WebApp we replace tag with `latest`. When building for the development version we replace it with `latest_devel`

2. Push the build to Docker Hub

```
docker push (dockerhub_account)/detectorchecker_dashboard:<tag>
```

3. Optionally test the docker image locally

```
docker run -p 1111:1111 (dockerhub_account)/detectorchecker_dashboard:<tag>
```

Here,
- `(dockerhub_account)` - the dockerhub account where the container is stored.
