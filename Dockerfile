FROM alpine:3.3

VOLUME ["/host-packages", "/notebooks"]

EXPOSE 8888
WORKDIR /notebooks
ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook"]

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "@contrib http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && mkdir /root/.jupyter \
    && mkdir -p /root/.ipython/profile_default \
    && mkdir -p /root/.local/lib/python2.7 \
    && ln -s /host-packages /root/.local/lib/python2.7/site-packages

COPY jupyter_*.py /root/.jupyter/
COPY ipython_*.py /root/.ipython/profile_default/

RUN apk --update --no-cache upgrade \
    && apk add --no-cache \
      ca-certificates \
      openssl \
      tini@contrib \
      python \
      py-zmq@testing \
      py-numpy@testing \
      py-scipy@testing \
      freetype \
      libpng \
      alpine-sdk \
      python-dev \
      py-numpy-dev@testing \
      freetype-dev \
      libpng-dev \
      postgresql-dev \
      libffi-dev \
      libxml2 \
      libxml2-dev \
      libxslt \
      libxslt-dev \
    && update-ca-certificates \
    && python -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip install --upgrade \
      pip \
      setuptools \
    && pip install \
      jupyter \
      pandas \
      scikit-learn \
      statsmodels \
      matplotlib \
    && pip install \
      arrow \
      requests \
      BeautifulSoup \
      lxml \
    && pip install --upgrade https://github.com/busbud/python-nvd3/tarball/jupyter \
    && pip install --upgrade https://github.com/busbud/ipython-auto-connect/tarball/master \
    && apk del \
      alpine-sdk \
      py-numpy-dev \
      python-dev \
      freetype-dev \
      libpng-dev \
    && pip uninstall -y setuptools \
    && pip install setuptools \
    && rm -r /root/.cache/pip
