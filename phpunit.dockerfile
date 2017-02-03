# BUILD:
# docker build --force-rm --tag "rvannauker/phpunit" --file phpunit.dockerfile .
# RUN:
# docker run --rm --volume $(pwd):/workspace --name="phpunit" "rvannauker/phpunit"
# PACKAGE: PHPUnit
# PACKAGE REPOSITORY: https://github.com/sebastianbergmann/phpunit.git
# DOCKER REPOSITORY: https://github.com/JulienBreux/phpunit-docker/blob/master/5.7.5/Dockerfile
# DESCRIPTION: The PHP Unit Testing framework
FROM alpine:latest
MAINTAINER Richard Vannauker <richard.vannauker@gmail.com>
# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL     org.label-schema.schema-version="1.0" \
          org.label-schema.build-date="$BUILD_DATE" \
          org.label-schema.version="$VERSION" \
          org.label-schema.name="" \
          org.label-schema.description="" \
          org.label-schema.vendor="SEOHEAT LLC" \
          org.label-schema.url="" \
          org.label-schema.vcs-ref="$VCS_REF" \
          org.label-schema.vcs-url="" \
          org.label-schema.usage="" \
          org.label-schema.docker.cmd="" \
          org.label-schema.docker.cmd.devel="" \
          org.label-schema.docker.cmd.test="" \
          org.label-schema.docker.cmd.debug="" \
          org.label-schema.docker.cmd.help="" \
          org.label-schema.docker.params="" \
          org.label-schema.rkt.cmd="" \
          org.label-schema.rkt.cmd.devel="" \
          org.label-schema.rkt.cmd.test="" \
          org.label-schema.rkt.cmd.debug="" \
          org.label-schema.rkt.cmd.help="" \
          org.label-schema.rkt.params="" \
          com.amazonaws.ecs.task-arn="" \
          com.amazonaws.ecs.container-name="" \
          com.amazonaws.ecs.task-definition-family="" \
          com.amazonaws.ecs.task-definition-version="" \
          com.amazonaws.ecs.cluster=""

RUN mkdir -p /workspace
WORKDIR /workspace
VOLUME /workspace

# PHP binary & extensions
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
           php7 \
           php7-json \
           php7-openssl \
           php7-phar \
           php7-dom \
           php7-pdo \
           php7-xdebug \
           php7-iconv \
           php7-mcrypt \
    && rm -rf /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && sed -i 's/\;z/z/g' /etc/php7/conf.d/xdebug.ini

# Additional tools
ADD https://phar.phpunit.de/phpunit.phar  /usr/local/bin/phpunit

# Make the tools executable
RUN chmod +x /usr/local/bin/phpunit

ENTRYPOINT ["phpunit"]