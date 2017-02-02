# BUILD:
# sudo docker build --force-rm --tag "rvannauker/phan" --file phan.dockerfile .
# RUN:
# sudo docker run --rm --volume $(pwd):/workspace --name="phan" "rvannauker/phan" --output-mode text --signature-compatibility --directory {destination}
# PACKAGE: Phan
# PACKAGE REPOSITORY: https://github.com/etsy/phan.git
# DESCRIPTION: Phan is a static analyzer for PHP. Phan prefers to avoid false-positives and attempts to prove incorrectness rather than correctness.
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
           php7-ast \
           php7-dom \
    && rm -rf /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'etsy/phan=0.8.3'

# Add path to composed tools
ENV PATH /root/.composer/vendor/bin:$PATH

RUN mkdir -p /workspace
WORKDIR /workspace

ENTRYPOINT ["phan"]