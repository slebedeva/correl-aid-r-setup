#!/bin/bash

# run this script like bash thisscript.sh path-to-correlaid
if [ $# -ne 1 ]; then
	echo "Usage: $0 <path-to-correlaid-directory>"
	echo "Using default value, the parent directory .."
fi


# Path to the parent of the cloned CorrelAid github repository
#CORREL_HOME=$1
CORREL_HOME=${1:-$(realpath ..)} # default value is one directory above

# the location of the renv cache on the host machine
RENV_PATHS_CACHE_HOST=${CORREL_HOME}/renv-cache
mkdir -p $RENV_PATHS_CACHE_HOST

# where the cache should be mounted in the container
RENV_PATHS_CACHE_CONTAINER=/home/rstudio/.cache/R/renv

# run the container with the host cache mounted in the container
docker run --rm \
    -e "RENV_PATHS_CACHE=${RENV_PATHS_CACHE_CONTAINER}" \
    -v "${RENV_PATHS_CACHE_HOST}:${RENV_PATHS_CACHE_CONTAINER}" \
    -v "${CORREL_HOME}:/home/rstudio/CorrelAid"  \
    -e "PASSWORD=foobar"  \
    -p 8787:8787 \
    correl-aid:latest #replace with your container name

exit 0