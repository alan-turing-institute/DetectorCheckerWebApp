# Create a new WebApp on Azure

Once we have set up our Azure storage and have pushed our docker image to DockerHub we can publish the WebApp on Azure. 

### Create the WebApp

 1. Login to the Azure portal https://portal.azure.com

 2. On the left hand bar, click "App Services".

 3. Click "+ Add" at the top, then choose "Web App", then "Create" on the bottom right.

 4. On the "Create" form, choose an app name (e.g. <project>) - this will form the URL for your app, so needs to be unique.  Choose a subscription and Resource Group (creating one if necessary), and for "OS" choose "Docker".  Then click on "Configure container".

 5. In the "Container Settings" choose "Docker Hub" as the image source, then "Public" or "Private" depending on the settings of your docker hub repo. (If it is "Private" you will also need to provide your docker hub login details.)

 6. In "Container Settings" you need to select the DockerHub image you would like to use. For the development branch we use `dockerhub_account)/detectorchecker_dashboard:latest_devel`, while for the production branch we use `(dockerhub_account)/detectorchecker_dashboard:latest`.

 7. Then click "Create" back on the "Web App create" section.  It will take a
 few minutes to deploy, and after that it will be visible from the "App Services" link on the left of the Azure portal.  If you click on the app here you'll
 get the info for it, including the URL.

### Port Configuration

 * Finally, we need to configure the app to use the correct port.  Go to
 the "Application Settings" of the app in the Azure portal, click ```+ Add new setting``` and add a setting called ```PORT``` with value ```1111:1111```.  Then go back to the "Overview" and restart the app using the button at the top.
 
 * In practice, even after the Azure portal said it was available and healthy,  it can take a long time (about 5 mins) to respond the first time, as the docker image needs to be downloaded and deployed, but after that it should be more responsive.


