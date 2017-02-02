# BUILD:
# sudo docker build --force-rm --tag "rvannauker/phpunit" --file phpunit.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="phpunit" "rvannauker/phpunit"
# PACKAGE: PHPUnit
# PACKAGE REPOSITORY: https://github.com/sebastianbergmann/phpunit.git
# DOCKER REPOSITORY: https://github.com/JulienBreux/phpunit-docker/blob/master/5.7.5/Dockerfile
# DESCRIPTION: The PHP Unit Testing framework
FROM alpine:latest
MAINTAINER Richard Vannauker <richard.vannauker@directenergy.com>

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

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["phpunit"]


