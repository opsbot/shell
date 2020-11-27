#
# OpsBots Package Builder
FROM opsbot/packages:latest as packages
WORKDIR /packages

#
# Install the select packages from the opsbots package manager image
# Repo: <https://github.com/opsbots/packages>
ARG PACKAGES="cfssl cfssljson gomplate"
ENV PACKAGES=${PACKAGES}
# RUN make dist(packages aren't written to usr/local/bin)
RUN mkdir -p /dist \
  && cd /packages/bin \
  && cp -a $PACKAGES /dist


#
# Python Builder
FROM alpine:3.12 as python

RUN sed -i 's|http://dl-cdn.alpinelinux.org|https://alpine.global.ssl.fastly.net|g' /etc/apk/repositories
RUN apk add python3 python3-dev py3-pip libffi-dev gcc linux-headers musl-dev openssl-dev make

COPY requirements.txt /requirements.txt

RUN pip install --upgrade pip setuptools wheel && \
  pip install -r /requirements.txt --ignore-installed --prefix=/dist --no-build-isolation --no-warn-script-location


#
# OpsBot Shell Builder
FROM alpine:3.12

# set env var for shell
ENV SHELL /bin/zsh

# add cloudposse apk repository
ADD https://apk.cloudposse.com/ops@cloudposse.com.rsa.pub /etc/apk/keys/
RUN echo "@cloudposse https://apk.cloudposse.com/3.12/vendor" >> /etc/apk/repositories

# Use TLS for alpine default repos
RUN sed -i 's|http://dl-cdn.alpinelinux.org|https://alpine.global.ssl.fastly.net|g' /etc/apk/repositories && \
  echo "@community https://alpine.global.ssl.fastly.net/alpine/v3.12/community" >> /etc/apk/repositories && \
  echo "@testing https://alpine.global.ssl.fastly.net/alpine/edge/testing" >> /etc/apk/repositories

# copy apk packages manifest
COPY packages.txt /etc/apk/packages.txt

# install apk packages from manifest
RUN apk update && \
  apk add --no-cache $(grep -v '^#' /etc/apk/packages.txt) && \
  rm -f /tmp/* /etc/apk/cache/*

# Copy dist folder from packages builder
COPY --from=packages /dist/ /usr/local/bin/

# Copy python dependencies
COPY --from=python /dist/ /usr/

# copy root filesystem customizations
COPY rootfs/ /

# replace user login shells with zsh
RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd

# default command will execute install script
CMD ["/usr/local/bin/install"]
