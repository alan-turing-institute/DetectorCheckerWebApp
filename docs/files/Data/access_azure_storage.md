### Accessing User Uploaded Data on Azure

User uploaded data can be accessed via [Azure Storage Explorer](https://azure.microsoft.com/en-gb/features/storage-explorer/)

```{text}
Azure Storage Explorer is supported on the following versions of macOS:
· macOS 10.12 "Sierra" and later versions

Azure Storage Explorer is supported on the following versions of Windows:
· Windows 10 (recommended)
· Windows 8
· Windows 7
For all versions of Windows, .NET Framework 4.6.2 or greater is required.

Azure Storage Explorer is supported on the following distributions of Linux:
· Ubuntu 16.04 x64 (recommended)
· Ubuntu 17.10 x64
· Ubuntu 14.04 x64

Azure Storage Explorer may work on other distributions, but only ones listed above are officially supported.
```

- [How to install Storage Explorer on Ubuntu 16](../Installation/install_on_ubuntu16.md)

## Adding a new storage account

1. Click on __Connect to Azure Storage__

2. Choose __Use a connection string__ and click __Next__.

3. Enter a preferred display name for the storage account, e.g. `Detector Checker`.

4. Enter a __connection string__ which can be obtained from [Azure](https://portal.azure.com): Storage accounts-> (storage account name) -> Shared access signature -> Please choose carefully permissions and start/expiry dates you would like to grant for the access using the connection string and click Generate SAS and connection string. We recommend to use key1 as the default signing key.

5. click __Next__ and __Connect__.

A storage account should be visible under the Storage Accounts in the navigation panel. The file system can be accessed in Storage Accounts in the explorer menu.
