# busbud-notebook

A Docker image for running Jupyter notebooks with all the tools we use most often at Busbud.


## Quickstart

### Requirements

* Install [VirtualBox](https://www.virtualbox.org/) and [Docker Toolbox](https://www.docker.com/products/docker-toolbox)
* Create a Docker machine:

  ```
  docker-machine create -d virtualbox default
  ```
* Activate the machine. Every time you start a new shell (e.g. a new iTerm window or tab), you need to run

  ```
  eval "$(docker-machine env default)"
  ```

### Install busbud-notebook

This quickstart guide assumes you'll install under `~/busbud-notebook`.
If that's not the case, simply replace all occurrences of this path with any path you prefer.

* Clone this repository:

  ```
  git clone git@github.com:busbud/busbud-notebook.git ~/busbud-notebook
  ```

* Build the Docker image

  > Eventually we will publish the image to Docker Hub and this will no longer be necessary.
  > For the moment though, this step will take about 8 minutes.

  ```
  cd ~/busbud-notebook
  docker build -t busbud-notebook .
  ```

### Configure busbud-notebook

* Copy the docker-compose config file:

  ```
  cp docker-compose.template.yml docker-compose.yml
  ```

* Edit `docker-compose.yml` and configure it to your preferences.

  > Alternatively, steal a colleague's `docker-compose.yml`.

  * Replace `${NOTEBOOKS_DIR}` with the path on your computer where you'll be keeping your notebooks.
  * Remove the line with `${HOST_PACKAGES_DIR}`, it's an experimental feature that lets you inject pure-Python
    packages into Jupyter without having to rebuild the Docker image.
  * Replace the example credentials under the `environment` section with real ones.

### Run busbud-notebook

* Start with

  ```
  docker-compose up -d && docker logs -f busbud-notebook
  ```

* Stop with

  ```
  docker-compose stop && docker rm busbud-notebook
  ```


## Connect

The Jupyter notebook will run on port 8888, but if you're running this on OS X then the port doesn't appear on your localhost.
Instead, it will be exposed on your Docker VM, so you need to find its IP using

```
docker-machine ip default
```

Say the output of that command is `192.168.99.100`, then you should browse to `http://192.168.99.100:8888`.

Alternatively, this IP address shouldn't change so you can open `/etc/hosts` as root and add the following line at the end

```
192.168.99.100 jupyter.local
```

You can now browse to `http://jupyter.local:8888` to access the Jupyter notebook.


## IPython auto connect

The notebook loads the [ipython-auto-connect](https://github.com/busbud/ipython-auto-connect) package into every Python kernel, so with the right environment variables set up in `docker-compose.yml`, you can have implicit access to [SQLAlchemy sessions](http://docs.sqlalchemy.org/en/latest/orm/session_api.html#sqlalchemy.orm.session.Session) and [BigQuery-Python clients](https://github.com/tylertreat/BigQuery-Python).

* `<NAME>_DATABASE_URI` will inject the SQLAlchemy session `<name>_db`

  > `API_DATABASE_URI` in your config will provide the variable `api_db` to your notebooks.

* `<NAME>_BQ_EMAIL` will inject the BigQuery client `<name>_bq`, using credentials from `<NAME>_BQ_PROJECT` and `<NAME>_BQ_KEY`, all of which you can obtain from a JSON-format key for a service account.

  > `BIG_DATA_BQ_(EMAIL,KEY,PROJECT)` will provide the variable `big_data_bq` to your notebooks.
