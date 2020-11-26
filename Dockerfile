#
# OpsBot Shell Builder
FROM alpine:3.12

# set env var for shell
ENV SHELL /bin/zsh

# install zsh package
RUN apk update \
  && apk add --no-cache zsh \
  && rm -f /tmp/* /etc/apk/cache/*

# replace user login shells with zsh
RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd

# default command is zsh version
CMD ["zsh", "--version"]
