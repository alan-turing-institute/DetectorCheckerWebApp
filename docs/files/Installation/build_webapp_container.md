
Requirements:
* [Docker Hub](https://hub.docker.com/) account
* [Docker](https://www.docker.com/get-started)

While working in the WebApp's main directory:

### Building a docker image
`docker build -t (dockerhub_account)/detectorchecker_dashboard:latest -f detectorchecker.dockerfile .`

### Pushing the build to Docker Hub
`docker push (dockerhub_account)/detectorchecker_dashboard:latest`

### Running locally via Docker
`docker run -p 1111:1111 (dockerhub_account)/detectorchecker_dashboard:latest`

Here,
- `(dockerhub_account)` - the dockerhub account where the container is stored.
