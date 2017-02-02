# BUILD:
# sudo docker build --force-rm --tag "rvannauker/phpanalysis" --file phpanalysis.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="phpanalysis" "rvannauker/phpanalysis" {destination}
# PACKAGE: phpanalysis
# PACKAGE REPOSITORY: https://github.com/liumingzhij26/phpanalysis.git
# DESCRIPTION: The PHP library for PHP Analysis
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
           bash \
    && rm -rf /var/cache/apk/*

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'lmz/phpanalysis=1.0.3'

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["/usr/bin/php", "/root/.composer/vendor/lmz/phpanalysis/Phpanalysis.php"]