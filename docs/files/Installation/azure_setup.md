# Setting up Azure Storage



We deploy a Production and Development version of the app. For each we need to setup Azure to store the data uploaded by users of the WebApp.

## Requirements

The following instructions assume that you have:

* An Azure subscription 

and locally installed:

* Azure CLI


## Creating a storage account

From a command line run the following commands. Values in <> should be replaced with respect to the set up and project description. Comments below show the arguments we use for the development and production versions of the WebApp.

### 1.1. Create a new resource group:

```
az group create \
    --name <project-resource-group> \
    --location uksouth
```


```Development: <project-resource-group> = dc_dev_rg ```

```Production:  <project-resource-group> = dc_prod_rg ```


### 1.2. Create a storage account:

```
az storage account create \
    --name <project> \
    --resource-group <project-resource-group> \
    --location uksouth \
    --sku Standard_LRS \
	--encryption blob
```
```Development: <project> = dcdevelstg```

```Production:  <project> = dcprodstg ```

### 1.3. Specify storage account credentials:

#### 1.3.1. First, display your storage account keys:

```
az storage account keys list \
    --account-name <project> \
    --resource-group <project-resource-group> \
    --output table
```

#### 1.3.2. Now, set the AZURE_STORAGE_ACCOUNT and AZURE_STORAGE_ACCESS_KEY environment variables:

```
export AZURE_STORAGE_ACCOUNT=<project>
export AZURE_STORAGE_ACCESS_KEY="<one of the key values from the previous table>"
```

### 1.4. Create a container

```
az storage container create --name <projectcontainer>
```
```Development: <projectcontainer> = dcprodcont```

```Production:  <projectcontainer> = dcdevcont ```