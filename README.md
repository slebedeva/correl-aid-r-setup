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

6. Inside Rstudio, navigate into the `../lernplattform` directory. Click on File -> New Project and create a new Rproject choosing existing directory lernplattform.

7. Create an .Rprofile file inside the project directory with the following content:

```
renv::restore(prompt = FALSE)
```

8. Source the .Rprofile or restart the session and wait for renv to install all the packages.


 
