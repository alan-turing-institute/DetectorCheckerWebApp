FROM r-base:3.5.1

# install R, and setup CRAN mirror
#RUN apt-get update && apt-get install -y software-properties-common pandoc gnupg
RUN apt-get update; apt-get install -y libhdf5-dev
RUN apt-get update; apt-get install -y libtiff-dev

#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile

# install R packages
RUN Rscript -e "install.packages('shiny')"
RUN Rscript -e "install.packages('shinythemes')"
RUN Rscript -e "install.packages('ggplot2')"
RUN Rscript -e "install.packages('spatstat')"
RUN Rscript -e "install.packages('tools')"
RUN Rscript -e "install.packages('tiff')"
RUN Rscript -e "install.packages('h5')"
RUN Rscript -e "install.packages('raster')"
RUN Rscript -e "install.packages('igraph')"
RUN Rscript -e "install.packages('plyr')"
RUN Rscript -e "install.packages('dplyr')"
RUN Rscript -e "install.packages('testthat')"
RUN Rscript -e "install.packages('knitr')"
RUN Rscript -e "install.packages('rmarkdown')"
RUN Rscript -e "install.packages('roxygen2')"
RUN Rscript -e "install.packages('devtools')"

# this is where detectorchecker package should installed

ADD . DetectorCheckerWebApp
WORKDIR DetectorCheckerWebApp

# this is temporary while we do not publish the app on CRAN
RUN Rscript -e "install.packages('detectorchecker_0.1.5.tar.gz', repos = NULL, type='source')"

# make sure that shiny.sh is an executable
# RUN chmod +x shiny.sh

# azure config
ENV AZURE_STORAGE_ACCOUNT detectorcheckerstorage
ENV AZURE_STORAGE_ACCESS_KEY aSMDADXSZEdGfBiuIUMlmvBIZEWhY+40NvQ5JLZKADsBZ5ZCYTxin7HvhSL5/cu15vOIYXIEHaaKsYcEKdufdA==
ENV AZURE_CONTAINER detectorcheckercontainer

# expose R Shiny port
EXPOSE 1111

# launch the webapp
CMD ["./shiny.sh"]
