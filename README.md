# busbud-notebook

A Docker image for running Jupyter notebooks with all the tools we use most often at Busbud.

## Run using docker compose

### Configure

This repository contains `docker-compose.template.yml` with some default options you might want.
Copy this file to `docker-compose.yml` and customize it:

```sh
cp docker-compose.template.yml docker-compose.yml
vim docker-compose.yml
```

In particular, it expects the following:

* the env var `NOTEBOOKS_DIR` containing the absolute path to where you want to serve
  notebooks from on your host computer
* the env var `HOST_PACKAGES_DIR` containing the absolute path to a Python `site-packages`
  directory with packages you want to make available inside notebooks

  > **Important!** If your host isn't a 64 bit Linux, only pure Python packages will work.

* the file `local.env` in the current directory containing env vars you want to make available
  to the code running inside notebooks. The format is `NAME=value`, one per line.

You can customize this as you wish, removing or adding volumes, env vars or other env files.
See [Docker compose file reference](https://docs.docker.com/compose/compose-file/) for available options.

### Run

Once you have all the files (`local.env`) and env vars (`NOTEBOOKS_DIR`, `HOST_PACKAGES_DIR`) in place,
you simply

```sh
docker-compose up
```

When you're done, you can run either one of the two commands:

```sh
docker-compose stop
docker kill busbud-notebook
```

## Run using plain docker

Basic usage:

```sh
docker run -p 8888:8888 busbud-notebook
```

### Notebooks

If you need to load notebooks from a folder on your computer, `<notebooks_dir>`,
you can pass the absolute path as a volume:

```sh
docker run -p 8888:8888 -v <notebooks_dir>:/notebooks busbud-notebook
```

A simpler way is to navigate to `<notebooks_dir>` and run this literally:

```sh
docker run -p 8888:8888 -v `pwd`:/notebooks busbud-notebook
```

### Python packages

If you need additional packages that don't come with busbud-notebook, you can install them
into a virtualenv and mount its site-packages folder as a volume:

```sh
cd <notebook_packages>
virtualenv .
. bin/activate
pip install Example
docker run -p 8888:8888 -v `pwd`/lib/python2.7/site-packages:/host-packages busbud-notebook
```

The container then symlinks its `/host-packages` to the appropriate place where Python looks for user packages.


## Building

Until we publish the image to the Hub, you have to build the image locally.
From the directory containing this Dockerfile, run:

```sh
docker build -t busbud-notebook .
```
