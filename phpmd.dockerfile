# BUILD:
# sudo docker build --force-rm --tag "rvannauker/phpmd" --file phpmd.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="phpmd" "rvannauker/phpmd" {destination} text cleancode,codesize,controversial,design,naming,unusedcode
# PACKAGE: PHPMD
# PACKAGE REPOSITORY: https://github.com/phpmd/phpmd.git
# DESCRIPTION: PHPMD is a spin-off project of PHP Depend and aims to be a PHP equivalent of the well known Java tool PMD. PHPMD can be seen as an user friendly frontend application for the raw metrics stream measured by PHP Depend.
FROM alpine:latest
MAINTAINER Richard Vannauker <richard.vannauker@directenergy.com>

# PHP binary & extensions
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
           php5 \
           php5-json \
           php5-openssl \
           php5-phar \
           php5-ctype \
           php5-dom \
    && rm -rf /var/cache/apk/*

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'phpmd/phpmd=@stable'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["phpmd"]