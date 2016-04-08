# busbud-notebook

A Docker image for running Jupyter notebooks with all the tools we use most often at Busbud.

## Usage

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
