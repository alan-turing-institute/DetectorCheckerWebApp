### How to install Storage Explorer on Ubuntu 16



### Installing prerequisites for .NET Core

https://docs.microsoft.com/en-gb/dotnet/core/linux-prerequisites?tabs=netcore2x

```
sudo apt-get install -y liblttng-ust0 libcurl3 libssl1.0.0 libkrb5-3 zlib1g libicu55
```

```
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-2.2
```

### Installing .NET Core

```
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
```

```
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install aspnetcore-runtime-2.2
```


### Installing prerequisites for Storage explorer

```
sudo apt-get install -y libgconf-2-4
sudo apt-get install -y libsecret-1-0
```

### Installing Storage Explorer

Simply download, extract and run Storage Explorer from

https://azure.microsoft.com/en-us/features/storage-explorer/
