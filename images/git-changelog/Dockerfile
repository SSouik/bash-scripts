FROM golang:latest

RUN apt-get update \
    && apt-get install -y \
    make \
    libssl-dev \
    libghc-zlib-dev \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    gettext \
    unzip \
    git

# Install git-chglog
RUN go install github.com/git-chglog/git-chglog/cmd/git-chglog@latest

COPY ./scripts .
RUN mv ./generate-changelog.sh /bin/generate-changelog
