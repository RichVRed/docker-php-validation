# BUILD:
# sudo docker build --force-rm --tag "rvannauker/php-formatter" --file php-formatter.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="php-formatter" "rvannauker/php-formatter" formatter:use:sort {destination}
# sudo docker run --rm --volume $(pwd):/workspace --name="php-formatter" "rvannauker/php-formatter" formatter:strict:fix {destination}
# sudo docker run --rm --volume $(pwd):/workspace --name="php-formatter" "rvannauker/php-formatter" formatter:header:fix {destination}
# PACKAGE: PHP Formatter
# PACKAGE REPOSITORY: https://github.com/mmoreram/php-formatter.git
# DESCRIPTION: This PHP formatter aims to provide you some bulk actions for you PHP projects to ensure their consistency
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
           php7-libsodium \
           php7-mbstring \
           php7-ctype \
           git \
    && rm -rf /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'mmoreram/php-formatter=dev-master'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["php-formatter"]