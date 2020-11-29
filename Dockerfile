#
# OpsBots Package Builder
FROM opsbot/packages:latest as packages
WORKDIR /packages

# copy apk packages manifest
COPY packages/opsbot.txt /dist.txt

# RUN make dist(packages aren't written to usr/local/bin)
RUN mkdir -p /dist \
  && cd /packages/bin \
  && cp -a $(grep -v '^#' /dist.txt) /dist


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

ARG AWS_ACCOUNT_ID
ARG AWS_MFA_PROFILE
ARG AWS_DEFAULT_PROFILE
ARG AWS_REGION
ARG AWS_ROOT_ACCOUNT_ID
ARG S3FS_BUCKET
ARG S3FS_REGION

ENV AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID
ENV AWS_MFA_PROFILE=$AWS_MFA_PROFILE
ENV AWS_DEFAULT_PROFILE=$AWS_DEFAULT_PROFILE
ENV AWS_REGION=$AWS_REGION
ENV AWS_ROOT_ACCOUNT_ID=$AWS_ROOT_ACCOUNT_ID
ENV S3FS_BUCKET=$S3FS_BUCKET
ENV S3FS_REGION=$S3FS_REGION

ENV BANNER "opsbot shell"

# set env var for shell
ENV SHELL /bin/zsh

# This is not a "multi-user" system, so we'll use `/etc` as the global configuration dir
# Read more: <https://wiki.archlinux.org/index.php/XDG_Base_Directory>
ENV XDG_CONFIG_HOME=/etc
# set zsh root dir in etc/zsh
ENV ZDOTDIR /etc/zsh

# add cloudposse apk repository
ADD https://apk.cloudposse.com/ops@cloudposse.com.rsa.pub /etc/apk/keys/
RUN echo "@cloudposse https://apk.cloudposse.com/3.12/vendor" >> /etc/apk/repositories

# Use TLS for alpine default repos
RUN sed -i 's|http://dl-cdn.alpinelinux.org|https://alpine.global.ssl.fastly.net|g' /etc/apk/repositories && \
  echo "@community https://alpine.global.ssl.fastly.net/alpine/v3.12/community" >> /etc/apk/repositories && \
  echo "@testing https://alpine.global.ssl.fastly.net/alpine/edge/testing" >> /etc/apk/repositories

# copy apk packages manifest
COPY packages/alpine.txt /etc/apk/packages.txt

# install apk packages from manifest
RUN apk update && \
  apk add --no-cache $(grep -v '^#' /etc/apk/packages.txt) && \
  rm -f /tmp/* /etc/apk/cache/*

# install tfenv and recent versions of terraform
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
  && ln -s ~/.tfenv/bin/* /usr/local/bin \
  && tfenv install 0.12.29 \
  && tfenv install 0.13.5 \
  && tfenv install 0.14.0-rc1 \
  && tfenv use 0.12.29

# install tgenv and recent versions of terragrunt
RUN git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv \
  && ln -s ~/.tgenv/bin/* /usr/local/bin \
  && tgenv install 0.23.40 \
  && tgenv install 0.24.4 \
  && tgenv install 0.25.5 \
  && tgenv install 0.26.7 \
  && tgenv use 0.23.40

RUN ln -s /usr/bin/python3 /usr/bin/python

# Copy dist folder from packages builder
COPY --from=packages /dist/ /usr/local/bin/

# Copy python dependencies
COPY --from=python /dist/ /usr/

# copy root filesystem customizations
COPY rootfs/ /

# copy config files
COPY conf/ /conf

# copy documentation
COPY docs/man/ /usr/share/docs/

# build custom man pages
RUN /usr/local/bin/docs update

# Filesystem entry for tfstate
RUN [ "${S3FS_BUCKET}" = "" ] || s3 fstab "${S3FS_BUCKET}" "/" "/s3fs"

# replace user login shells with zsh
RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd

# default command will execute install script
CMD ["/usr/local/bin/install"]
