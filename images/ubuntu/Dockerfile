FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y \
    make \
    libssl-dev \
    libghc-zlib-dev \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    gettext \
    unzip \
    git

COPY ./scripts .
RUN mv ./commit-lint.sh /bin/commit-lint
RUN mv ./version-check.sh /bin/version-check
