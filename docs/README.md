# DetectorChecker Web application documentation

The following guides describe how we publish the DetectorCheckerWebApp.

We maintain two versions of the DetectorCheckerWebApp:

1. **Production**: A stable release version (https://detectorchecker.azurewebsites.net) 
2. **Development**: A development version for testing new features. Only used by the development team (https://detectorcheckerdev.azurewebsites.net)


## Requirements

To deploy the DetectorCheckerWebApp you will need:
- Docker (https://www.docker.com)
- Microsoft Azure (https://azure.microsoft.com/en-gb/) with a subscription
- A DockerHub account (https://hub.docker.com)

## Deployment guides

To deploy a WebApp fror the first time follow these instructions through in order:

- [Setting up Azure storage](./files/Installation/azure_setup.md)

- [Build a Docker container](./files/Installation/build_webapp_container.md)

- [Setting up the Azure WebApp](./files/Installation/create_webapp.md)


## Storage

- [Accessing User Uploaded Data on Azure](./files/Data/access_azure_storage.md)

- [Naming convention on Azure](./files/Data/naming.md)


## Other
- [How to install Storage Explorer on Ubuntu 16](./files/Installation/install_on_ubuntu16.md)