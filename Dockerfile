FROM alpine:3.3

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "@contrib http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && mkdir /root/.jupyter \
    && mkdir /host-packages \
    && mkdir -p /root/.local/lib/python2.7 \
    && ln -s /host-packages /root/.local/lib/python2.7/site-packages

COPY jupyter_notebook_config.py /root/.jupyter/

RUN apk add --update --no-cache \
      tini@contrib \
      python \
      python-dev \
      py-zmq@testing \
      py-numpy@testing \
      py-numpy-dev@testing \
      py-scipy@testing \
      alpine-sdk \
      freetype \
      freetype-dev \
      libpng \
      libpng-dev \
    && python -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip install --upgrade \
      pip \
      setuptools \
    && pip install \
      jupyter \
      pandas \
      python-nvd3 \
      scikit-learn \
      statsmodels \
      matplotlib \
    && apk del \
      alpine-sdk \
      py-numpy-dev \
      python-dev \
      freetype-dev \
      libpng-dev \
    && rm -r /root/.cache/pip

EXPOSE 8888
VOLUME ["/host-packages", "/notebooks"]
WORKDIR /notebooks
ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook"]
