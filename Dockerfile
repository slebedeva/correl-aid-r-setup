# Dockerfile to make an environment for CorrelAid Rlernen course
# Start with rocker rstudio image and the version that CorrelAid uses
FROM rocker/rstudio:4.4.2


# Install missing system dependencies for packages in renv
RUN apt-get update && apt-get install -y libz-dev libpng-dev libgdal-dev gdal-bin libgeos-dev libproj-dev libsqlite3-dev libfontconfig1-dev libharfbuzz-dev libfribidi-dev libudunits2-dev make pandoc zlib1g-dev


# Install R packages missing in renv
RUN Rscript -e "install.packages('renv')" -e "install.packages('rmarkdown')" -e "install.packages('learnr')"

# Optionally, install renv packages into the container (alternatively, mount an renv cache from the local machine)
#RUN Rscript -e "renv::activate()" -e "renv::restore()"
#RUN Rscript -e "renv::activate()" -e "renv::restore(repos = c(CRAN = 'https://cloud.r-project.org'))"



