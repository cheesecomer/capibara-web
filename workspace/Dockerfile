FROM ruby:2.5-alpine

ENV LANG C.UTF-8

ARG RUNTIME_PACKAGES="libxml2-dev python libxslt-dev mysql-dev nodejs imagemagick=6.9.6.8-r1 tzdata"
ARG BUILD_PACKAGES="build-base make python-dev py-pip git bash curl findutils binutils-gold tar linux-headers imagemagick-dev=6.9.6.8-r1"
ARG LIBV8_BRANCH="v3.16.14.19"
ARG LIBV8_VERSION="3.16.14.19-x86_64-linux"
ARG LIBV8_DEPENDS="3.16.14.19-x86_64-linux"
ARG BUNDLE_INSTALL_OPTION="--without development test"

RUN echo 'install: --no-document' >> ~/.gemrc && \
    echo 'update: --no-document' >> ~/.gemrc  && \
    echo 'http://dl-cdn.alpinelinux.org/alpine/v3.5/main' >> /etc/apk/repositories  && \
    apk add --update --no-cache $BUILD_PACKAGES && \
    apk add --update --no-cache $RUNTIME_PACKAGES && \
    pip install --upgrade pip && \
    pip install awscli && \
    gem install bundler

RUN apk add --update --no-cache bash

WORKDIR /var/capibara

# ENTRYPOINT "/bin/bash"
RUN echo "(1..Float::INFINITY).each { sleep(1) }" > /bin/init.rb
CMD ["ruby", "/bin/init.rb"]