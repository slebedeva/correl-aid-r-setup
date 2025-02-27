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

## Note on rstudio-settings

Currently the only setting I choose to change from default is to wrap text in code editor. We use ephemeral containers (`--rm` makes sure they are removed after we finish and start fresh again next time), so Rstudio user settings will disappear as well. To save them, simply start the container, choose your settings, go to Terminal and `cp ~/.config/rstudio/rstudio-prefs.json [your mounted folder of choice]`. In my case, I mount the settings directory directly from home of this repo (`rstudio-settings`) - you will need to edit mount bind in the `run_docker_local_mount.sh` if you change it.

## Docker-compose

Trying to use secrets directive to provide rstudio password, but it does not work. For now:

- start service with `docker compose up -d`
- print logs with `docker compose logs`
- find your tmporary password like this:
```
rstudio-1  | tput: No value for $TERM and no -T specified
rstudio-1  | The password is set to <password>
rstudio-1  | If you want to set your own password, set the PASSWORD environment variable. e.g. run with:
rstudio-1  | docker run -e PASSWORD=<YOUR_PASS> -p 8787:8787 rocker/rstudio
```
- go to localhost:8787 and login with rstudio username and the password,

## Bumping up R version 

In 2025, the students will have installed R 4.4.2 so I update the image as well.
