# BUILD:
# sudo docker build --force-rm --tag "rvannauker/psalm:latest" --file psalm.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="psalm" "rvannauker/psalm:latest" {destination}
# PACKAGE: Psalm
# PACKAGE REPOSITORY: https://github.com/vimeo/psalm
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
    && rm -rf /var/cache/apk/*

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'vimeo/psalm=0.3.15'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["psalm"]