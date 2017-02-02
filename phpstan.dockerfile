# BUILD:
# sudo docker build --force-rm --tag "rvannauker/phpstan" --file phpstan.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="phpstan" "rvannauker/phpstan" analyse --level=5 --no-progress --no-interaction -vvv {destination}
# PACKAGE: PHPStan - PHP Static Analysis Tool
# PACKAGE REPOSITORY: https://github.com/phpstan/phpstan.git
# DESCRIPTION: PHP Static Analysis Tool - discover bugs in your code without running it!
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
           php7-gd \
           php7-iconv \
           php7-intl \
           php7-mbstring \
           php7-pdo_sqlite \
           php7-xml \
    && rm -rf /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'phpstan/phpstan=0.6.1'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["phpstan"]