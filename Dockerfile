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

# replace user login shells with zsh
RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd

# default command is zsh version
CMD ["zsh", "--version"]
