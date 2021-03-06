FROM ruby:2.5-alpine

ENV LANG C.UTF-8
ADD ./Gemfile ~/.temp/Gemfile
ADD ./Gemfile.lock ~/.temp/Gemfile.lock

WORKDIR ~/.temp/

ARG RUNTIME_PACKAGES="libxml2-dev python3 libxslt-dev mysql-dev nodejs imagemagick=6.9.6.8-r1 tzdata"
ARG BUILD_PACKAGES="build-base make python3-dev git bash curl findutils binutils-gold tar linux-headers imagemagick-dev=6.9.6.8-r1"
ARG BUNDLE_INSTALL_OPTION="--without development test"

RUN echo 'install: --no-document' >> ~/.gemrc && \
    echo 'update: --no-document' >> ~/.gemrc  && \
    echo 'http://dl-cdn.alpinelinux.org/alpine/v3.5/main' >> /etc/apk/repositories  && \
    apk add --update --no-cache --virtual build-dependencies $BUILD_PACKAGES && \
    apk add --update --no-cache $RUNTIME_PACKAGES && \
    rm -f /usr/lib/libmysqld* && \
    rm -f /usr/bin/mysql* && \
    pip3 install --upgrade pip && \
    pip3 install awscli && \
    gem install bundler && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install -j4 $BUNDLE_INSTALL_OPTION && \
    apk del build-dependencies

RUN adduser -D -H -u 1000 -s /bin/bash www-data && \
    mkdir -p /var/run/capibara && \
    chown www-data:www-data /var/run/capibara

COPY . /var/capibara

ADD ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /var/capibara

RUN mkdir -p /var/capibara/public/assets && \
    rake assets:precompile --trace RAILS_ENV=asset

VOLUME ["/var/run/capibara"]
VOLUME ["/var/capibara/public"]
CMD [ "puma", "-w", "2" ]