# correl-aid-r-setup

Docker set up for R environment used in CorrelAid R course

This is my set up for the [CorrelAid R Lernen course](https://www.correlaid.org/bildung/r-lernen/).

You will need [Docker](https://www.docker.com/) installed.

## Quick Start

1. Create a CorrelAid directory in your desired location and change to it.

```
mkdir -p CorrelAid && cd $_
```

2. Clone the current git repository along with the CorrelAid lernplattform repository.

```
git clone https://github.com/correlAid/lernplattform
git clone https://github.com/slebedeva/correl-aid-r-setup
```

3. Enter the current repository and create a Docker image. The size of the image is ~3GB.

```
docker build -t correl-aid .
```

4. Start the script to run the container by using the provided Makefile.

```
make run
```

5. Open your browser and navigate to `localhost:8787`. Enter username `rstudio` and password `foobar`.

6. Inside Rstudio, navigate into the `/home/rstudio/CorrelAid/lernplattform` directory. Click on File -> New Project and create a new Rproject choosing existing directory `lernplattform`.

7. Create an .Rprofile file inside the project directory with the following content:

```
renv::restore(prompt = FALSE)
```

8. Source the .Rprofile or restart the session and wait for renv to install all the packages.

To routinely start the container now, navigate to the `correl-aid-r-setup` directory and type `make run`. Repeat step 5 to enter Rstudio and go to Project -> Open to open the project `lernplattform.Rproj` inside the `lernplattform` directory. Wait for renv to quickly restore packages from cache.
 
## What it does

I used [Rocker](https://rocker-project.org/) `rocker/rstudio:4.3.1` container as our starting point since this is the version used by the CorrelAid team as of September 2024. renv is included in the [CorrelAid repository](https://github.com/correlAid/lernplattform?tab=readme-ov-file#package-management-mit-renv). We need to add some system dependencies: `libz-dev libpng-dev libgdal-dev gdal-bin libgeos-dev libproj-dev libsqlite3-dev libfontconfig1-dev libharfbuzz-dev libfribidi-dev libudunits2-dev make pandoc zlib1g-dev`, as well as R packages not included in renv: `renv` itself, `rmarkdown` and `learnr`.

`renv::restore()` will look for renv files and use them to reproduce CorrelAid environment. 

- This command can be included in the Dockerfile - this would be the preferred option to keep the whole environment contained. However, my docker build kept breaking because of connection issues (renv randomly could not locate package sources).
- Therefore I went with the option of keeping renv cache on my local machine and mounting it into the container when I run it. This allowed me to skip re-installing already installed packages from scratch every time renv encountered an error. This setup necessitates running `renv::restore()` every time I start the container, but it is relatively fast and in principle allows to re-use the same renv cache for other images, if there is a need. The size of the cache is around 900MB. In my setup, this is stored in `CorrelAid/renv-cache` and mounted into the default renv cache directory `/home/rstudio/.cache/R/renv` on the container.

Makefile provides a shorthand to start the container using the script `run_docker_local_mount.sh` with the command `make run` and default CorrelAid directory location (the parent directory above of where the script is stored). You can run the script itself providing a custom CorrelAid directory location like: `bash run_docker_local_mount.sh <path to correlaid directory>`.
