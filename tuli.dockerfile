# BUILD:
# sudo docker build --force-rm --tag "rvannauker/tuli" --file tuli.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="tuli" "rvannauker/tuli" analyze {destination}
# PACKAGE: Tuli
# PACKAGE REPOSITORY: https://github.com/ircmaxell/Tuli.git
# DESCRIPTION: A static analysis engine
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
           php5-dom \
           git \
    && rm -rf /var/cache/apk/*

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
          'ircmaxell/php-cfg=dev-master' \
          'ircmaxell/php-types=dev-master' \
	      'ircmaxell/tuli=dev-master'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["tuli"]