FROM rocker/r-ver:3.6.2

# install R, and setup CRAN mirror
#RUN apt-get update && apt-get install -y software-properties-common pandoc gnupg
RUN apt-get update; apt-get install -y libhdf5-dev
RUN apt-get update; apt-get install -y libtiff-dev
#RUN apt-get update; apt-get install -y r-cran-rjava

#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile

# install R packages
RUN Rscript -e "install.packages('shiny')"
RUN Rscript -e "install.packages('shinyjs')"
RUN Rscript -e "install.packages('shinythemes')"
RUN Rscript -e "install.packages('ggplot2')"
RUN Rscript -e "install.packages('tools')"
RUN Rscript -e "install.packages('tiff')"
RUN Rscript -e "install.packages('hdf5r')"
RUN Rscript -e "install.packages('raster')"
RUN Rscript -e "install.packages('igraph')"
RUN Rscript -e "install.packages('plyr')"
RUN Rscript -e "install.packages('dplyr')"
RUN Rscript -e "install.packages('readr')"
RUN Rscript -e "install.packages('testthat')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('rmarkdown')"
RUN Rscript -e "install.packages('roxygen2')"
RUN Rscript -e "install.packages('shinyBS')"
RUN Rscript -e "install.packages('lattice')"
RUN Rscript -e "install.packages('nlme')"
RUN Rscript -e "install.packages('spatstat')"
RUN Rscript -e "install.packages('shinydashboard')"
RUN Rscript -e "install.packages('dbscan')"

# install Azure CLI - instructions from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
RUN apt-get update; apt-get -y install lsb-release
RUN apt-get update; apt-get -y install curl
RUN apt-get update; apt-get -y install gnupg

RUN echo $(lsb_release -cs)

RUN AZ_REPO=$(lsb_release -cs) \
    &&  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

RUN curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN apt-get install -y apt-transport-https
RUN apt-get update; apt-get install -y --allow-unauthenticated azure-cli

# python, pip etc. so we can use python azure interface (avoid 2FA)
RUN apt-get -y install python3
RUN apt-get -y install python3-pip
RUN pip3 install --upgrade pip
RUN python3 -m pip install azure==4.0

RUN apt-get update; apt-get -y install libxml2-dev

RUN apt-get update; apt-get -y install libcurl4-openssl-dev libssl-dev

RUN Rscript -e "install.packages('devtools')"

# Installing detector checker
RUN Rscript -e "devtools::install_github('alan-turing-institute/DetectorChecker', ref = 'master')"

ADD . DetectorCheckerWebApp
WORKDIR DetectorCheckerWebApp
ENV DC_HOME /DetectorCheckerWebApp

# make sure that shiny.sh is an executable
RUN chmod +x shiny.sh

# expose R Shiny port
EXPOSE 1111

# launch the webapp
CMD ["./shiny.sh"]